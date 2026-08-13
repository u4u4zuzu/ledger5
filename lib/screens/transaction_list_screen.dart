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

    return Dismissible(
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
    );
  }
}
