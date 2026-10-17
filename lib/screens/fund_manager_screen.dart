import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/database.dart';
import '../providers/asset_providers.dart';
import '../theme.dart';
import '../widgets/sheets.dart';

class FundManagerScreen extends ConsumerWidget {
  const FundManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final stream = db.watchActiveFundHoldings();

    return StreamBuilder<List<FundHolding>>(
      stream: stream,
      builder: (context, snap) {
        final list = snap.data ?? [];
        final positions = list.map(_calc).toList();
        final totalCost = positions.fold(0.0, (s, p) => s + p.cost);
        final totalMv = positions.fold(0.0, (s, p) => s + p.mv);
        final profit = totalMv - totalCost;
        final rate = totalCost > 0 ? profit / totalCost * 100 : 0.0;
        // 收益部分金额（各持仓正收益之和）与亏损部分金额（各持仓负收益绝对值之和）
        final gainAmount = positions.where((p) => p.profit > 0).fold(0.0, (s, p) => s + p.profit);
        final lossAmount = positions.where((p) => p.profit < 0).fold(0.0, (s, p) => s - p.profit);

        return Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('基金总资产', style: TextStyle(fontSize: 13, color: AppTheme.sub)),
                  const SizedBox(height: 6),
                  Text(formatMoney(totalMv),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _Stat('总成本', formatMoney(totalCost)),
                      _Stat('累计收益',
                          '${profit >= 0 ? '+' : ''}${formatMoney(profit)}',
                          color: profit >= 0 ? AppTheme.green : AppTheme.red),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _Stat('收益金额',
                          '${gainAmount >= 0 ? '+' : ''}${formatMoney(gainAmount)}',
                          color: AppTheme.green),
                      _Stat('亏损金额',
                          '${lossAmount >= 0 ? '-' : ''}${formatMoney(lossAmount)}',
                          color: AppTheme.red),
                      _Stat('收益率',
                          '${rate >= 0 ? '+' : ''}${rate.toStringAsFixed(1)}%',
                          color: rate >= 0 ? AppTheme.green : AppTheme.red),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('还没有基金，点击下方「添加基金」', style: TextStyle(color: AppTheme.sub)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      itemCount: positions.length,
                      itemBuilder: (ctx, i) => _FundCard(
                        data: positions[i],
                        onTap: () => openAssetDetailSheet(context, ref, isFund: true, holding: positions[i].holding),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => openAddAssetSheet(context, ref, isFund: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('＋ 添加基金', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static _Pos _calc(FundHolding h) {
    // 持有金额 = 最新净值 × 持有份额（始终自动计算，刷新净值即更新）
    final mv = h.totalShares * h.lastNav;
    final profit = mv - h.totalCost;
    final rate = h.totalCost > 0 ? profit / h.totalCost * 100 : 0.0;
    return _Pos(holding: h, mv: mv, cost: h.totalCost, profit: profit, rate: rate);
  }

  Widget _Stat(String label, String value, {Color? color}) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
            const SizedBox(height: 3),
            Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color ?? AppTheme.ink)),
          ],
        ),
      );
}

class _Pos {
  final FundHolding holding;
  final double mv;
  final double cost;
  final double profit;
  final double rate;
  _Pos({required this.holding, required this.mv, required this.cost, required this.profit, required this.rate});
}

class _FundCard extends StatelessWidget {
  final _Pos data;
  final VoidCallback onTap;
  const _FundCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final h = data.holding;
    final cls = data.profit >= 0 ? AppTheme.green : AppTheme.red;
    return GestureDetector(
      onTap: onTap,
      child: AppCard(
        marginBottom: 12,
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.fundName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      Text(h.fundCode, style: const TextStyle(fontSize: 11, color: AppTheme.sub)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatMoney(data.mv), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const Text('持有金额', style: TextStyle(fontSize: 11, color: AppTheme.sub)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _kvFlex('持仓成本', formatMoney(data.cost)),
                _kvFlex('持有份额', '${h.totalShares.toStringAsFixed(0)} 份'),
                _kvFlex('最新净值', '¥${h.lastNav.toStringAsFixed(4)}'),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('累计收益', style: TextStyle(fontSize: 12, color: AppTheme.sub)),
                Text('${data.profit >= 0 ? '+' : ''}${formatMoney(data.profit)} (${data.rate >= 0 ? '+' : ''}${data.rate.toStringAsFixed(1)}%)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: cls)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(color: AppTheme.primarySoft, borderRadius: BorderRadius.circular(20)),
                  child: const Text('点击操作', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kvFlex(String label, String value) => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.sub)),
            const SizedBox(height: 2),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.ink)),
          ],
        ),
      );
}
