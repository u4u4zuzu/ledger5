import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/database.dart';

/// 设计令牌 —— 与 app_preview.html 完全一致
class AppTheme {
  static const Color primary = Color(0xFF2f6df6);
  static const Color primarySoft = Color(0xFFe9f1ff);
  static const Color bg = Color(0xFFf2f4f7);
  static const Color card = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1f2530);
  static const Color sub = Color(0xFF8a93a3);
  static const Color green = Color(0xFF1ab97f);
  static const Color red = Color(0xFFf0506e);
  static const Color line = Color(0xFFeef1f5);

  static const double cardRadius = 20;
  static const double sheetRadius = 24;

  static const BoxShadow shadow = BoxShadow(
    color: Color(0x141f2530),
    blurRadius: 20,
    offset: Offset(0, 6),
  );

  /// 底部弹窗圆角容器装饰
  static BoxDecoration get cardDecoration => const BoxDecoration(
        color: card,
        borderRadius: BorderRadius.all(Radius.circular(cardRadius)),
        boxShadow: [shadow],
      );

  static BoxDecoration get sheetDecoration => const BoxDecoration(
        color: card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(sheetRadius)),
      );
}

/// 金额格式化：¥1,234.56
String formatMoney(num value) {
  final v = (value is double) ? value : value.toDouble();
  return '¥${NumberFormat('#,##0.00').format(v)}';
}

/// 统一的轻提示
void showToast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 1, milliseconds: 400),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

/// 通用白色卡片
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double marginBottom;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.marginBottom = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: padding,
      decoration: AppTheme.cardDecoration,
      child: child,
    );
  }
}

/// 账户类型 -> 中文名 / emoji / 颜色
class AccountMeta {
  final String label;
  final String emoji;
  final Color color;

  const AccountMeta(this.label, this.emoji, this.color);
}

const Map<AccountType, AccountMeta> accountMeta = {
  AccountType.cash: AccountMeta('现金', '💵', Color(0xFFff9f43)),
  AccountType.debit: AccountMeta('银行卡', '🏦', Color(0xFF9b6cff)),
  AccountType.credit: AccountMeta('信用卡', '💳', Color(0xFFf0506e)),
  AccountType.ewallet: AccountMeta('电子钱包', '💚', Color(0xFF1ab97f)),
  AccountType.investment: AccountMeta('投资账户', '📊', Color(0xFF26c6c6)),
  AccountType.other: AccountMeta('其他', '💼', Color(0xFF8a93a3)),
};

/// 分类 id -> 名称 / emoji（与 app_preview.html 对齐）
class CategoryMeta {
  final String name;
  final String emoji;

  const CategoryMeta(this.name, this.emoji);
}

const Map<String, CategoryMeta> categoryMeta = {
  'cat_food': CategoryMeta('餐饮', '🍜'),
  'cat_transport': CategoryMeta('交通', '🚌'),
  'cat_shopping': CategoryMeta('购物', '🛍️'),
  'cat_entertainment': CategoryMeta('娱乐', '🎬'),
  'cat_housing': CategoryMeta('居住', '🏠'),
  'cat_medical': CategoryMeta('医疗', '💊'),
  'cat_education': CategoryMeta('教育', '📚'),
  'cat_salary': CategoryMeta('工资', '💰'),
  'cat_investment': CategoryMeta('理财', '📈'),
  'cat_other_in': CategoryMeta('其他', '📦'),
};

String categoryName(String? id) => categoryMeta[id]?.name ?? '其他';
String categoryEmoji(String? id) => categoryMeta[id]?.emoji ?? '📦';

/// 记账页分类网格的数据（按收支类型）
List<Map<String, String>> categoriesForType(TransactionType type) {
  const all = [
    {'id': 'cat_food', 'name': '餐饮', 'emoji': '🍜'},
    {'id': 'cat_transport', 'name': '交通', 'emoji': '🚌'},
    {'id': 'cat_shopping', 'name': '购物', 'emoji': '🛍️'},
    {'id': 'cat_entertainment', 'name': '娱乐', 'emoji': '🎬'},
    {'id': 'cat_housing', 'name': '居住', 'emoji': '🏠'},
    {'id': 'cat_medical', 'name': '医疗', 'emoji': '💊'},
    {'id': 'cat_education', 'name': '教育', 'emoji': '📚'},
    {'id': 'cat_salary', 'name': '工资', 'emoji': '💰'},
    {'id': 'cat_investment', 'name': '理财', 'emoji': '📈'},
    {'id': 'cat_other_in', 'name': '其他', 'emoji': '📦'},
  ];
  if (type == TransactionType.expense) {
    return all.where((c) => c['id'] != 'cat_salary' && c['id'] != 'cat_investment' && c['id'] != 'cat_other_in').toList();
  }
  return all.where((c) => c['id'] == 'cat_salary' || c['id'] == 'cat_investment' || c['id'] == 'cat_other_in').toList();
}

/// 账户类型选项（添加账户时）
List<AccountType> get accountTypeOptions => AccountType.values;
