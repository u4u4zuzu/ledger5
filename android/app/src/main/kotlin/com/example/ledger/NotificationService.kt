package com.example.ledger

import android.app.Notification
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.IBinder
import android.provider.Settings
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.util.regex.Pattern

// ==================== 支付通知数据类 ====================
data class PaymentNotification(
    val source: String,
    val type: String, // expense, income
    val amount: Double,
    val merchant: String,
    val time: Long
)

// ==================== 通知监听服务 ====================
class NotificationService : NotificationListenerService(), MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "LEDGER_NOTIFY"
        const val CHANNEL = "com.example.ledger/notification"
        private const val PREFS = "ledger_notify_prefs"
        private const val KEY_PENDING = "pending"
        private const val KEY_AUTOCAP = "auto_capture"

        private val PAYMENT_PACKAGES = mapOf(
            "com.tencent.mm" to "wechat",
            "com.eg.android.AlipayGphone" to "alipay"
        )

        // 金额：优先匹配 ¥35.00 / ￥35 / ￥ 35.5 等
        private val AMOUNT_PATTERN = Pattern.compile("[¥￥]\\s?([0-9]+(?:\\.[0-9]{1,2})?)")
        // 兜底：35.00元 / 35元 / 收款12.5 等（紧跟在数字后的“元”，或数字出现在支出/收款等词后面）
        private val AMOUNT_FALLBACK_PATTERN = Pattern.compile("(?<![0-9.])([0-9]+(?:\\.[0-9]{1,2})?)\\s*[元圆]")

        // 收入关键词
        private val INCOME_KEYWORDS = listOf("收款", "收到", "收入", "转入", "退款", "收钱", "到账", "收款到账", "退款到账")

        // 支出关键词（命中其一即视为支出）
        private val EXPENSE_KEYWORDS = listOf(
            "支出", "消费", "付款", "支付", "已支付", "微信支付", "支付宝",
            "转出", "购买", "扣款", "已扣款", "交易成功", "支付成功", "已消费",
            "扫码支付", "向.*转账", "转账支出", "付款给", "支付金额", "实付"
        )

        private var instance: NotificationService? = null

        // 在 Flutter 引擎可用时绑定通道，接收 Dart 侧的调用
        fun registerChannel(engine: FlutterEngine) {
            if (instance == null) return
            MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
                .setMethodCallHandler(instance)
            Log.d(TAG, "MethodChannel 已绑定")
        }
    }

    override fun onCreate() {
        super.onCreate()
        instance = this
        Log.d(TAG, "NotificationService 已创建")
        FlutterEngineCache.getInstance().get("ledger_engine")?.let { registerChannel(it) }
    }

    override fun onBind(intent: Intent?): IBinder? {
        instance = this
        return super.onBind(intent)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // 尽量让服务在被杀后重新启动（国内 ROM 不一定生效，但仍建议保留）
        return START_STICKY
    }

    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        if (!PAYMENT_PACKAGES.containsKey(packageName)) return

        val extras = sbn.notification.extras ?: return
        val title = extras.getCharSequence(Notification.EXTRA_TITLE)?.toString() ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""
        val bigText = extras.getCharSequence(Notification.EXTRA_BIG_TEXT)?.toString() ?: ""
        val subText = extras.getCharSequence(Notification.EXTRA_SUB_TEXT)?.toString() ?: ""
        val summaryText = extras.getCharSequence(Notification.EXTRA_SUMMARY_TEXT)?.toString() ?: ""
        val titleBig = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            extras.getCharSequence(Notification.EXTRA_TITLE_BIG)?.toString() ?: ""
        } else ""

        // 微信/支付宝常把金额放在 title/bigText/subText 里，合并后一起解析
        val full = listOf(title, titleBig, bigText, text, subText, summaryText)
            .filter { it.isNotBlank() }
            .joinToString("\n")

        Log.d(TAG, "收到通知[$packageName]\ntitle=$title\ntext=$text\nbig=$bigText\nsub=$subText\nsummary=$summaryText")

        val source = PAYMENT_PACKAGES[packageName] ?: return
        val notification = parsePayment(source, title, text, full) ?: return

        Log.d(TAG, "解析成功: ${notification.source} ${notification.type} ¥${notification.amount} merchant=${notification.merchant}")
        sendToFlutter(notification)
    }

    // ==================== 解析 ====================
    private fun parsePayment(source: String, title: String, text: String, full: String): PaymentNotification? {
        // 1. 先按 ¥/￥ 取金额
        var matcher = AMOUNT_PATTERN.matcher(full)
        val amount: Double
        if (matcher.find()) {
            amount = matcher.group(1)?.toDoubleOrNull() ?: return null
        } else {
            // 2. 兜底：匹配“X元”“X圆”，但全文必须有支付/收款关键词，避免误触发普通通知
            if (!containsPaymentKeyword(full)) return null
            matcher = AMOUNT_FALLBACK_PATTERN.matcher(full)
            if (!matcher.find()) return null
            amount = matcher.group(1)?.toDoubleOrNull() ?: return null
        }
        if (amount <= 0) return null

        val type = detectType(full)

        // merchant：微信/支付宝通知常用 title 就是商户名；若 title 是“微信支付/支付宝通知”则用 text 第一行
        val merchant = when {
            title.isNotBlank() && !title.contains("微信支付") && !title.contains("支付宝") && !title.contains("支付助手") -> title
            text.isNotBlank() && !text.contains("¥") && !text.contains("￥") -> text.split("\n").firstOrNull { it.isNotBlank() } ?: text
            else -> if (source == "wechat") "微信支付" else "支付宝"
        }

        return PaymentNotification(
            source = source,
            type = type,
            amount = amount,
            merchant = merchant,
            time = System.currentTimeMillis()
        )
    }

    private fun containsPaymentKeyword(full: String): Boolean {
        return INCOME_KEYWORDS.any { full.contains(it) } || EXPENSE_KEYWORDS.any { full.contains(it) }
    }

    private fun detectType(full: String): String {
        for (kw in INCOME_KEYWORDS) {
            if (full.contains(kw)) return "income"
        }
        for (kw in EXPENSE_KEYWORDS) {
            if (full.contains(kw)) return "expense"
        }
        // 兜底：含“转账”按支出，其它一律支出
        return "expense"
    }

    // ==================== 发送到 Flutter ====================
    private fun sendToFlutter(notification: PaymentNotification) {
        if (!isAutoCaptureEnabled()) {
            Log.d(TAG, "自动记账已关闭，跳过")
            return
        }
        val engine = FlutterEngineCache.getInstance().get("ledger_engine")
        if (engine != null) {
            try {
                MethodChannel(engine.dartExecutor.binaryMessenger, CHANNEL)
                    .invokeMethod("onPaymentNotification", toJson(notification))
                Log.d(TAG, "已实时发送到 Flutter")
            } catch (e: Exception) {
                Log.e(TAG, "实时发送失败，转存待处理: ${e.message}")
                queuePending(notification)
            }
        } else {
            // App 已退出/后台：写入待处理队列，下次启动时由 Flutter 拉取
            Log.d(TAG, "Flutter engine 不可用，写入待处理队列")
            queuePending(notification)
        }
    }

    private fun toJson(n: PaymentNotification): String = JSONObject().apply {
        put("source", n.source)
        put("type", n.type)
        put("amount", n.amount)
        put("merchant", n.merchant)
        put("time", n.time)
    }.toString()

    // ==================== 待处理队列（SharedPreferences） ====================
    private fun queuePending(n: PaymentNotification) {
        try {
            val prefs = getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            val arr = JSONArray(prefs.getString(KEY_PENDING, "[]") ?: "[]")
            arr.put(toJson(n))
            prefs.edit().putString(KEY_PENDING, arr.toString()).apply()
            Log.d(TAG, "已加入待处理队列，当前 ${arr.length()} 条")
        } catch (e: Exception) {
            Log.e(TAG, "写入待处理失败: ${e.message}")
        }
    }

    private fun isAutoCaptureEnabled(): Boolean {
        return getSharedPreferences(PREFS, Context.MODE_PRIVATE)
            .getBoolean(KEY_AUTOCAP, true) // 默认开启
    }

    // ==================== Dart 侧调用的桥接方法 ====================
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "fetchPendingNotifications" -> {
                try {
                    val prefs = getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                    val pending = prefs.getString(KEY_PENDING, "[]") ?: "[]"
                    prefs.edit().putString(KEY_PENDING, "[]").apply()
                    result.success(pending)
                } catch (e: Exception) {
                    result.success("[]")
                }
            }
            "setAutoCapture" -> {
                val enabled = call.arguments as? Boolean ?: true
                getSharedPreferences(PREFS, Context.MODE_PRIVATE)
                    .edit().putBoolean(KEY_AUTOCAP, enabled).apply()
                result.success(null)
            }
            "isNotificationListenerEnabled" -> {
                result.success(isListenerEnabled())
            }
            "openNotificationListenerSettings" -> {
                try {
                    val intent = Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS)
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("OPEN_FAILED", e.message, null)
                }
            }
            "openBatteryOptimizationSettings" -> {
                try {
                    val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                        data = Uri.parse("package:$packageName")
                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    }
                    startActivity(intent)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("OPEN_FAILED", e.message, null)
                }
            }
            "isIgnoringBatteryOptimizations" -> {
                result.success(isIgnoringBatteryOptimizations())
            }
            else -> result.notImplemented()
        }
    }

    private fun isListenerEnabled(): Boolean {
        return try {
            val componentName = android.content.ComponentName(this, NotificationService::class.java)
            val enabledListeners = Settings.Secure.getString(contentResolver, "enabled_notification_listeners")
            enabledListeners?.contains(componentName.flattenToString()) == true ||
                    enabledListeners?.contains(componentName.flattenToShortString()) == true
        } catch (e: Exception) {
            Log.e(TAG, "检测监听权限失败: ${e.message}")
            false
        }
    }

    private fun isIgnoringBatteryOptimizations(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val powerManager = getSystemService(Context.POWER_SERVICE) as android.os.PowerManager
            powerManager.isIgnoringBatteryOptimizations(packageName)
        } else {
            true
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification?) {}
}
