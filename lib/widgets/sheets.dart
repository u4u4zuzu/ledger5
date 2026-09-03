import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/database.dart';
import '../providers/asset_providers.dart';
import '../services/encryption_service.dart';
import '../services/fund_api_service.dart';
import '../services/notification_service.dart';
import '../services/settings_store.dart';
import '../services/sms_parser.dart';
import '../services/stock_api_service.dart';
import '../theme.dart';

// ==================== 通用弹窗容器 ====================
Future<T?> _showSheet<T>(BuildContext context, Widget child) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => AnimatedPadding(
      // 跟随软键盘高度自动上推弹窗，避免输入框被键盘遮住
      padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Container(
        decoration: AppTheme.sheetDecoration,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(sheetContext).size.height * 0.92,
        ),
        padding: const EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 24),
        child: SingleChildScrollView(child: child),
      ),
    ),
  );
}

Widget _handle() => Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: AppTheme.line,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );

Widget _sectionTitle(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.sub),
      ),
    );

Widget _infoRow(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(width: 52, child: Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.sub))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
        ],
      ),
    );

Widget _primaryButton(String label, VoidCallback? onPressed) => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );

Widget _ghostButton(String label, VoidCallback? onPressed, {bool danger = false}) => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: danger ? const Color(0xfffff0f3) : AppTheme.bg,
          foregroundColor: danger ? AppTheme.red : AppTheme.sub,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
      ),
    );

