import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/database.dart';
import '../providers/asset_providers.dart';
import '../theme.dart';
import '../widgets/sheets.dart';

class StockManagerScreen extends ConsumerWidget {
  const StockManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.read(databaseProvider);
    final stream = db.watchActiveStockHoldings();

    return StreamBuilder<List<StockHolding>>(
      stream: stream,
      builder: (context, snap) {
        final list = snap.data ?? [];
        final positions = list.map(_calc).toList();
        final totalCost = positions.fold(0.0, (s, p) => s + p.cost);
        final totalMv = positions.fold(0.0, (s, p) => s + p.mv);
        final profit = totalMv - totalCost;
        final rate = totalCost > 0 ? profit / totalCost * 100 : 0.0;

        return Column(
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('股票总资产', style: TextStyle(fontSize: 13, color: AppTheme.sub)),
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
                      child: Text('还没有股票，点击下方「添加股票」', style: TextStyle(color: AppTheme.sub)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      itemCount: positions.length,
                      itemBuilder: (ctx, i) => _StockCard(
                        data: positions[i],
                        onTap: () => openAssetDetailSheet(context, ref, isFund: false, holding: positions[i].holding),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => openAddAssetSheet(context, ref, isFund: false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('＋ 添加股票', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static _Pos _calc(StockHolding h) {
    final mv = h.totalShares * h.lastPrice;
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
  final StockHolding holding;
  final double mv;
  final double cost;
  final double profit;
  final double rate;
  _Pos({required this.holding, required this.mv, required this.cost, required this.profit, required this.rate});
}

class _StockCard extends StatelessWidget {
  final _Pos data;
  final VoidCallback onTap;
  const _StockCard({required this.data, required this.onTap});

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
                      Text(h.stockName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                      Text('${h.stockCode} · 持有 ${h.totalShares.toStringAsFixed(0)} 股',
                          style: const TextStyle(fontSize: 11, color: AppTheme.sub)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(formatMoney(data.mv), style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                    Text('${data.profit >= 0 ? '+' : ''}${formatMoney(data.profit)} (${data.rate >= 0 ? '+' : ''}${data.rate.toStringAsFixed(1)}%)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: cls)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('现价 ¥${h.lastPrice.toStringAsFixed(2)} · 成本 ¥${(h.totalCost / h.totalShares).toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
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
}
