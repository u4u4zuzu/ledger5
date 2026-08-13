import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/database.dart';
import 'providers/asset_providers.dart';
import 'theme.dart';
import 'screens/dashboard_screen.dart';
import 'screens/account_manager_screen.dart';
import 'screens/fund_manager_screen.dart';
import 'screens/stock_manager_screen.dart';
import 'screens/transaction_list_screen.dart';
import 'services/notification_service.dart' as ns;
import 'services/settings_store.dart';
import 'services/encryption_service.dart';
import 'services/export_service.dart';
import 'services/fund_sync_service.dart';
import 'services/stock_sync_service.dart';
import 'widgets/sheets.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  // 通知栏支付消息 -> 自动记账（保留原功能）
  ns.notificationChannel.setMethodCallHandler((call) async {
    if (call.method == 'onPaymentNotification') {
      final data = jsonDecode(call.arguments as String);
      final notification = ns.PaymentNotification(
        source: data['source'] as String,
        type: data['type'] as String,
        amount: (data['amount'] as num).toDouble(),
        merchant: data['merchant'] as String,
        timestamp: data['time'] as int,
      );
      await ns.NotificationService.handlePaymentNotification(notification, db);
    }
    return null;
  });

  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWith((ref) => db),
      ],
      child: const LedgerApp(),
    ),
  );

  // 启动后补录「App 关闭期间」由通知监听捕获的待处理支付（微信/支付宝）
  ns.NotificationService.initPendingFlush(db);
}

class LedgerApp extends StatelessWidget {
  const LedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '实时资产记账',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppTheme.bg,
        primaryColor: AppTheme.primary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTheme.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppTheme.primary,
          onPrimary: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.bg,
          foregroundColor: AppTheme.ink,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            color: AppTheme.ink,
          ),
        ),
        cardTheme: CardTheme(
          color: AppTheme.card,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppTheme.primary),
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

/// 底部 Tab 定义（与 app_preview.html 一致）
class _TabDef {
  final String key;
  final String label;
  final String emoji;
  final String title;
  final Widget screen;
  const _TabDef(this.key, this.label, this.emoji, this.title, this.screen);
}

class MainNavigationScreen extends ConsumerStatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  ConsumerState<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  bool _locked = false;
  bool _refreshing = false;

  static final _tabs = <_TabDef>[
    _TabDef('dashboard', '看板', '🏠', '记账', const DashboardScreen()),
    _TabDef('txs', '流水', '📋', '交易流水', const TransactionListScreen()),
    _TabDef('funds', '基金', '📈', '基金', const FundManagerScreen()),
    _TabDef('stocks', '股票', '📊', '股票', const StockManagerScreen()),
    _TabDef('accounts', '账户', '💼', '我的账户', const AccountManagerScreen()),
  ];

  @override
  void initState() {
    super.initState();
    _initLock();
    // 启动后静默拉取一次实时行情，让基金净值 / 股票“现价”显示最新值，
    // 而不是停留在演示种子价。无网络时静默失败，保留上次同步值。
    Future.microtask(_autoRefreshQuotes);
  }

  /// 静默刷新全部行情（无 toast、不显示刷新中转），用于启动时自动同步
  Future<void> _autoRefreshQuotes() async {
    final db = ref.read(databaseProvider);
    try {
      await FundSyncService(db).syncAllFundNavs();
      await StockSyncService(db).syncAllStockPrices();
    } catch (_) {
      // 静默失败：保留上次同步值或演示种子值
    }
  }

  Future<void> _initLock() async {
    final s = await SettingsStore.load();
    if (s.encEnabled && s.salt != null) {
      setState(() => _locked = true);
    }
  }

  Future<void> _refreshAllQuotes() async {
    if (_refreshing) return;
    setState(() => _refreshing = true);
    final db = ref.read(databaseProvider);
    try {
      await FundSyncService(db).syncAllFundNavs();
      await StockSyncService(db).syncAllStockPrices();
      if (mounted) showToast(context, '已刷新全部行情');
    } catch (_) {
      if (mounted) showToast(context, '行情刷新失败，请检查网络');
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  void _onUnlock(String password) {
    final s = SettingsStore.current;
    try {
      EncryptionService.instance.initialize(password, salt: s.salt);
      setState(() => _locked = false);
    } catch (_) {
      showToast(context, '密码错误');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locked) {
      return Scaffold(
        backgroundColor: AppTheme.bg,
        body: _UnlockView(onUnlock: _onUnlock),
      );
    }

    final index = ref.watch(tabIndexProvider);
    final tab = _tabs[index];
    final showFab = tab.key == 'dashboard' || tab.key == 'txs';

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(tab.title),
        actions: [
          _AppBarIcon(icon: '📩', onTap: () => openSmsSheet(context, ref)),
          _AppBarIcon(icon: '⬇', onTap: () => exportData(context, ref)),
          _AppBarIcon(icon: '⚙', onTap: () => openSettingsSheet(context, ref, onChanged: _initLock)),
          _AppBarIcon(
            icon: _refreshing ? null : '⟳',
            loading: _refreshing,
            onTap: _refreshing ? null : _refreshAllQuotes,
          ),
        ],
      ),
      body: SafeArea(bottom: false, child: tab.screen),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: () => openAddTransactionSheet(context, ref),
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              elevation: 8,
              icon: const Icon(Icons.add),
              label: const Text('记一笔', style: TextStyle(fontWeight: FontWeight.w700)),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _BottomTabBar(
        tabs: _tabs,
        current: index,
        onTap: (i) => ref.read(tabIndexProvider.notifier).state = i,
      ),
    );
  }
}

/// AppBar 右上角图标按钮（白底圆角，与预览一致）
class _AppBarIcon extends StatelessWidget {
  final String? icon;
  final bool loading;
  final VoidCallback? onTap;

  const _AppBarIcon({this.icon, this.loading = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [AppTheme.shadow],
          ),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primary),
                )
              : Text(icon ?? '', style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}

/// 底部 5 Tab 栏（白底、圆角、emoji + 文字，选中高亮）
class _BottomTabBar extends StatelessWidget {
  final List<_TabDef> tabs;
  final int current;
  final ValueChanged<int> onTap;

  const _BottomTabBar({
    required this.tabs,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: SafeArea(
        top: false,
        child: Row(
          children: tabs.asMap().entries.map((e) {
            final i = e.key;
            final t = e.value;
            final on = i == current;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(i),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(t.emoji, style: const TextStyle(fontSize: 20, height: 1)),
                    const SizedBox(height: 3),
                    Text(
                      t.label,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                        color: on ? AppTheme.primary : AppTheme.sub,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// 启动解锁页（开启加密后展示）
class _UnlockView extends StatefulWidget {
  final ValueChanged<String> onUnlock;

  const _UnlockView({required this.onUnlock});

  @override
  State<_UnlockView> createState() => _UnlockViewState();
}

class _UnlockViewState extends State<_UnlockView> {
  final _pw = TextEditingController();
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 54)),
            const SizedBox(height: 16),
            const Text('已启用加密', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('请输入密码以解锁账本', style: TextStyle(color: AppTheme.sub)),
            const SizedBox(height: 24),
            AppCard(
              child: TextField(
                controller: _pw,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '密码',
                  border: InputBorder.none,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppTheme.sub),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: AppTheme.sub),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_pw.text.isNotEmpty) widget.onUnlock(_pw.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('解锁', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pw.dispose();
    super.dispose();
  }
}
