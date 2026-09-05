import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import '../services/fund_api_service.dart';  // ← 新增，用于基金按金额加仓/减仓
import '../services/stock_api_service.dart';  // ← 新增，用于股票按金额加仓/减仓

part 'database.g.dart';


// ==================== 枚举定义 ====================
enum AccountType { cash, debit, credit, ewallet, investment, other }
enum TransactionType { expense, income, transfer }

// ==================== 账户表 ====================
class Accounts extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString() + '_' + (1000 + DateTime.now().microsecond).toString())();
  TextColumn get name => text()();
  TextColumn get type => text().map(const AccountTypeConverter())();
  RealColumn get initialBalance => real().withDefault(const Constant(0))();
  RealColumn get currentBalance => real().withDefault(const Constant(0))();
  TextColumn get currency => text().withDefault(const Constant('CNY'))();
  TextColumn get icon => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class AccountTypeConverter extends TypeConverter<AccountType, String> {
  const AccountTypeConverter();
  @override
  AccountType fromSql(String fromDb) => AccountType.values.byName(fromDb);
  @override
  String toSql(AccountType value) => value.name;
}

// ==================== 交易流水表 ====================
class Transactions extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString() + '_' + (1000 + DateTime.now().microsecond).toString())();
  TextColumn get accountId => text().references(Accounts, #id)();
  TextColumn get toAccountId => text().references(Accounts, #id).nullable()();
  RealColumn get amount => real()();
  TextColumn get type => text().map(const TransactionTypeConverter())();
  TextColumn get categoryId => text().nullable()();
  TextColumn get merchant => text().nullable()();
  TextColumn get description => text().nullable()();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  DateTimeColumn get transactionDate => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class TransactionTypeConverter extends TypeConverter<TransactionType, String> {
  const TransactionTypeConverter();
  @override
  TransactionType fromSql(String fromDb) => TransactionType.values.byName(fromDb);
  @override
  String toSql(TransactionType value) => value.name;
}

// ==================== 分类表 ====================
class Categories extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString())();
  TextColumn get name => text()();
  TextColumn get parentId => text().nullable()();
  TextColumn get type => text().map(const TransactionTypeConverter())();
  TextColumn get icon => text().nullable()();
  IntColumn get color => integer().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 基金持仓表（合并持仓） ====================
/// 每只基金只保留一条记录，加仓减仓更新此记录
class FundHoldings extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString() + '_' + (1000 + DateTime.now().microsecond).toString())();
  TextColumn get fundCode => text()();           // 基金代码，如 005827
  TextColumn get fundName => text()();           // 基金名称
  RealColumn get totalShares => real()();        // 总持有份额（加仓增加，减仓减少）
  RealColumn get totalCost => real()();          // 总成本金额（加仓增加，减仓按比例减少）
  RealColumn get lastNav => real().withDefault(const Constant(0))();  // 最新单位净值
  RealColumn get holdingAmount => real().nullable()();  // 持有金额（手动填写的当前市值；为空则用 份额×净值 估算）
  TextColumn get accountId => text().references(Accounts, #id)();   // 关联投资账户
  DateTimeColumn get lastUpdate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 基金交易记录表（加仓/减仓流水） ====================
class FundTransactions extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString())();
  TextColumn get fundCode => text()();           // 基金代码
  TextColumn get fundName => text()();           // 基金名称
  TextColumn get operation => text()();          // buy(加仓) / sell(减仓)
  RealColumn get shares => real()();             // 份额
  RealColumn get amount => real()();             // 金额（加仓为正，减仓记录卖出金额）
  RealColumn get nav => real()();                // 交易时的净值
  DateTimeColumn get tradeDate => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 股票持仓表（合并持仓） ====================