/// 4 列分类网格
Widget _categoryGrid(List<Map<String, String>> cats, String? selected, ValueChanged<String> onPick) {
  return GridView.count(
    crossAxisCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 1.5,
    children: cats.map((c) {
      final on = selected == c['id'];
      return InkWell(
        onTap: () => onPick(c['id']!),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: on ? AppTheme.primary : AppTheme.line, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            color: on ? AppTheme.primarySoft : AppTheme.card,
          ),
          alignment: Alignment.center,
          child: Text(
            '${c['emoji']} ${c['name']}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: on ? FontWeight.w700 : FontWeight.w400,
              color: on ? AppTheme.primary : AppTheme.ink,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

/// 4 列账户网格
Widget _accountGrid(List<Account> accounts, String? selected, ValueChanged<String> onPick) {
  if (accounts.isEmpty) {
    return const Padding(padding: EdgeInsets.all(8), child: Text('暂无账户', style: TextStyle(color: AppTheme.sub)));
  }
  return GridView.count(
    crossAxisCount: 4,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 1.4,
    children: accounts.map((a) {
      final on = selected == a.id;
      return InkWell(
        onTap: () => onPick(a.id),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: on ? AppTheme.primary : AppTheme.line, width: 1.5),
            borderRadius: BorderRadius.circular(12),
            color: on ? AppTheme.primarySoft : AppTheme.card,
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            a.name,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: on ? FontWeight.w700 : FontWeight.w400,
              color: on ? AppTheme.primary : AppTheme.ink,
            ),
          ),
        ),
      );
    }).toList(),
  );
}

// ==================== 1) 记账弹窗 ====================
void openAddTransactionSheet(BuildContext context, WidgetRef ref) {
  _showSheet(context, _AddTransactionSheet(key: UniqueKey()));
}

class _AddTransactionSheet extends ConsumerStatefulWidget {
  const _AddTransactionSheet({super.key});

  @override
  ConsumerState<_AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<_AddTransactionSheet> {
  TransactionType _type = TransactionType.expense;
  String? _accountId;
  String? _toAccountId;
  String? _categoryId;
  final _amountC = TextEditingController();
  final _noteC = TextEditingController();
  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final cats = categoriesForType(_type);
    _categoryId ??= cats.first['id'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        // 收支类型分段
        Container(
          decoration: BoxDecoration(color: AppTheme.bg, borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: TransactionType.values.map((t) {
              final label = t == TransactionType.expense
                  ? '支出'
                  : t == TransactionType.income
                      ? '收入'
                      : '转账';
              final on = _type == t;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _type = t;
                    _categoryId = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: on ? AppTheme.card : Colors.transparent,
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: on ? const [AppTheme.shadow] : null,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: on ? AppTheme.primary : AppTheme.sub,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _amountC,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w800),
          decoration: const InputDecoration(
            prefixText: '¥ ',
            prefixStyle: TextStyle(fontSize: 30, color: AppTheme.ink),
            border: InputBorder.none,
            hintText: '0.00',
            hintStyle: TextStyle(fontSize: 34, color: Color(0xffc4cad6)),
          ),
        ),
        const SizedBox(height: 8),
        if (_type != TransactionType.transfer) ...[
          _sectionTitle('分类'),
          _categoryGrid(cats, _categoryId, (id) => setState(() => _categoryId = id)),
        ],
        const SizedBox(height: 6),
        _sectionTitle(_type == TransactionType.transfer ? '从 / 到' : '账户'),
        StreamBuilder<List<Account>>(
          stream: ref.read(databaseProvider).watchAllAccounts(),
          builder: (ctx, snap) {
            final accounts = snap.data ?? [];
            return Column(
              children: [
                _accountGrid(accounts, _accountId, (id) => setState(() => _accountId = id)),
                if (_type == TransactionType.transfer)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _accountGrid(
                      accounts.where((a) => a.id != _accountId).toList(),
                      _toAccountId,
                      (id) => setState(() => _toAccountId = id),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 6),
        _sectionTitle('备注'),
        TextField(
          controller: _noteC,
          decoration: const InputDecoration(
            hintText: '可选',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
        ),
        const SizedBox(height: 14),
        _sectionTitle('记录时间'),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _date,
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => _date = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.line),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: AppTheme.sub),
                const SizedBox(width: 8),
                Text('${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
                    style: const TextStyle(fontSize: 14)),
                const Spacer(),
                const Text('默认今日，点击修改', style: TextStyle(fontSize: 12, color: AppTheme.sub)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        _primaryButton('保存', _save),
        _ghostButton('取消', () => Navigator.pop(context)),
      ],
    );
  }

  Future<void> _save() async {
    final amount = double.tryParse(_amountC.text);
    if (amount == null || amount <= 0) {
      showToast(context, '请输入有效金额');
      return;
    }
    if (_accountId == null) {
      showToast(context, '请选择账户');
      return;
    }
    if (_type == TransactionType.transfer && _toAccountId == null) {
      showToast(context, '请选择转入账户');
      return;
    }

    final db = ref.read(databaseProvider);
    await db.addTransaction(TransactionsCompanion(
      accountId: Value(_accountId!),
      toAccountId: Value(_toAccountId),
      amount: Value(_type == TransactionType.expense ? -amount : amount),
      type: Value(_type),
      categoryId: Value(_categoryId),
      merchant: Value(_noteC.text.isEmpty ? null : _noteC.text),
      transactionDate: Value(_date),
      source: const Value('manual'),
    ));
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '已记录');
    }
  }

  @override
  void dispose() {
    _amountC.dispose();
    _noteC.dispose();
    super.dispose();
  }
}

// ==================== 2) 资产详情弹窗（基金/股票） ====================
void openAssetDetailSheet(BuildContext context, WidgetRef ref,
    {required bool isFund, required dynamic holding}) {
  _showSheet(context, _AssetDetailSheet(key: UniqueKey(), isFund: isFund, holding: holding));
}

class _AssetDetailSheet extends ConsumerStatefulWidget {
  final bool isFund;
  final dynamic holding;
  const _AssetDetailSheet({super.key, required this.isFund, required this.holding});

  @override
  ConsumerState<_AssetDetailSheet> createState() => _AssetDetailSheetState();
}

class _AssetDetailSheetState extends ConsumerState<_AssetDetailSheet> {
  bool _busy = false;

  String get _code => widget.isFund ? widget.holding.fundCode : widget.holding.stockCode;
  String get _name => widget.isFund ? widget.holding.fundName : widget.holding.stockName;
  double get _shares => widget.holding.totalShares;
  double get _cost => widget.holding.totalCost;
  double get _price => widget.isFund ? widget.holding.lastNav : widget.holding.lastPrice;

  @override
  Widget build(BuildContext context) {
    final mv = _shares * _price;
    final profit = mv - _cost;
    final rate = _cost > 0 ? profit / _cost * 100 : 0.0;
    final cls = profit >= 0 ? AppTheme.green : AppTheme.red;
    final unit = widget.isFund ? '净值' : '现价';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        Row(
          children: [
            Expanded(
              child: Text(_name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ),
            Text(_code, style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
          ],
        ),
        const SizedBox(height: 12),
        AppCard(
          marginBottom: 12,
          child: Column(
            children: [
              _kv('当前市值', formatMoney(mv)),
              const SizedBox(height: 6),
              _kv('${widget.isFund ? '最新净值' : '现价'}', '¥${_price.toStringAsFixed(widget.isFund ? 4 : 2)}'),
              const SizedBox(height: 6),
              _kv('持仓成本', formatMoney(_cost)),
              const SizedBox(height: 6),
              _kv(
                '累计收益',
                '${profit >= 0 ? '+' : ''}${formatMoney(profit)} (${profit >= 0 ? '+' : ''}${rate.toStringAsFixed(1)}%)',
                valueColor: cls,
              ),
            ],
          ),
        ),
        _primaryButton(_busy ? '处理中…' : '按金额加仓', _busy ? null : () => _doAmountAction(true)),
        _ghostButton('按金额减仓', _busy ? null : () => _doAmountAction(false)),
        _ghostButton('清仓', _busy ? null : _clear),
        _ghostButton('刷新$unit', _busy ? null : _refresh),
        _ghostButton('删除', _busy ? null : _delete, danger: true),
        _ghostButton('关闭', () => Navigator.pop(context)),
      ],
    );
  }

  Widget _kv(String label, String value, {Color? valueColor}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppTheme.sub)),
          Text(
            value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: valueColor ?? AppTheme.ink),
          ),
        ],
      );

  Future<void> _doAmountAction(bool isAdd) async {
    final amountC = TextEditingController();
    final priceC = TextEditingController(text: _price > 0 ? _price.toString() : '');
    await _showSheet<double>(context, StatefulBuilder(
      builder: (ctx, setSt) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),
          Text(isAdd ? '按金额加仓' : '按金额减仓', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 14),
          TextField(
            controller: amountC,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: '金额（元）',
              prefixText: '¥ ',
              border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: priceC,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: widget.isFund ? '净值（留空用最新）' : '现价（留空用最新）',
              prefixText: '¥ ',
              border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            ),
          ),
          const SizedBox(height: 14),
          _primaryButton('确认', () {
            final amt = double.tryParse(amountC.text);
            if (amt == null || amt <= 0) {
              showToast(context, '请输入有效金额');
              return;
            }
            final manual = double.tryParse(priceC.text);
            final price = (manual != null && manual > 0) ? manual : _price;
            if (price <= 0) {
              showToast(context, '价格无效，请先刷新行情或手动填写');
              return;
            }
            Navigator.pop(ctx, amt);
            _applyAmount(isAdd, amt, price);
          }),
          _ghostButton('取消', () => Navigator.pop(ctx)),
        ],
      ),
    ));
    // 金额弹窗的结果在 _applyAmount 中处理，这里仅释放控制器
    amountC.dispose();
    priceC.dispose();
  }

  Future<void> _applyAmount(bool isAdd, double amount, double price) async {
    final db = ref.read(databaseProvider);
    setState(() => _busy = true);
    try {
      final shares = amount / price;
      if (widget.isFund) {
        if (isAdd) {
          await db.addFundPosition(_code, _name, shares, amount, widget.holding.accountId, nav: price);
        } else if (shares >= _shares - 1e-9) {
          await db.deleteFundHolding(widget.holding.id);
        } else {
          await db.reduceFundPosition(_code, shares, amount, nav: price);
        }
      } else {
        if (isAdd) {
          await db.addStockPosition(_code, _name, shares, amount, widget.holding.accountId, price: price);
        } else if (shares >= _shares - 1e-9) {
          await db.deleteStockHolding(widget.holding.id);
        } else {
          await db.reduceStockPosition(_code, shares, amount, price: price);
        }
      }
      if (mounted) {
        Navigator.pop(context);
        showToast(context, isAdd ? '已加仓' : '已减仓');
      }
    } catch (e) {
      if (mounted) showToast(context, '操作失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clear() async {
    final ok = await _confirm('清仓', '确定清空 ${_name} 的全部持仓？');
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    if (widget.isFund) {
      await db.deleteFundHolding(widget.holding.id);
    } else {
      await db.deleteStockHolding(widget.holding.id);
    }
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '已清仓');
    }
  }

  Future<void> _delete() async {
    final ok = await _confirm('删除', '确定删除 ${_name} 的持仓记录？');
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    if (widget.isFund) {
      await db.deleteFundHolding(widget.holding.id);
    } else {
      await db.deleteStockHolding(widget.holding.id);
    }
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '已删除');
    }
  }

  Future<void> _refresh() async {
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    try {
      if (widget.isFund) {
        final info = await FundApiService.fetchFundInfo(_code);
        if (info != null) await db.updateFundNav(_code, info['nav'] as double);
      } else {
        final info = await StockApiService.fetchStockInfo(_code);
        if (info != null) await db.updateStockPrice(_code, info['price'] as double);
      }
      await db.recalculateInvestmentAccountBalances();
      if (mounted) showToast(context, '已刷新行情');
    } catch (_) {
      if (mounted) showToast(context, '刷新失败，请检查网络');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool?> _confirm(String title, String content) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('确定', style: TextStyle(color: AppTheme.red)),
            ),
          ],
        ),
      );
}

