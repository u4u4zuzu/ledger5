import 'dart:io';

import 'package:csv/csv.dart';
import 'package:drift/drift.dart' show OrderingTerm, OrderingMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../models/database.dart';
import '../providers/asset_providers.dart';
import '../services/encryption_service.dart';
import '../services/settings_store.dart';
import '../theme.dart';

/// 导出全部交易为 CSV（启用加密时先加密再分享）
Future<void> exportData(BuildContext context, WidgetRef ref) async {
  try {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }

    final db = ref.read(databaseProvider);
    final accounts = await db.getAllAccounts();
    final txs = await (db.select(db.transactions)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([
            (t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)
          ]))
        .get();

    final accountName = {for (final a in accounts) a.id: a.name};

    final rows = <List<dynamic>>[
      ['日期', '类型', '分类', '金额', '账户', '对方/备注', '来源'],
    ];
    for (final t in txs) {
      final type = t.type == TransactionType.expense
          ? '支出'
          : t.type == TransactionType.income
              ? '收入'
              : '转账';
      final category = t.categoryId != null ? categoryName(t.categoryId) : '';
      final note = [t.merchant, t.description].where((e) => e != null && e.isNotEmpty).join(' · ');
      rows.add([
        t.transactionDate.toLocal().toString().replaceFirst('.000', ''),
        type,
        category,
        t.amount.toStringAsFixed(2),
        accountName[t.accountId] ?? t.accountId,
        note,
        t.source,
      ]);
    }

    final csv = const ListToCsvConverter().convert(rows);
    final encEnabled = SettingsStore.current.encEnabled;
    if (encEnabled && !EncryptionService.instance.isInitialized) {
      if (context.mounted) showToast(context, '请先在设置中解锁后再导出');
      return;
    }

    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final payload = encEnabled ? EncryptionService.instance.encryptText(csv) : csv;
    final ext = encEnabled ? 'csv.enc' : 'csv';
    final file = File('${dir.path}/ledger_export_$stamp.$ext');
    await file.writeAsString(payload);

    await Share.shareXFiles(
      [XFile(file.path)],
      subject: '账本导出${encEnabled ? '（已加密）' : ''}',
      text: encEnabled ? '该文件已加密，请用相同密码解密' : '账本导出',
    );

    if (context.mounted) {
      showToast(context, encEnabled ? '已导出加密文件' : '已导出 CSV');
    }
  } catch (e) {
    if (context.mounted) showToast(context, '导出失败：$e');
  }
}
