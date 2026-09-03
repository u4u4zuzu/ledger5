import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/database.dart';

/// 数据库实例
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

/// 当前底部 Tab 索引（看板0 / 流水1 / 基金2 / 股票3 / 账户4）
/// 供跨页面跳转使用（如看板「管理 ›」跳到账户页）
final tabIndexProvider = StateProvider<int>((ref) => 0);

/// 看板「收支占比」卡片选中的月份（用于历史月份浏览），默认当月
final selectedMonthProvider = StateProvider<DateTime>(
  (ref) => DateTime(DateTime.now().year, DateTime.now().month, 1),
);

/// 看板「收支占比」卡片饼图展示的交易类型（支出/收入切换）
final monthlyPieTypeProvider = StateProvider<TransactionType>((ref) => TransactionType.expense);

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

/// 指定月份的收支统计 {income: 收入, expense: 支出}
/// key 格式：'year-month'，例如 '2025-5'
final monthlyStatsProvider = StreamProvider.family<Map<String, double>, String>((ref, key) {
  final parts = key.split('-');
  final year = int.parse(parts[0]);
  final month = int.parse(parts[1]);
  final db = ref.watch(databaseProvider);
  return db.watchMonthlyTransactions(year, month).map((transactions) {
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

/// 指定月份、指定类型的分类统计（用于饼图）
/// key 格式：'type-year-month'，例如 'expense-2025-5'
final monthlyCategoryStatsProvider = StreamProvider.family<Map<String, double>, String>((ref, key) {
  final parts = key.split('-');
  final type = TransactionType.values.byName(parts[0]);
  final year = int.parse(parts[1]);
  final month = int.parse(parts[2]);
  final db = ref.watch(databaseProvider);
  return db.watchMonthlyTransactions(year, month).map((transactions) {
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
/// 直接监听整张交易表（watchAllTransactions，不限笔数），任意记账/编辑/删除都会触发刷新。
/// 之前用 watchRecentTransactions(limit:50)+getTotalStats 的方式会因 limit 窗口漏触发，导致不实时更新。
final totalStatsProvider = StreamProvider<Map<String, double>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchAllTransactions().map((transactions) {
    double income = 0;
    double expense = 0;
    for (final tx in transactions) {
      if (tx.type == TransactionType.income) {
        income += tx.amount;
      } else if (tx.type == TransactionType.expense) {
        expense += tx.amount.abs();
      }
    }
    return {'income': income, 'expense': expense};
  });
});
