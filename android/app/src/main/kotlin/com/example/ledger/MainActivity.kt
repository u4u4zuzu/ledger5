package com.example.ledger

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngineCache

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // 缓存 engine，供 NotificationService 使用
        FlutterEngineCache.getInstance().put("ledger_engine", flutterEngine)
        // 绑定通知监听服务的 MethodChannel，使 Dart 可调用原生方法
        NotificationService.registerChannel(flutterEngine)
    }
}
