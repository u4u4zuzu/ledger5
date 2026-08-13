import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/asset_providers.dart';
import '../theme.dart';
import '../widgets/sheets.dart';

class AccountManagerScreen extends ConsumerWidget {
  const AccountManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider);

    return accounts.when(
      data: (list) {
        final total = list.fold(0.0, (s, a) => s + a.currentBalance);
        return Column(
          children: [
            AppCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('总资产', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  Text(formatMoney(total), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                itemCount: list.length,
                itemBuilder: (ctx, i) {
                  final acc = list[i];
                  final meta = accountMeta[acc.type]!;
                  return GestureDetector(
                    onTap: () => openAccountDetailSheet(context, ref, account: acc),
                    child: AppCard(
                      marginBottom: 12,
                      padding: const EdgeInsets.all(14),
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
                                Text(acc.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                                Text(meta.label, style: const TextStyle(fontSize: 12, color: AppTheme.sub)),
                              ],
                            ),
                          ),
                          Text(formatMoney(acc.currentBalance),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => openAddAccountSheet(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('＋ 添加账户', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('加载失败')),
    );
  }
}
