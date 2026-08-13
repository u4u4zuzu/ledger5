import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:drift/drift.dart';
import '../models/database.dart';
import 'settings_store.dart';

/// 通知栏支付消息通道（与原生 NotificationService 共用）
final MethodChannel notificationChannel = MethodChannel('com.example.ledger/notification');

class PaymentNotification {
  final String source;
  final String type;
  final double amount;
  final String merchant;
  final int timestamp;

  PaymentNotification({
    required this.source,
    required this.type,
    required this.amount,
    required this.merchant,
    required this.timestamp,
  });

  factory PaymentNotification.fromJson(Map<String, dynamic> j) => PaymentNotification(
        source: j['source'] as String,
        type: j['type'] as String,
        amount: (j['amount'] as num).toDouble(),
        merchant: (j['merchant'] as String?) ?? '',
        timestamp: (j['time'] as int?) ?? DateTime.now().millisecondsSinceEpoch,
      );
}

class NotificationService {
  /// 处理支付通知，自动去重并添加交易（同时更新账户余额）
  static Future<Transaction?> handlePaymentNotification(
    PaymentNotification notification,
    AppDatabase db,
  ) async {
    // 用户关闭了自动记账则跳过
    if (!SettingsStore.current.autoCapture) {
      await SettingsStore.load();
      if (!SettingsStore.current.autoCapture) return null;
    }

    final isExpense = notification.type == 'expense' || notification.type == 'transfer_out';
    final amount = notification.amount.abs();
    if (amount <= 0) return null;

    // 去重检查（5 分钟内相同金额，按绝对值比较）
    final isDup = await _isDuplicateTransaction(db, amount);
    if (isDup) {
      print('⏭️ 跳过重复交易: ${notification.merchant} ¥$amount');
      return null;
    }

    final accountId = _getDefaultAccountId(notification.source);

    final tx = await db.addTransaction(TransactionsCompanion(
      accountId: Value(accountId),
      amount: Value(isExpense ? -amount : amount),
      type: Value(isExpense ? TransactionType.expense : TransactionType.income),
      categoryId: Value(isExpense ? 'cat_shopping' : 'cat_other_in'),
      merchant: Value(notification.merchant),
      description: Value('${notification.source}自动记账'),
      source: Value('auto_${notification.source}'),
      transactionDate: Value(DateTime.now()),
      createdAt: Value(DateTime.now()),
    ));

    print('✅ 自动记账成功 [${notification.source}] ¥$amount');
    return tx;
  }

  /// 启动时从原生拉取「App 关闭期间」捕获的待处理通知并处理
  static Future<void> initPendingFlush(AppDatabase db) async {
    try {
      final result = await notificationChannel.invokeMethod('fetchPendingNotifications');
      if (result is String && result.isNotEmpty && result != '[]') {
        final list = jsonDecode(result) as List<dynamic>;
        for (final item in list) {
          final n = PaymentNotification.fromJson(item as Map<String, dynamic>);
          await handlePaymentNotification(n, db);
        }
        print('✅ 已补录 ${list.length} 条待处理支付通知');
      }
    } catch (e) {
      print('⚠️ 拉取待处理通知失败: $e');
    }
  }

  static Future<bool> _isDuplicateTransaction(AppDatabase db, double amount, {int minutes = 5}) async {
    final cutoff = DateTime.now().subtract(Duration(minutes: minutes));
    final normalized = (amount * 100).round() / 100;

    final recent = await (db.select(db.transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..where((t) => t.createdAt.isBiggerThanValue(cutoff))
          ..where((t) =>
              t.amount.isBetweenValues(normalized - 0.005, normalized + 0.005) |
              t.amount.isBetweenValues(-normalized - 0.005, -normalized + 0.005))
          ..limit(1))
        .getSingleOrNull();

    return recent != null;
  }

  static String _getDefaultAccountId(String source) {
    switch (source) {
      case 'wechat': return 'acc_wechat';
      case 'alipay': return 'acc_alipay';
      case 'cmb': return 'acc_cmb';
      case 'icbc': return 'acc_icbc';
      case 'ccb': return 'acc_ccb';
      case 'abc': return 'acc_abc';
      case 'boc': return 'acc_boc';
      case 'comm': return 'acc_comm';
      default: return 'acc_cash';
    }
  }
}
