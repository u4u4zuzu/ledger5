import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/asset_providers.dart';
import '../models/database.dart';
import '../theme.dart';

class TransactionListScreen extends ConsumerWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txs = ref.watch(recentTransactionsProvider);

    return txs.when(
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Text('还没有交易，点下方「记一笔」开始', style: TextStyle(color: AppTheme.sub)),
          );
        }

        final groups = <String, List<Transaction>>{};
        for (final tx in list) {
          final key = DateFormat('M月d日').format(tx.transactionDate);
          groups.putIfAbsent(key, () => []).add(tx);
        }
        final keys = groups.keys.toList();

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          itemCount: keys.length,
          itemBuilder: (context, i) {
            final dayTxs = groups[keys[i]]!;
            final daySum = dayTxs.fold(0.0, (s, t) => s + (t.type == TransactionType.income ? t.amount.abs() : -t.amount.abs()));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 10, 2, 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(keys[i], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.sub)),
                      Text('${daySum >= 0 ? '+' : '-'}${formatMoney(daySum.abs())}',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: daySum >= 0 ? AppTheme.green : AppTheme.red)),
                    ],
                  ),
                ),
                AppCard(
                  marginBottom: 6,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 14),
                  child: Column(
                    children: dayTxs.map((tx) => _Tile(tx: tx, ref: ref)).toList(),
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }
}

class _Tile extends ConsumerWidget {
  final Transaction tx;
  const _Tile({required this.tx, required WidgetRef ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isExpense = tx.type == TransactionType.expense;
    final isTransfer = tx.type == TransactionType.transfer;
    final color = isTransfer ? AppTheme.primary : isExpense ? AppTheme.red : AppTheme.green;
    final sign = isExpense || isTransfer ? '-' : '+';
    final title = isTransfer ? '转账' : categoryName(tx.categoryId);
    final emoji = isTransfer ? '🔁' : (isExpense ? categoryEmoji(tx.categoryId) : '💰');

    return InkWell(
      onTap: isTransfer ? null : () => _editTx(context, ref),
      child: Dismissible(
      key: Key(tx.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 18),
        color: AppTheme.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        final ok = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('删除交易'),
            content: const Text('确定删除该笔交易？账户余额将回滚。'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('删除', style: TextStyle(color: AppTheme.red)),
              ),
            ],
          ),
        );
        if (ok == true) {
          await ref.read(databaseProvider).deleteTransaction(tx.id);
          if (context.mounted) showToast(context, '已删除并回滚余额');
        }
        return ok;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppTheme.line))),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 19)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  Builder(
                    builder: (ctx) {
                      final accounts = ref.watch(accountsProvider);
                      final accName = accounts.maybeWhen(
                        data: (list) {
                          final matches = list.where((a) => a.id == tx.accountId);
                          return matches.isNotEmpty ? matches.first.name : null;
                        },
                        orElse: () => null,
                      );
                      final sub = [if (accName != null && accName.isNotEmpty) accName, tx.merchant, tx.description]
                          .where((e) => e != null && e.isNotEmpty)
                          .join(' · ');
                      return Text(sub.isEmpty ? '手动记账' : sub,
                          style: const TextStyle(fontSize: 12, color: AppTheme.sub));
                    },
                  ),
                ],
              ),
            ),
            Text('$sign${formatMoney(tx.amount.abs())}',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
          ],
        ),
      ),
      ),
    );
  }

  void _editTx(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => _EditTxSheet(tx: tx),
    );
  }
}

/// 编辑交易：调整分类与账户（仅收入/支出，转账不支持改账户）
class _EditTxSheet extends ConsumerStatefulWidget {
  final Transaction tx;
  const _EditTxSheet({required this.tx});

  @override
  ConsumerState<_EditTxSheet> createState() => _EditTxSheetState();
}

class _EditTxSheetState extends ConsumerState<_EditTxSheet> {
  late String _categoryId;
  late String _accountId;
  late TextEditingController _amountC;
  late TextEditingController _noteC;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.tx.categoryId ?? '';
    _accountId = widget.tx.accountId;
    _amountC = TextEditingController(text: widget.tx.amount.abs().toStringAsFixed(2));
    _noteC = TextEditingController(text: widget.tx.description ?? '');
  }

  @override
  void dispose() {
    _amountC.dispose();
    _noteC.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _cats => categoriesForType(widget.tx.type);

  Future<void> _save() async {
    if (_saving) return;
    final amount = double.tryParse(_amountC.text.trim());
    if (amount == null || amount <= 0) {
      showToast(context, '请输入有效金额');
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(databaseProvider).updateTransactionFields(
            widget.tx.id,
            categoryId: _categoryId.isEmpty ? null : _categoryId,
            accountId: _accountId,
            amount: amount,
            description: _noteC.text.trim(),
          );
      if (mounted) {
        Navigator.pop(context);
        showToast(context, '已保存修改');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        showToast(context, '更新失败：$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountsProvider);
    final isExpense = widget.tx.type == TransactionType.expense;
    final title = isExpense ? '支出' : '收入';

    return AnimatedPadding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(color: AppTheme.line, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text('编辑$title', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              const Text('金额', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.sub)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.line),
                ),
                child: TextField(
                  controller: _amountC,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixText: '¥ ',
                    hintText: '0.00',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('分类', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.sub)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _cats.map((c) {
                  final selected = _categoryId == c['id'];
                  return InkWell(
                    onTap: () => setState(() => _categoryId = c['id']!),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: selected ? AppTheme.primary : AppTheme.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(c['emoji']!, style: const TextStyle(fontSize: 15)),
                          const SizedBox(width: 6),
                          Text(c['name']!,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w700, color: selected ? Colors.white : AppTheme.ink)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 18),
              const Text('账户', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.sub)),
              const SizedBox(height: 8),
              accounts.when(
                data: (list) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.line),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: list.any((a) => a.id == _accountId) ? _accountId : null,
                      hint: const Text('选择账户'),
                      items: list.map((a) => DropdownMenuItem(value: a.id, child: Text('${accountMeta[a.type]?.emoji ?? '💼'} ${a.name}'))).toList(),
                      onChanged: (v) => setState(() => _accountId = v!),
                    ),
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (_, __) => const Text('账户加载失败'),
              ),
              const SizedBox(height: 18),
              const Text('备注', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.sub)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.line),
                ),
                child: TextField(
                  controller: _noteC,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '添加备注（可选）',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('保存', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