// ==================== 3) 添加基金 / 股票 ====================
void openAddAssetSheet(BuildContext context, WidgetRef ref, {required bool isFund}) {
  _showSheet(context, _AddAssetSheet(key: UniqueKey(), isFund: isFund));
}

class _AddAssetSheet extends ConsumerStatefulWidget {
  final bool isFund;
  const _AddAssetSheet({super.key, required this.isFund});

  @override
  ConsumerState<_AddAssetSheet> createState() => _AddAssetSheetState();
}

class _AddAssetSheetState extends ConsumerState<_AddAssetSheet> {
  final _codeC = TextEditingController();
  final _amountC = TextEditingController();
  final _nameC = TextEditingController();
  final _priceC = TextEditingController();
  String? _accountId;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final unit = widget.isFund ? '净值' : '价格';
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        Text(widget.isFund ? '添加基金持仓' : '添加股票持仓',
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        TextField(
          controller: _codeC,
          decoration: const InputDecoration(
            labelText: '代码',
            hintText: '如 005827 / 600519',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          onChanged: (v) async {
            if (v.trim().length >= 6) {
              if (widget.isFund) {
                final info = await FundApiService.fetchFundInfo(v.trim());
                if (info != null && mounted) {
                  setState(() {
                    _nameC.text = info['name'] as String;
                    _priceC.text = (info['nav'] as double).toString();
                  });
                }
              } else {
                final info = await StockApiService.fetchStockInfo(v.trim());
                if (info != null && mounted) {
                  setState(() {
                    _nameC.text = info['name'] as String;
                    _priceC.text = (info['price'] as double).toString();
                  });
                }
              }
            }
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _nameC,
          decoration: const InputDecoration(
            labelText: '名称（自动获取，可修改）',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _amountC,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '投入金额（元）',
            prefixText: '¥ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _priceC,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '$unit（自动获取，可手动填写）',
            prefixText: '¥ ',
            border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 12),
        _sectionTitle('关联投资账户'),
        StreamBuilder<List<Account>>(
          stream: ref.read(databaseProvider).watchAllAccounts(),
          builder: (ctx, snap) {
            final inv = (snap.data ?? []).where((a) => a.type == AccountType.investment).toList();
            _accountId ??= inv.isNotEmpty ? inv.first.id : null;
            if (inv.isEmpty) {
              return const Text('请先在「账户」中创建投资账户', style: TextStyle(color: AppTheme.sub));
            }
            return DropdownButtonFormField<String>(
              value: _accountId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              items: inv.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
              onChanged: (v) => setState(() => _accountId = v),
            );
          },
        ),
        const SizedBox(height: 14),
        _primaryButton(_busy ? '处理中…' : '添加', _busy ? null : _save),
        _ghostButton('取消', () => Navigator.pop(context)),
      ],
    );
  }

  Future<void> _save() async {
    final code = _codeC.text.trim();
    final amount = double.tryParse(_amountC.text);
    final price = double.tryParse(_priceC.text);
    final unit = widget.isFund ? '净值' : '价格';
    if (code.isEmpty || amount == null || amount <= 0 || _accountId == null) {
      showToast(context, '请填写完整信息');
      return;
    }
    if (price == null || price <= 0) {
      showToast(context, '请获取行情或手动填写$unit');
      return;
    }
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    try {
      final shares = amount / price;
      final name = _nameC.text.trim().isEmpty ? code : _nameC.text.trim();
      if (widget.isFund) {
        await db.addFundPosition(code, name, shares, amount, _accountId!, nav: price);
      } else {
        await db.addStockPosition(code, name, shares, amount, _accountId!, price: price);
      }
      if (mounted) {
        Navigator.pop(context);
        showToast(context, '添加成功：$name');
      }
    } catch (e) {
      if (mounted) showToast(context, '添加失败：$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _codeC.dispose();
    _amountC.dispose();
    _nameC.dispose();
    _priceC.dispose();
    super.dispose();
  }
}

// ==================== 4) 添加账户 ====================
void openAddAccountSheet(BuildContext context, WidgetRef ref) {
  _showSheet(context, _AddAccountSheet(key: UniqueKey()));
}

class _AddAccountSheet extends ConsumerStatefulWidget {
  const _AddAccountSheet({super.key});

  @override
  ConsumerState<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends ConsumerState<_AddAccountSheet> {
  final _nameC = TextEditingController();
  final _balanceC = TextEditingController();
  AccountType _type = AccountType.debit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        const Text('添加账户', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        TextField(
          controller: _nameC,
          decoration: const InputDecoration(
            labelText: '账户名称',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<AccountType>(
          value: _type,
          decoration: const InputDecoration(
            labelText: '账户类型',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          items: accountTypeOptions
              .map((t) => DropdownMenuItem(value: t, child: Text(accountMeta[t]!.label)))
              .toList(),
          onChanged: (v) => setState(() => _type = v!),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _balanceC,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '初始余额（元，可为负）',
            prefixText: '¥ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 14),
        _primaryButton('添加', _save),
        _ghostButton('取消', () => Navigator.pop(context)),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameC.text.trim();
    if (name.isEmpty) {
      showToast(context, '请输入账户名称');
      return;
    }
    final balance = double.tryParse(_balanceC.text) ?? 0.0;
    final db = ref.read(databaseProvider);
    await db.into(db.accounts).insert(AccountsCompanion(
      name: Value(name),
      type: Value(_type),
      currentBalance: Value(balance),
    ));
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '已添加账户');
    }
  }

  @override
  void dispose() {
    _nameC.dispose();
    _balanceC.dispose();
    super.dispose();
  }
}

// ==================== 5) 账户详情（调余额 / 删除） ====================
void openAccountDetailSheet(BuildContext context, WidgetRef ref, {required Account account}) {
  _showSheet(context, _AccountDetailSheet(key: UniqueKey(), account: account));
}

class _AccountDetailSheet extends ConsumerStatefulWidget {
  final Account account;
  const _AccountDetailSheet({super.key, required this.account});

  @override
  ConsumerState<_AccountDetailSheet> createState() => _AccountDetailSheetState();
}

class _AccountDetailSheetState extends ConsumerState<_AccountDetailSheet> {
  final _balanceC = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _balanceC.text = widget.account.currentBalance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final meta = accountMeta[widget.account.type]!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: meta.color, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(meta.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(widget.account.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ),
            Text(meta.label, style: const TextStyle(color: AppTheme.sub)),
          ],
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _balanceC,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: '当前余额（元）',
            prefixText: '¥ ',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 14),
        _primaryButton(_busy ? '处理中…' : '保存余额', _busy ? null : _saveBalance),
        _ghostButton('删除账户', _busy ? null : _delete, danger: true),
        _ghostButton('关闭', () => Navigator.pop(context)),
      ],
    );
  }

  Future<void> _saveBalance() async {
    final b = double.tryParse(_balanceC.text);
    if (b == null) {
      showToast(context, '请输入有效金额');
      return;
    }
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    await db.updateAccountBalance(widget.account.id, b);
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '余额已更新');
    }
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除账户'),
        content: Text('确定删除「${widget.account.name}」？该账户下的交易不会被删除但会失去关联。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除', style: TextStyle(color: AppTheme.red)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final db = ref.read(databaseProvider);
    await (db.delete(db.accounts)..where((a) => a.id.equals(widget.account.id))).go();
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '已删除账户');
    }
  }

  @override
  void dispose() {
    _balanceC.dispose();
    super.dispose();
  }
}

