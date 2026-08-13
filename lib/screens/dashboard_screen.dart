import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/asset_providers.dart';
import '../models/database.dart';
import '../theme.dart';
import '../widgets/sheets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  static const _piePalette = [
    Color(0xfff0506e),
    Color(0xffff9f43),
    Color(0xff54a0ff),
    Color(0xff1ab97f),
    Color(0xff9b6cff),
    Color(0xff26c6c6),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalAssets = ref.watch(totalAssetsProvider);
    final todayStats = ref.watch(todayStatsProvider);
    final totalStats = ref.watch(totalStatsProvider);
    final monthlyCat = ref.watch(monthlyCategoryStatsProvider(TransactionType.expense));
    final accounts = ref.watch(accountsProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // 净资产
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              accounts.when(
                data: (list) => Text('净资产（共 ${list.length} 个账户）',
                    style: const TextStyle(fontSize: 13, color: AppTheme.sub)),
                loading: () => const Text('净资产', style: TextStyle(fontSize: 13, color: AppTheme.sub)),
                error: (_, __) => const Text('净资产', style: TextStyle(fontSize: 13, color: AppTheme.sub)),
              ),
              const SizedBox(height: 6),
              totalAssets.when(
                data: (v) => Text(formatMoney(v),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 0.5)),
                loading: () => const Text('¥ --', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
                error: (_, __) => const Text('¥ --', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat('今日收入',
                        todayStats.when(
                          data: (s) => formatMoney(s['income'] ?? 0),
                          loading: () => '--',
                          error: (_, __) => '--',
                        ),
                        AppTheme.green),
                  ),
                  Expanded(
                    child: _MiniStat('今日支出',
                        todayStats.when(
                          data: (s) => formatMoney(s['expense'] ?? 0),
                          loading: () => '--',
                          error: (_, __) => '--',
                        ),
                        AppTheme.red),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 累计收支
        Row(
          children: [
            Expanded(
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('累计收入', style: TextStyle(fontSize: 12, color: AppTheme.sub)),
                    const SizedBox(height: 6),
                    totalStats.when(
                      data: (s) => Text(formatMoney(s['income'] ?? 0),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.green)),
                      loading: () => const Text('--', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      error: (_, __) => const Text('--', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('累计支出', style: TextStyle(fontSize: 12, color: AppTheme.sub)),
                    const SizedBox(height: 6),
                    totalStats.when(
                      data: (s) => Text(formatMoney(s['expense'] ?? 0),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.red)),
                      loading: () => const Text('--', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                      error: (_, __) => const Text('--', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // 本月支出占比
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('本月支出占比', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primarySoft,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${DateTime.now().month} 月',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              monthlyCat.when(
                data: (stats) {
                  if (stats.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Text('本月暂无支出', style: TextStyle(color: AppTheme.sub)),
                      ),
                    );
                  }
                  final entries = stats.entries.toList()
                    ..sort((a, b) => b.value.compareTo(a.value));
                  final total = entries.fold(0.0, (s, e) => s + e.value);
                  return Row(
                    children: [
                      // 注意：fl_chart 的扇形外半径 = centerSpaceRadius + section.radius，
                      // 必须 ≤ 盒子边长的一半，否则会溢出卡片。此处 34 + 28 = 62 ≤ 70。
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 34,
                            sections: entries.asMap().entries.map((e) {
                              final idx = e.key;
                              final entry = e.value;
                              return PieChartSectionData(
                                color: _piePalette[idx % _piePalette.length],
                                value: entry.value,
                                radius: 28,
                                title: '',
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          children: entries.map((e) {
                            final pct = total > 0 ? (e.value / total * 100) : 0.0;
                            final color = _piePalette[entries.indexOf(e) % _piePalette.length];
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3.5),
                              child: Row(
                                children: [
                                  Container(width: 11, height: 11, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
                                  const SizedBox(width: 7),
                                  Expanded(child: Text(categoryName(e.key), style: const TextStyle(fontSize: 12))),
                                  Text(formatMoney(e.value), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                                  const SizedBox(width: 8),
                                  Text('${pct.toStringAsFixed(1)}%',
                                      style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox(height: 120, child: Center(child: Text('加载失败'))),
              ),
            ],
          ),
        ),

        // 我的账户
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('我的账户', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  GestureDetector(
                    onTap: () => ref.read(tabIndexProvider.notifier).state = 4,
                    child: const Text('管理 ›', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              accounts.when(
                data: (list) => list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('暂无账户', style: TextStyle(color: AppTheme.sub)),
                      )
                    : Column(
                        children: list.map((acc) {
                          final meta = accountMeta[acc.type]!;
                          return InkWell(
                            onTap: () => openAccountDetailSheet(context, ref, account: acc),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: AppTheme.line)),
                              ),
                              child: Row(
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
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(acc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                                        Text(meta.label, style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
                                      ],
                                    ),
                                  ),
                                  Text(formatMoney(acc.currentBalance),
                                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _MiniStat(String label, String value, Color color) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
        ],
      );
}