/// 每只股票只保留一条记录，加仓减仓更新此记录
class StockHoldings extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString() + '_' + (1000 + DateTime.now().microsecond).toString())();
  TextColumn get stockCode => text()();           // 股票代码，如 600519
  TextColumn get stockName => text()();           // 股票名称
  RealColumn get totalShares => real()();        // 总持有股数（加仓增加，减仓减少）
  RealColumn get totalCost => real()();          // 总成本金额（加仓增加，减仓按比例减少）
  RealColumn get lastPrice => real().withDefault(const Constant(0))();  // 最新价格
  TextColumn get accountId => text().references(Accounts, #id)();   // 关联投资账户
  DateTimeColumn get lastUpdate => dateTime().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 股票交易记录表（加仓/减仓流水） ====================
class StockTransactions extends Table {
  TextColumn get id => text().clientDefault(() => DateTime.now().millisecondsSinceEpoch.toString())();
  TextColumn get stockCode => text()();           // 股票代码
  TextColumn get stockName => text()();           // 股票名称
  TextColumn get operation => text()();           // buy(加仓) / sell(减仓)
  RealColumn get shares => real()();              // 股数
  RealColumn get amount => real()();              // 金额（加仓为正，减仓记录卖出金额）
  RealColumn get price => real()();               // 交易时的价格
  DateTimeColumn get tradeDate => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

// ==================== 数据库类 ====================
@DriftDatabase(tables: [Accounts, Transactions, Categories, FundHoldings, FundTransactions, StockHoldings, StockTransactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      await seedDemoData();
    },
    onUpgrade: (m, from, to) async {
      // 从旧版本升级：创建股票相关表
      if (from < 2) {
        await m.createTable(stockHoldings);
        await m.createTable(stockTransactions);
      }
      // v3：基金持仓新增「持有金额」字段（手动填写当前市值）
      if (from < 3) {
        await m.addColumn(fundHoldings, fundHoldings.holdingAmount);
      }
      // v4：拆分投资账户为「基金账户」与「股票账户」
      if (from < 4) {
        // 原有的「投资账户」改名为「基金账户」
        await (update(accounts)..where((a) => a.id.equals('acc_invest'))).write(
          const AccountsCompanion(name: Value('基金账户')),
        );
        // 新增「股票账户」（若已存在则跳过）
        final stockAcc = await (select(accounts)..where((a) => a.id.equals('acc_stock'))).getSingleOrNull();
        if (stockAcc == null) {
          await into(accounts).insert(const AccountsCompanion(
            id: Value('acc_stock'),
            name: Value('股票账户'),
            type: Value(AccountType.investment),
            currentBalance: Value(0.0),
            sortOrder: Value(6),
          ));
        }
        // 把股票持仓从原投资账户迁移到股票账户
        await (update(stockHoldings)..where((s) => s.accountId.equals('acc_invest'))).write(
          const StockHoldingsCompanion(accountId: Value('acc_stock')),
        );
        // 重算两账户余额（基金账户=基金总值，股票账户=股票总值）
        await recalculateInvestmentAccountBalances();
      }
      // v5：补齐账户余额自愈——因早期版本加仓/减仓/清仓/删除未触发重算，
      // 导致「我的账户」中基金/股票账户余额过期，升级时统一重算一次
      if (from < 5) {
        await recalculateInvestmentAccountBalances();
      }
      // v6：重算口径改为「全部基金→基金账户 / 全部股票→股票账户」，
      // 不再按单条持仓 accountId 归集，修复基金账户金额与基金总资产对不上的问题。
      // 已停在 v5 的用户升级到此版本时，靠本分支再次重算自愈。
      if (from < 6) {
        await recalculateInvestmentAccountBalances();
      }
    },
  );

  // ==================== 账户方法 ====================

  Future<List<Account>> getAllAccounts() => 
      (select(accounts)..where((a) => a.isArchived.equals(false))..orderBy([(a) => OrderingTerm(expression: a.sortOrder)])).get();

  Stream<List<Account>> watchAllAccounts() =>
      (select(accounts)..where((a) => a.isArchived.equals(false))..orderBy([(a) => OrderingTerm(expression: a.sortOrder)])).watch();
  
  Future<double> getTotalAssets() async {
    final result = await customSelect(
      'SELECT SUM(current_balance) as total FROM accounts WHERE is_archived = 0',
    ).getSingle();
    return result.read<double>('total') ?? 0.0;
  }

  Stream<double> watchTotalAssets() {
    return select(accounts).watch().map((list) => 
      list.where((a) => !a.isArchived).fold(0.0, (sum, a) => sum + a.currentBalance));
  }

  // ==================== 演示数据（首次安装） ====================
  /// 与 app_preview.html 完全一致的演示数据：6 个账户 + 5 笔交易 + 基金/股票持仓
  Future<void> seedDemoData() async {
    // 1) 分类
    const cats = <List<Object>>[
      ['cat_food', '餐饮', TransactionType.expense, '🍜', 0],
      ['cat_transport', '交通', TransactionType.expense, '🚌', 1],
      ['cat_shopping', '购物', TransactionType.expense, '🛍️', 2],
      ['cat_entertainment', '娱乐', TransactionType.expense, '🎬', 3],
      ['cat_housing', '居住', TransactionType.expense, '🏠', 4],
      ['cat_medical', '医疗', TransactionType.expense, '💊', 5],
      ['cat_education', '教育', TransactionType.expense, '📚', 6],
      ['cat_salary', '工资', TransactionType.income, '💰', 7],
      ['cat_investment', '理财', TransactionType.income, '📈', 8],
      ['cat_other_in', '其他', TransactionType.income, '📦', 9],
    ];
    for (final c in cats) {
      await into(categories).insert(CategoriesCompanion(
        id: Value(c[0] as String),
        name: Value(c[1] as String),
        type: Value(c[2] as TransactionType),
        icon: Value(c[3] as String?),
        sortOrder: Value(c[4] as int),
      ));
    }

    // 2) 账户（余额与预览一致；基金账户/股票账户余额由持仓重算得到）
    const String investId = 'acc_invest';   // 基金账户
    const String stockId = 'acc_stock';     // 股票账户
    final seedAccounts = <AccountsCompanion>[
      const AccountsCompanion(
        id: Value('acc_wechat'), name: Value('微信钱包'),
        type: Value(AccountType.ewallet), currentBalance: Value(3250.5), sortOrder: Value(0),
      ),
      const AccountsCompanion(
        id: Value('acc_alipay'), name: Value('支付宝'),
        type: Value(AccountType.ewallet), currentBalance: Value(1820.0), sortOrder: Value(1),
      ),
      const AccountsCompanion(
        id: Value('acc_bank'), name: Value('招商银行'),
        type: Value(AccountType.debit), currentBalance: Value(12800.0), sortOrder: Value(2),
      ),
      const AccountsCompanion(
        id: Value('acc_cash'), name: Value('现金'),
        type: Value(AccountType.cash), currentBalance: Value(430.0), sortOrder: Value(3),
      ),
      const AccountsCompanion(
        id: Value('acc_credit'), name: Value('信用卡'),
        type: Value(AccountType.credit), currentBalance: Value(-1200.0), sortOrder: Value(4),
      ),
      const AccountsCompanion(
        id: Value(investId), name: Value('基金账户'),
        type: Value(AccountType.investment), currentBalance: Value(0.0), sortOrder: Value(5),
      ),
      const AccountsCompanion(
        id: Value(stockId), name: Value('股票账户'),
        type: Value(AccountType.investment), currentBalance: Value(0.0), sortOrder: Value(6),
      ),
    ];
    for (final a in seedAccounts) {
      await into(accounts).insert(a);
    }

    // 3) 交易（直接写入，金额带符号；余额以 seed 为准，不重复调整）
    final now = DateTime.now();
    final seedTxs = <TransactionsCompanion>[
      TransactionsCompanion(
        accountId: const Value('acc_wechat'),
        amount: const Value(-38),
        type: const Value(TransactionType.expense),
        categoryId: const Value('cat_food'),
        merchant: const Value('午饭'),
        transactionDate: Value(now.subtract(const Duration(hours: 2))),
        source: const Value('manual'),
      ),
      TransactionsCompanion(
        accountId: const Value('acc_alipay'),
        amount: const Value(-120),
        type: const Value(TransactionType.expense),
        categoryId: const Value('cat_shopping'),
        merchant: const Value('日用品'),
        transactionDate: Value(now.subtract(const Duration(hours: 26))),
        source: const Value('manual'),
      ),
      TransactionsCompanion(
        accountId: const Value('acc_bank'),
        amount: const Value(8500),
        type: const Value(TransactionType.income),
        categoryId: const Value('cat_salary'),
        merchant: const Value('工资'),
        transactionDate: Value(now.subtract(const Duration(hours: 50))),
        source: const Value('manual'),
      ),
      TransactionsCompanion(
        accountId: const Value('acc_wechat'),
        amount: const Value(-25),
        type: const Value(TransactionType.expense),
        categoryId: const Value('cat_transport'),
        merchant: const Value('地铁'),
        transactionDate: Value(now.subtract(const Duration(hours: 5))),
        source: const Value('manual'),
      ),
      TransactionsCompanion(
        accountId: const Value('acc_alipay'),
        amount: const Value(-300),
        type: const Value(TransactionType.expense),
        categoryId: const Value('cat_entertainment'),
        merchant: const Value('电影'),
        transactionDate: Value(now.subtract(const Duration(hours: 70))),
        source: const Value('manual'),
      ),
    ];
    for (final t in seedTxs) {
      await into(transactions).insert(t);
    }

    // 4) 基金持仓（份额 × 净值 = 市值，自动写入基金账户）
    await into(fundHoldings).insert(FundHoldingsCompanion(
      fundCode: const Value('005827'), fundName: const Value('易方达蓝筹精选'),
      totalShares: const Value(1200), totalCost: const Value(2820),
      lastNav: const Value(2.61), accountId: const Value(investId),
      lastUpdate: Value(now),
    ));
    await into(fundHoldings).insert(FundHoldingsCompanion(
      fundCode: const Value('110011'), fundName: const Value('易方达中小盘'),
      totalShares: const Value(500), totalCost: const Value(4900),
      lastNav: const Value(10.4), accountId: const Value(investId),
      lastUpdate: Value(now),
    ));

    // 5) 股票持仓（股数 × 现价 = 市值，自动写入股票账户）
    await into(stockHoldings).insert(StockHoldingsCompanion(
      stockCode: const Value('600519'), stockName: const Value('贵州茅台'),
      totalShares: const Value(100), totalCost: const Value(168000),
      lastPrice: const Value(1720), accountId: const Value(stockId),
      lastUpdate: Value(now),
    ));
    await into(stockHoldings).insert(StockHoldingsCompanion(
      stockCode: const Value('300750'), stockName: const Value('宁德时代'),
      totalShares: const Value(200), totalCost: const Value(37000),
      lastPrice: const Value(201), accountId: const Value(stockId),
      lastUpdate: Value(now),
    ));

    // 6) 重算账户余额：基金账户=基金总值，股票账户=股票总值
    await recalculateInvestmentAccountBalances();
  }

  /// 清空全部数据并重新写入演示数据（设置页「恢复演示数据」）
  Future<void> resetDatabase() async {
    await (delete(transactions)).go();
    await (delete(fundTransactions)).go();
    await (delete(stockTransactions)).go();
    await (delete(fundHoldings)).go();
    await (delete(stockHoldings)).go();
    await (delete(categories)).go();
    await (delete(accounts)).go();
    await seedDemoData();
  }

  Stream<List<Transaction>> watchTodayTransactions() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    return (select(transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
      .watch();
  }

    /// 按月查询交易（用于本月统计）
  Stream<List<Transaction>> watchMonthlyTransactions(int year, int month) {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);
    return (select(transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
      .watch();
  }

  /// 按年查询交易（用于年度账单）
  Stream<List<Transaction>> watchYearlyTransactions(int year) {
    final start = DateTime(year, 1, 1);
    final end = DateTime(year + 1, 1, 1);
    return (select(transactions)
      ..where((t) => t.transactionDate.isBetweenValues(start, end))
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
      .watch();
  }

  Stream<List<Transaction>> watchRecentTransactions({int limit = 50}) {
    return (select(transactions)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)])
      ..limit(limit))
      .watch();
  }

  /// 监听全部交易（不含已删除），用于累计收支统计。
  /// 不限笔数、直接监听整张表，任意记账/编辑/删除都会触发重算，避免 limit 窗口漏触发。
  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
      ..where((t) => t.isDeleted.equals(false))
      ..orderBy([(t) => OrderingTerm(expression: t.transactionDate, mode: OrderingMode.desc)]))
      .watch();
  }

  Future<Map<String, double>> getMonthlyStats(int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 1);

    final expenseResult = await customSelect(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND transaction_date >= ? AND transaction_date < ? AND is_deleted = 0',
      variables: [Variable('expense'), Variable(start), Variable(end)],
    ).getSingle();

    final incomeResult = await customSelect(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND transaction_date >= ? AND transaction_date < ? AND is_deleted = 0',
      variables: [Variable('income'), Variable(start), Variable(end)],
    ).getSingle();

    return {
      'expense': (expenseResult.read<double>('total') ?? 0.0).abs(),
      'income': incomeResult.read<double>('total') ?? 0.0,
    };
  }

  Future<Transaction> addTransaction(TransactionsCompanion tx) async {
    return transaction(() async {
      final inserted = await into(transactions).insertReturning(tx);
      
      // 统一取绝对值，避免符号不一致
      final amount = (tx.amount.value ?? 0).abs();

      if (tx.type.value == TransactionType.transfer && tx.toAccountId.value != null) {
        await _updateBalance(tx.accountId.value, -amount);
        await _updateBalance(tx.toAccountId.value!, amount);
      } else if (tx.type.value == TransactionType.expense) {
        await _updateBalance(tx.accountId.value, -amount);  // 支出扣钱
      } else if (tx.type.value == TransactionType.income) {
        await _updateBalance(tx.accountId.value, amount);    // 收入加钱
      }

      return inserted;
    });
  }

  Future<void> _updateBalance(String accountId, double delta) async {
    final account = await (select(accounts)..where((a) => a.id.equals(accountId))).getSingle();
    await (update(accounts)..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion(
        currentBalance: Value(account.currentBalance + delta),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
  
  Future<void> deleteTransaction(String id) async {
    final tx = await (select(transactions)..where((t) => t.id.equals(id))).getSingle();

    await transaction(() async {
      final amount = tx.amount.abs();

      if (tx.type == TransactionType.transfer && tx.toAccountId != null) {
        await _updateBalance(tx.accountId, amount);
        await _updateBalance(tx.toAccountId!, -amount);
      } else if (tx.type == TransactionType.expense) {
        await _updateBalance(tx.accountId, amount);       // 支出的钱加回来
      } else if (tx.type == TransactionType.income) {
        await _updateBalance(tx.accountId, -amount);      // 收入的钱扣回去
      }

      await (update(transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(isDeleted: const Value(true), updatedAt: Value(DateTime.now())),
      );
    });
  }

  Future<void> updateAccountBalance(String accountId, double newBalance) async {
    await (update(accounts)..where((a) => a.id.equals(accountId))).write(
      AccountsCompanion(currentBalance: Value(newBalance), updatedAt: Value(DateTime.now())),
    );
  }

  /// 编辑已存在交易的分类、账户、金额与备注（仅针对普通收入/支出，转账涉及双账户不在本方法处理）。
  /// 会相应地回滚旧余额（旧金额/旧账户）、写入新余额（新金额/新账户），保持账户资产准确。
  Future<void> updateTransactionFields(String id,
      {String? categoryId,
      String? accountId,
      double? amount,
      String? description,
      DateTime? transactionDate}) async {
    final old = await (select(transactions)..where((t) => t.id.equals(id))).getSingle();
    if (old.type == TransactionType.transfer) return; // 转账不在此处改账户/金额
    final newAccountId = accountId ?? old.accountId;
    final newAmount = amount ?? old.amount.abs();
    // 金额是否变化（容差比较，避免浮点误差）
    final amountChanged = amount != null && (newAmount - old.amount.abs()).abs() > 1e-9;

    await transaction(() async {
      // 1. 回滚旧余额（仅当金额或账户变化时）
      if (amountChanged || newAccountId != old.accountId) {
        if (old.type == TransactionType.expense) {
          await _updateBalance(old.accountId, old.amount.abs());
        } else if (old.type == TransactionType.income) {
          await _updateBalance(old.accountId, -old.amount.abs());
        }
      }
      // 2. 写入新余额
      if (amountChanged || newAccountId != old.accountId) {
        if (old.type == TransactionType.expense) {
          await _updateBalance(newAccountId, -newAmount);
        } else if (old.type == TransactionType.income) {
          await _updateBalance(newAccountId, newAmount);
        }
      }
      // 3. 更新字段
      await (update(transactions)..where((t) => t.id.equals(id))).write(
        TransactionsCompanion(
          categoryId: Value(categoryId ?? old.categoryId),
          accountId: Value(newAccountId),
          amount: Value(old.type == TransactionType.expense ? -newAmount : newAmount),
          description: description != null ? Value(description) : const Value.absent(),
          transactionDate: transactionDate != null ? Value(transactionDate) : const Value.absent(),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  // ==================== 基金方法 ====================

  /// 获取所有活跃基金持仓（按基金代码合并，每只基金一条记录）
  Future<List<FundHolding>> getActiveFundHoldings() =>
      (select(fundHoldings)..where((f) => f.isActive.equals(true))..orderBy([(f) => OrderingTerm(expression: f.fundCode)])).get();

  Stream<List<FundHolding>> watchActiveFundHoldings() =>
      (select(fundHoldings)..where((f) => f.isActive.equals(true))..orderBy([(f) => OrderingTerm(expression: f.fundCode)])).watch();

  /// 根据基金代码查找持仓（用于合并）
  Future<FundHolding?> findFundByCode(String fundCode) async {
    return await (select(fundHoldings)
      ..where((f) => f.fundCode.equals(fundCode))
      ..where((f) => f.isActive.equals(true)))
      .getSingleOrNull();
  }

  /// 加仓：合并到现有持仓或新建
  Future<void> addFundPosition(String fundCode, String fundName, double shares, double cost, String accountId, {double? nav}) async {
    await transaction(() async {
      final existing = await findFundByCode(fundCode);

      if (existing != null) {
        // 已存在，合并持仓
        final newShares = existing.totalShares + shares;
        final newCost = existing.totalCost + cost;

        await (update(fundHoldings)..where((f) => f.id.equals(existing.id))).write(
          FundHoldingsCompanion(
            totalShares: Value(newShares),
            totalCost: Value(newCost),
            lastNav: nav != null ? Value(nav) : const Value.absent(),
            lastUpdate: Value(DateTime.now()),
          ),
        );
      } else {
        // 新建持仓
        await into(fundHoldings).insert(FundHoldingsCompanion(
          fundCode: Value(fundCode),
          fundName: Value(fundName),
          totalShares: Value(shares),
          totalCost: Value(cost),
          lastNav: nav != null ? Value(nav) : const Value(0),
          accountId: Value(accountId),
          lastUpdate: Value(DateTime.now()),
        ));
      }

      // 记录交易流水
      await into(fundTransactions).insert(FundTransactionsCompanion(
        fundCode: Value(fundCode),
        fundName: Value(fundName),
        operation: const Value('buy'),
        shares: Value(shares),
        amount: Value(cost),
        nav: Value(nav ?? 0),
        tradeDate: Value(DateTime.now()),
      ));
    });
  }

  /// 减仓：减少份额和成本
  Future<bool> reduceFundPosition(String fundCode, double shares, double amount, {double? nav}) async {
    return await transaction(() async {
      final existing = await findFundByCode(fundCode);
      if (existing == null || existing.totalShares <= 0) return false;

      if (shares >= existing.totalShares) {
        // 全部清仓
        await (delete(fundHoldings)..where((f) => f.id.equals(existing.id))).go();
      } else {
        // 部分减仓，成本按比例减少
        final ratio = shares / existing.totalShares;
        final costToReduce = existing.totalCost * ratio;

        await (update(fundHoldings)..where((f) => f.id.equals(existing.id))).write(
          FundHoldingsCompanion(
            totalShares: Value(existing.totalShares - shares),
            totalCost: Value(existing.totalCost - costToReduce),
            lastUpdate: Value(DateTime.now()),
          ),
        );
      }

      // 记录交易流水
      await into(fundTransactions).insert(FundTransactionsCompanion(
        fundCode: Value(fundCode),
        fundName: Value(existing.fundName),
        operation: const Value('sell'),
        shares: Value(shares),
        amount: Value(amount),
        nav: Value(nav ?? existing.lastNav),
        tradeDate: Value(DateTime.now()),
      ));

      return true;
    });
  }

  /// 更新基金净值
  Future<void> updateFundNav(String fundCode, double nav) async {
    final existing = await findFundByCode(fundCode);
    if (existing == null) return;

    await (update(fundHoldings)..where((f) => f.fundCode.equals(fundCode))).write(
      FundHoldingsCompanion(
        lastNav: Value(nav),
        lastUpdate: Value(DateTime.now()),
      ),
    );
  }

  /// 获取基金交易流水
  Future<List<FundTransaction>> getFundTransactions(String fundCode) =>
      (select(fundTransactions)
        ..where((t) => t.fundCode.equals(fundCode))
        ..orderBy([(t) => OrderingTerm(expression: t.tradeDate, mode: OrderingMode.desc)]))
      .get();

 /// 删除基金持仓
  Future<void> deleteFundHolding(String id) async {
    await (delete(fundHoldings)..where((f) => f.id.equals(id))).go();
  }

  /// 直接编辑基金持仓的「持有金额」与「持仓成本」
  /// holdingAmount 为 null 表示不修改（保留原有值或继续用 份额×净值 估算）
  Future<void> updateFundHoldingValues(String id, {double? holdingAmount, double? totalCost}) async {
    final existing = await (select(fundHoldings)..where((f) => f.id.equals(id))).getSingleOrNull();
    if (existing == null) return;
    await (update(fundHoldings)..where((f) => f.id.equals(id))).write(
      FundHoldingsCompanion(
        holdingAmount: holdingAmount != null ? Value(holdingAmount) : const Value.absent(),
        totalCost: totalCost != null ? Value(totalCost) : const Value.absent(),
        lastUpdate: Value(DateTime.now()),
      ),
    );
  }

  /// 加仓（只输入金额，系统自动获取净值计算份额）
  Future<void> addFundPositionByAmount(String fundCode, String fundName, double amount, String accountId) async {
    if (amount <= 0) throw Exception('金额必须大于0');
    
    double? nav = await FundApiService.fetchFundNav(fundCode);
    if (nav == null || nav <= 0) {
      throw Exception('无法获取基金 $fundCode 的最新净值，请检查网络');
    }
    
    final shares = amount / nav;
    await addFundPosition(fundCode, fundName, shares, amount, accountId, nav: nav);
  }

  /// 减仓（只输入金额，系统自动获取净值计算份额）
  Future<bool> reduceFundPositionByAmount(String fundCode, double amount) async {
    if (amount <= 0) throw Exception('金额必须大于0');
    
    final existing = await findFundByCode(fundCode);
    if (existing == null || existing.totalShares <= 0) return false;
    
    double? nav = await FundApiService.fetchFundNav(fundCode);
    if (nav == null || nav <= 0) throw Exception('无法获取基金 $fundCode 的最新净值');
    
    final maxAmount = existing.totalShares * nav;
    
    if (amount >= maxAmount * 0.999) {
      await transaction(() async {
        await (delete(fundHoldings)..where((f) => f.id.equals(existing.id))).go();
        await into(fundTransactions).insert(FundTransactionsCompanion(
          fundCode: Value(fundCode),
          fundName: Value(existing.fundName),
          operation: const Value('sell'),
          shares: Value(existing.totalShares),
          amount: Value(maxAmount),
          nav: Value(nav),
          tradeDate: Value(DateTime.now()),
        ));
      });
      return true;
    }
    
    final shares = amount / nav;
    if (shares > existing.totalShares) {
      throw Exception('减仓金额超过持仓市值，最多可减 ¥${maxAmount.toStringAsFixed(2)}');
    }
    
    final ratio = shares / existing.totalShares;
    final costToReduce = existing.totalCost * ratio;
    
    await transaction(() async {
      await (update(fundHoldings)..where((f) => f.id.equals(existing.id))).write(
        FundHoldingsCompanion(
          totalShares: Value(existing.totalShares - shares),
          totalCost: Value(existing.totalCost - costToReduce),
          lastUpdate: Value(DateTime.now()),
        ),
      );
      
      await into(fundTransactions).insert(FundTransactionsCompanion(
        fundCode: Value(fundCode),
        fundName: Value(existing.fundName),
        operation: const Value('sell'),
        shares: Value(shares),
        amount: Value(amount),
        nav: Value(nav),
        tradeDate: Value(DateTime.now()),
      ));
    });
    
    return true;
  }
  // ==================== 股票方法 ====================

  /// 获取所有活跃股票持仓（按股票代码合并，每只股票一条记录）
  Future<List<StockHolding>> getActiveStockHoldings() =>
      (select(stockHoldings)..where((f) => f.isActive.equals(true))..orderBy([(f) => OrderingTerm(expression: f.stockCode)])).get();

  Stream<List<StockHolding>> watchActiveStockHoldings() =>
      (select(stockHoldings)..where((f) => f.isActive.equals(true))..orderBy([(f) => OrderingTerm(expression: f.stockCode)])).watch();

  /// 根据股票代码查找持仓（用于合并）
  Future<StockHolding?> findStockByCode(String stockCode) async {
    return await (select(stockHoldings)
      ..where((f) => f.stockCode.equals(stockCode))
      ..where((f) => f.isActive.equals(true)))
      .getSingleOrNull();
  }

  /// 加仓：合并到现有持仓或新建
  Future<void> addStockPosition(String stockCode, String stockName, double shares, double cost, String accountId, {double? price}) async {
    await transaction(() async {
      final existing = await findStockByCode(stockCode);

      if (existing != null) {
        // 已存在，合并持仓
        final newShares = existing.totalShares + shares;
        final newCost = existing.totalCost + cost;

        await (update(stockHoldings)..where((f) => f.id.equals(existing.id))).write(
          StockHoldingsCompanion(
            totalShares: Value(newShares),
            totalCost: Value(newCost),
            lastPrice: price != null ? Value(price) : const Value.absent(),
            lastUpdate: Value(DateTime.now()),
          ),
        );
      } else {
        // 新建持仓
        await into(stockHoldings).insert(StockHoldingsCompanion(
          stockCode: Value(stockCode),
          stockName: Value(stockName),
          totalShares: Value(shares),
          totalCost: Value(cost),
          lastPrice: price != null ? Value(price) : const Value(0),
          accountId: Value(accountId),
          lastUpdate: Value(DateTime.now()),
        ));
      }

      // 记录交易流水
      await into(stockTransactions).insert(StockTransactionsCompanion(
        stockCode: Value(stockCode),
        stockName: Value(stockName),
        operation: const Value('buy'),
        shares: Value(shares),
        amount: Value(cost),
        price: Value(price ?? 0),
        tradeDate: Value(DateTime.now()),
      ));
    });
  }

  /// 减仓：减少股数和成本
  Future<bool> reduceStockPosition(String stockCode, double shares, double amount, {double? price}) async {
    return await transaction(() async {
      final existing = await findStockByCode(stockCode);
      if (existing == null || existing.totalShares <= 0) return false;

      if (shares >= existing.totalShares) {
        // 全部清仓
        await (delete(stockHoldings)..where((f) => f.id.equals(existing.id))).go();
      } else {
        // 部分减仓，成本按比例减少
        final ratio = shares / existing.totalShares;
        final costToReduce = existing.totalCost * ratio;

        await (update(stockHoldings)..where((f) => f.id.equals(existing.id))).write(
          StockHoldingsCompanion(
            totalShares: Value(existing.totalShares - shares),
            totalCost: Value(existing.totalCost - costToReduce),
            lastUpdate: Value(DateTime.now()),
          ),
        );
      }

      // 记录交易流水
      await into(stockTransactions).insert(StockTransactionsCompanion(
        stockCode: Value(stockCode),
        stockName: Value(existing.stockName),
        operation: const Value('sell'),
        shares: Value(shares),
        amount: Value(amount),
        price: Value(price ?? existing.lastPrice),
        tradeDate: Value(DateTime.now()),
      ));

      return true;
    });
  }

  /// 更新股票价格
  Future<void> updateStockPrice(String stockCode, double price) async {
    final existing = await findStockByCode(stockCode);
    if (existing == null) return;

    await (update(stockHoldings)..where((f) => f.stockCode.equals(stockCode))).write(
      StockHoldingsCompanion(
        lastPrice: Value(price),
        lastUpdate: Value(DateTime.now()),
      ),
    );
  }

  /// 获取股票交易流水
  Future<List<StockTransaction>> getStockTransactions(String stockCode) =>
      (select(stockTransactions)
        ..where((t) => t.stockCode.equals(stockCode))
        ..orderBy([(t) => OrderingTerm(expression: t.tradeDate, mode: OrderingMode.desc)]))
        .get();

  /// 删除股票持仓
  Future<void> deleteStockHolding(String id) async {
    await (delete(stockHoldings)..where((f) => f.id.equals(id))).go();
  }

  /// 直接编辑股票持仓的「持有股数」与「持仓成本」
  /// 任一参数为 null 表示不修改
  Future<void> updateStockHoldingValues(String id, {double? totalShares, double? totalCost}) async {
    final existing = await (select(stockHoldings)..where((f) => f.id.equals(id))).getSingleOrNull();
    if (existing == null) return;
    await (update(stockHoldings)..where((f) => f.id.equals(id))).write(
      StockHoldingsCompanion(
        totalShares: totalShares != null ? Value(totalShares) : const Value.absent(),
        totalCost: totalCost != null ? Value(totalCost) : const Value.absent(),
        lastUpdate: Value(DateTime.now()),
      ),
    );
  }

  /// 加仓（只输入金额，系统自动获取价格计算股数）
  Future<void> addStockPositionByAmount(String stockCode, String stockName, double amount, String accountId) async {
    if (amount <= 0) throw Exception('金额必须大于0');

    double? price = await StockApiService.fetchStockPrice(stockCode);
    if (price == null || price <= 0) {
      throw Exception('无法获取股票 $stockCode 的最新价格，请检查网络');
    }

    final shares = amount / price;
    await addStockPosition(stockCode, stockName, shares, amount, accountId, price: price);
  }

  /// 减仓（只输入金额，系统自动获取价格计算股数）
  Future<bool> reduceStockPositionByAmount(String stockCode, double amount) async {
    if (amount <= 0) throw Exception('金额必须大于0');

    final existing = await findStockByCode(stockCode);
    if (existing == null || existing.totalShares <= 0) return false;

    double? price = await StockApiService.fetchStockPrice(stockCode);
    if (price == null || price <= 0) throw Exception('无法获取股票 $stockCode 的最新价格');

    final maxAmount = existing.totalShares * price;

    if (amount >= maxAmount * 0.999) {
      await transaction(() async {
        await (delete(stockHoldings)..where((f) => f.id.equals(existing.id))).go();
        await into(stockTransactions).insert(StockTransactionsCompanion(
          stockCode: Value(stockCode),
          stockName: Value(existing.stockName),
          operation: const Value('sell'),
          shares: Value(existing.totalShares),
          amount: Value(maxAmount),
          price: Value(price),
          tradeDate: Value(DateTime.now()),
        ));
      });
      return true;
    }

    final shares = amount / price;
    if (shares > existing.totalShares) {
      throw Exception('减仓金额超过持仓市值，最多可减 ¥${maxAmount.toStringAsFixed(2)}');
    }

    final ratio = shares / existing.totalShares;
    final costToReduce = existing.totalCost * ratio;

    await transaction(() async {
      await (update(stockHoldings)..where((f) => f.id.equals(existing.id))).write(
        StockHoldingsCompanion(
          totalShares: Value(existing.totalShares - shares),
          totalCost: Value(existing.totalCost - costToReduce),
          lastUpdate: Value(DateTime.now()),
        ),
      );

      await into(stockTransactions).insert(StockTransactionsCompanion(
        stockCode: Value(stockCode),
        stockName: Value(existing.stockName),
        operation: const Value('sell'),
        shares: Value(shares),
        amount: Value(amount),
        price: Value(price),
        tradeDate: Value(DateTime.now()),
      ));
    });

    return true;
  }

  /// 重算所有投资账户余额
  /// 约定：基金账户(acc_invest) = 全部基金市值；股票账户(acc_stock) = 全部股票市值。
  /// 不再按单条持仓的 accountId 归集，避免「加基金时选错关联账户」导致基金账户金额对不上基金总资产。
  Future<void> recalculateInvestmentAccountBalances() async {
    final accounts = await getAllAccounts();
    final fundHoldings = await getActiveFundHoldings();
    final stockHoldings = await getActiveStockHoldings();

    // 全部基金市值 / 全部股票市值（与「基金页/股票页」总资产口径一致）
    final totalFund = fundHoldings.fold(0.0, (s, f) => s + (f.holdingAmount ?? (f.totalShares * f.lastNav)));
    final totalStock = stockHoldings.fold(0.0, (s, x) => s + x.totalShares * x.lastPrice);

    for (final acc in accounts) {
      if (acc.type != AccountType.investment) continue;
      if (acc.id == 'acc_invest') {
        await updateAccountBalance(acc.id, totalFund);
      } else if (acc.id == 'acc_stock') {
        await updateAccountBalance(acc.id, totalStock);
      } else {
        // 其它自定义投资类账户：按原持仓归集（兼容扩展）
        final fv = fundHoldings
            .where((f) => f.accountId == acc.id)
            .fold(0.0, (s, f) => s + (f.holdingAmount ?? (f.totalShares * f.lastNav)));
        final sv = stockHoldings
            .where((s) => s.accountId == acc.id)
            .fold(0.0, (s, x) => s + x.totalShares * x.lastPrice);
        await updateAccountBalance(acc.id, fv + sv);
      }
    }
  }

  /// 累计收支统计（全部时间，不含删除与转账） {income: 收入, expense: 支出}
  Future<Map<String, double>> getTotalStats() async {
    final expenseResult = await customSelect(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND is_deleted = 0',
      variables: [Variable('expense')],
    ).getSingle();

    final incomeResult = await customSelect(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ? AND is_deleted = 0',
      variables: [Variable('income')],
    ).getSingle();

    return {
      'expense': (expenseResult.read<double>('total') ?? 0.0).abs(),
      'income': incomeResult.read<double>('total') ?? 0.0,
    };
  }
}  // ← AppDatabase 类的结束大括号！

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'ledger.sqlite'));
    return NativeDatabase(file);
  });
}