// ==================== 6) 短信自动记账 ====================
void openSmsSheet(BuildContext context, WidgetRef ref) {
  _showSheet(context, _SmsSheet(key: UniqueKey()));
}

class _SmsSheet extends ConsumerStatefulWidget {
  const _SmsSheet({super.key});

  @override
  ConsumerState<_SmsSheet> createState() => _SmsSheetState();
}

class _SmsSheetState extends ConsumerState<_SmsSheet> {
  final _senderC = TextEditingController();
  final _bodyC = TextEditingController();
  SmsTransaction? _parsed;
  String? _accountId;

  static const _samples = <Map<String, String>>[
    {'sender': '95555', 'bank': '招商银行', 'body': '您账户1234于2024年12月01日10:30支出200.00元，余额5000.00元'},
    {'sender': '95588', 'bank': '工商银行', 'body': '您尾号1234卡12月01日10:30支出(餐饮)38.00元，余额1000.00元'},
    {'sender': '95533', 'bank': '建设银行', 'body': '您尾号1234的储蓄卡账户12月01日10:30消费支出人民币120.00元,活期余额2000.00元'},
    {'sender': '95599', 'bank': '农业银行', 'body': '您尾号1234账户12月01日10:30完成一笔58.00元支付交易，余额3000.00元'},
    {'sender': '95566', 'bank': '中国银行', 'body': '您账户1234于12月01日支出人民币88.00元，交易后余额4000.00元'},
    {'sender': '95559', 'bank': '交通银行', 'body': '您尾号1234的卡12月01日10:30支出66.00元，可用余额6000.00元'},
  ];

