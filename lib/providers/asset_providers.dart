import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/database.dart';

/// 数据库实例
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

/// 当前底部 Tab 索引（看板0 / 流水1 / 基金2 / 股票3 / 账户4）
/// 供跨页面跳转使用（如看板「管理 ›」跳到账户页）
final tabIndexProvider = StateProvider<int>((ref) => 0);

/// 账户列表
final accountsProvider = StreamProvider<List<Account>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllAccounts();
});

/// 最近交易
final recentTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRecentTransactions(limit: 50);
});

/// 总资产
final totalAssetsProvider = StreamProvider<double>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchTotalAssets();
});

/// 今日交易
final todayTransactionsProvider = StreamProvider<List<Transaction>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchTodayTransactions();
});

/// 今日收支统计 {income: 收入, expense: 支出}
final todayStatsProvider = StreamProvider<Map<String, double>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchTodayTransactions().map((transactions) {
    double income = 0;
    double expense = 0;
    for (final tx in transactions) {
      if (tx.type == TransactionType.income && !tx.isDeleted) {
        income += tx.amount;
      } else if (tx.type == TransactionType.expense && !tx.isDeleted) {
        expense += tx.amount.abs();
      }
    }
    return {'income': income, 'expense': expense};
  });
});

/// 今日分类统计（保留原有功能）
final categoryStatsProvider = StreamProvider.family<Map<String, double>, TransactionType>((ref, type) {
  final db = ref.watch(databaseProvider);
  return db.watchTodayTransactions().map((transactions) {
    final Map<String, double> stats = {};
    for (final tx in transactions.where((t) => t.type == type && !t.isDeleted)) {
      final catId = tx.categoryId ?? '未分类';
      stats[catId] = (stats[catId] ?? 0) + tx.amount.abs();
    }
    return stats;
  });
});

// ==================== 新增：本月统计 ====================

/// 本月收支统计 {income: 收入, expense: 支出}
final monthlyStatsProvider = StreamProvider<Map<String, double>>((ref) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  return db.watchMonthlyTransactions(now.year, now.month).map((transactions) {
    double income = 0;
    double expense = 0;
    for (final tx in transactions) {
      if (tx.type == TransactionType.income && !tx.isDeleted) {
        income += tx.amount;
      } else if (tx.type == TransactionType.expense && !tx.isDeleted) {
        expense += tx.amount.abs();
      }
    }
    return {'income': income, 'expense': expense};
  });
});

/// 本月分类统计（用于饼图）
final monthlyCategoryStatsProvider = StreamProvider.family<Map<String, double>, TransactionType>((ref, type) {
  final db = ref.watch(databaseProvider);
  final now = DateTime.now();
  return db.watchMonthlyTransactions(now.year, now.month).map((transactions) {
    final Map<String, double> stats = {};
    for (final tx in transactions.where((t) => t.type == type && !t.isDeleted)) {
      final catId = tx.categoryId ?? '未分类';
      stats[catId] = (stats[catId] ?? 0) + tx.amount.abs();
    }
    return stats;
  });
});

// ==================== 新增：累计收支（全部时间） ====================

/// 累计收支统计（全部时间，不含删除与转账） {income: 收入, expense: 支出}
/// 基于交易表 watch，任意记账/删除操作都会触发刷新
final totalStatsProvider = StreamProvider<Map<String, double>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchRecentTransactions().asyncMap((_) => db.getTotalStats());
});