  void _fillSample(Map<String, String> s) {
    _senderC.text = s['sender']!;
    _bodyC.text = s['body']!;
    _parse();
  }

  void _parse() {
    final r = SmsParser.parse(_senderC.text.trim(), _bodyC.text.trim());
    setState(() => _parsed = r);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        const Text('短信自动记账', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _samples
              .map((s) => ActionChip(
                    label: Text('${s['bank']}示例'),
                    backgroundColor: AppTheme.primarySoft,
                    labelStyle: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700),
                    onPressed: () => _fillSample(s),
                  ))
              .toList(),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _senderC,
          decoration: const InputDecoration(
            labelText: '发送方（如 95555）',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _bodyC,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: '短信内容',
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          ),
          onChanged: (_) => _parse(),
        ),
        const SizedBox(height: 12),
        if (_parsed != null) ...[
          _sectionTitle('解析结果'),
          AppCard(
            marginBottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_parsed!.bankName}（尾号 ${_parsed!.cardTail}）',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('${_parsed!.isExpense ? '支出' : '收入'}：¥${_parsed!.amount.toStringAsFixed(2)}'),
                if (_parsed!.merchant != null) Text('商户：${_parsed!.merchant}'),
                Text('余额：${_parsed!.balanceAfter.toStringAsFixed(2)}'),
              ],
            ),
          ),
          _sectionTitle('记账到账户'),
          StreamBuilder<List<Account>>(
            stream: ref.read(databaseProvider).watchAllAccounts(),
            builder: (ctx, snap) {
              final accounts = snap.data ?? [];
              _accountId ??= accounts.isNotEmpty ? accounts.first.id : null;
              return DropdownButtonFormField<String>(
                value: _accountId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
                items: accounts.map((a) => DropdownMenuItem(value: a.id, child: Text(a.name))).toList(),
                onChanged: (v) => setState(() => _accountId = v),
              );
            },
          ),
          const SizedBox(height: 12),
          _primaryButton('保存为支出', _save),
        ] else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text('输入短信后将自动解析', style: TextStyle(color: AppTheme.sub)),
          ),
        _ghostButton('关闭', () => Navigator.pop(context)),
      ],
    );
  }

  Future<void> _save() async {
    if (_parsed == null || _accountId == null) return;
    if (_parsed!.isExpense) {
      final db = ref.read(databaseProvider);
      await db.addTransaction(TransactionsCompanion(
        accountId: Value(_accountId!),
        amount: Value(-_parsed!.amount),
        type: const Value(TransactionType.expense),
        categoryId: const Value('cat_shopping'),
        merchant: Value(_parsed!.merchant ?? _parsed!.bankName),
        description: Value('${_parsed!.bankName}短信自动记账'),
        transactionDate: Value(DateTime.now()),
        source: const Value('sms'),
      ));
    } else {
      final db = ref.read(databaseProvider);
      await db.addTransaction(TransactionsCompanion(
        accountId: Value(_accountId!),
        amount: Value(_parsed!.amount),
        type: const Value(TransactionType.income),
        categoryId: const Value('cat_other_in'),
        merchant: Value(_parsed!.merchant ?? _parsed!.bankName),
        description: Value('${_parsed!.bankName}短信自动记账'),
        transactionDate: Value(DateTime.now()),
        source: const Value('sms'),
      ));
    }
    if (mounted) {
      Navigator.pop(context);
      showToast(context, '已记录短信账单');
    }
  }

  @override
  void dispose() {
    _senderC.dispose();
    _bodyC.dispose();
    super.dispose();
  }
}

// ==================== 7) 设置 ====================
void openSettingsSheet(BuildContext context, WidgetRef ref, {required VoidCallback onChanged}) {
  _showSheet(context, _SettingsSheet(key: UniqueKey(), onChanged: onChanged));
}

class _SettingsSheet extends ConsumerStatefulWidget {
  final VoidCallback onChanged;
  const _SettingsSheet({super.key, required this.onChanged});

  @override
  ConsumerState<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<_SettingsSheet> {
  late bool _encEnabled;
  late bool _autoCapture;
  bool _listenerEnabled = false;
  bool _batteryIgnoring = false;
  bool _checking = true;
  final _pwC = TextEditingController();

  @override
  void initState() {
    super.initState();
    _encEnabled = SettingsStore.current.encEnabled;
    _autoCapture = SettingsStore.current.autoCapture;
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    setState(() => _checking = true);
    try {
      final results = await Future.wait([
        notificationChannel.invokeMethod('isNotificationListenerEnabled'),
        notificationChannel.invokeMethod('isIgnoringBatteryOptimizations'),
      ]);
      if (mounted) {
        setState(() {
          _listenerEnabled = results[0] == true;
          _batteryIgnoring = results[1] == true;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _listenerEnabled = false;
          _batteryIgnoring = false;
        });
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _openListenerSettings() async {
    try {
      await notificationChannel.invokeMethod('openNotificationListenerSettings');
    } catch (_) {
      if (mounted) showToast(context, '请到系统设置 → 通知 → 高级 → 通知使用权 中开启');
    }
    // 用户从系统设置返回后状态可能变化，稍后重新检测
    Future.delayed(const Duration(milliseconds: 800), _checkStatus);
  }

  Future<void> _openBatterySettings() async {
    try {
      await notificationChannel.invokeMethod('openBatteryOptimizationSettings');
    } catch (_) {
      if (mounted) showToast(context, '请到系统设置 → 应用 → 电池 → 允许后台运行/无限制');
    }
    Future.delayed(const Duration(milliseconds: 800), _checkStatus);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _handle(),
        const Text('设置', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        AppCard(
          marginBottom: 12,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('启用加密', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Switch(
                    value: _encEnabled,
                    activeColor: AppTheme.primary,
                    onChanged: (v) async {
                      if (v) {
                        // 开启：需要设置密码
                        final ok = await _setPassword();
                        if (ok != true) return;
                      } else {
                        await SettingsStore.save(AppSettings(
                          encEnabled: false,
                          autoCapture: _autoCapture,
                        ));
                        widget.onChanged();
                      }
                      setState(() => _encEnabled = v);
                    },
                  ),
                ],
              ),
              if (!_encEnabled)
                const Text('开启后导出的账本将使用密码加密（AES-256-GCM）。',
                    style: TextStyle(fontSize: 12, color: AppTheme.sub)),
            ],
          ),
        ),
        AppCard(
          marginBottom: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('支付通知自动记账', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  Switch(
                    value: _autoCapture,
                    activeColor: AppTheme.primary,
                    onChanged: (v) async {
                      await SettingsStore.save(AppSettings(
                        encEnabled: _encEnabled,
                        salt: SettingsStore.current.salt,
                        autoCapture: v,
                      ));
                      try {
                        await notificationChannel.invokeMethod('setAutoCapture', v);
                      } catch (_) {}
                      setState(() => _autoCapture = v);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _checking
                    ? '正在检测通知监听权限…'
                    : (_listenerEnabled
                        ? '已开启：微信/支付宝收支将自动记入流水与账户'
                        : '未开启通知使用权，点击下方按钮在系统设置中开启'),
                style: const TextStyle(fontSize: 12, color: AppTheme.sub),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openListenerSettings,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _listenerEnabled ? AppTheme.primarySoft : AppTheme.primary,
                    foregroundColor: _listenerEnabled ? AppTheme.primary : Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_listenerEnabled ? '通知使用权：已开启 ✓' : '开启通知使用权'),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _openBatterySettings,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _batteryIgnoring ? AppTheme.green : AppTheme.ink,
                    side: BorderSide(color: _batteryIgnoring ? AppTheme.green : AppTheme.line),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_batteryIgnoring ? '电池优化：已忽略 ✓' : '忽略电池优化（防止后台被杀）'),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '提示：部分国产系统（小米/华为/OPPO/vivo）还需在“设置→应用→自启动/后台管理”中允许本应用自启动，并把 App 锁定在最近任务栏。',
                style: const TextStyle(fontSize: 11, color: AppTheme.sub, height: 1.4),
              ),
            ],
          ),
        ),
        _ghostButton('关于', () async {
          final info = await PackageInfo.fromPlatform();
          if (mounted) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('关于本应用'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('实时资产记账', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    _infoRow('版本', '${info.version} (build ${info.buildNumber})'),
                    _infoRow('包名', info.packageName),
                    const SizedBox(height: 10),
                    const Text('基于 Flutter + Drift/SQLite 构建，支持实时记账、基金/股票行情、支付通知与短信自动记账。',
                        style: TextStyle(fontSize: 12, color: AppTheme.sub, height: 1.5)),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('知道了')),
                ],
              ),
            );
          }
        }),
        _ghostButton('恢复演示数据', () async {
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('恢复演示数据'),
              content: const Text('这将清空当前所有数据并写入演示数据，确定继续？'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('确定', style: TextStyle(color: AppTheme.red)),
                ),
              ],
            ),
          );
          if (ok == true) {
            final db = ref.read(databaseProvider);
            await db.resetDatabase();
            if (mounted) {
              Navigator.pop(context);
              showToast(context, '已恢复演示数据');
            }
          }
        }),
        _ghostButton('关闭', () => Navigator.pop(context)),
        const SizedBox(height: 8),
        const Text(
          '说明：① 支付通知自动记账——开启「通知使用权」并「忽略电池优化」后，微信/支付宝的收支通知会自动记入流水与账户资产；部分国产系统还需允许自启动并锁定后台。\n'
          '② 短信自动记账——在「📩」中粘贴银行扣款短信可自动生成支出。\n'
          '③ 刷新行情——点右上角「⟳」同步基金净值与股票价格。',
          style: TextStyle(fontSize: 12, color: AppTheme.sub, height: 1.5),
        ),
      ],
    );
  }

  Future<bool?> _setPassword() async {
    _pwC.clear();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('设置加密密码'),
        content: TextField(
          controller: _pwC,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: '请输入密码（至少 4 位）',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () {
              if (_pwC.text.length < 4) {
                showToast(context, '密码至少 4 位');
                return;
              }
              Navigator.pop(ctx, true);
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final salt = EncryptionService.generateSaltBase64();
      EncryptionService.instance.initialize(_pwC.text, salt: salt);
      await SettingsStore.save(AppSettings(
        encEnabled: true,
        salt: salt,
        autoCapture: _autoCapture,
      ));
      widget.onChanged();
    }
    return ok;
  }

  @override
  void dispose() {
    _pwC.dispose();
    super.dispose();
  }
}
