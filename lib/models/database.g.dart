// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          (1000 + DateTime.now().microsecond).toString());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<AccountType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<AccountType>($AccountsTable.$convertertype);
  static const VerificationMeta _initialBalanceMeta =
      const VerificationMeta('initialBalance');
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
      'initial_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currentBalanceMeta =
      const VerificationMeta('currentBalance');
  @override
  late final GeneratedColumn<double> currentBalance = GeneratedColumn<double>(
      'current_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _currencyMeta =
      const VerificationMeta('currency');
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
      'currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('CNY'));
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _isArchivedMeta =
      const VerificationMeta('isArchived');
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
      'is_archived', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_archived" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        type,
        initialBalance,
        currentBalance,
        currency,
        icon,
        sortOrder,
        updatedAt,
        isArchived
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('initial_balance')) {
      context.handle(
          _initialBalanceMeta,
          initialBalance.isAcceptableOrUnknown(
              data['initial_balance']!, _initialBalanceMeta));
    }
    if (data.containsKey('current_balance')) {
      context.handle(
          _currentBalanceMeta,
          currentBalance.isAcceptableOrUnknown(
              data['current_balance']!, _currentBalanceMeta));
    }
    if (data.containsKey('currency')) {
      context.handle(_currencyMeta,
          currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta));
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_archived')) {
      context.handle(
          _isArchivedMeta,
          isArchived.isAcceptableOrUnknown(
              data['is_archived']!, _isArchivedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: $AccountsTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      initialBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}initial_balance'])!,
      currentBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}current_balance'])!,
      currency: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}currency'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isArchived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_archived'])!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }

  static TypeConverter<AccountType, String> $convertertype =
      const AccountTypeConverter();
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final AccountType type;
  final double initialBalance;
  final double currentBalance;
  final String currency;
  final String? icon;
  final int sortOrder;
  final DateTime updatedAt;
  final bool isArchived;
  const Account(
      {required this.id,
      required this.name,
      required this.type,
      required this.initialBalance,
      required this.currentBalance,
      required this.currency,
      this.icon,
      required this.sortOrder,
      required this.updatedAt,
      required this.isArchived});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<String>($AccountsTable.$convertertype.toSql(type));
    }
    map['initial_balance'] = Variable<double>(initialBalance);
    map['current_balance'] = Variable<double>(currentBalance);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      initialBalance: Value(initialBalance),
      currentBalance: Value(currentBalance),
      currency: Value(currency),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      sortOrder: Value(sortOrder),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<AccountType>(json['type']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      currentBalance: serializer.fromJson<double>(json['currentBalance']),
      currency: serializer.fromJson<String>(json['currency']),
      icon: serializer.fromJson<String?>(json['icon']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<AccountType>(type),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'currentBalance': serializer.toJson<double>(currentBalance),
      'currency': serializer.toJson<String>(currency),
      'icon': serializer.toJson<String?>(icon),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  Account copyWith(
          {String? id,
          String? name,
          AccountType? type,
          double? initialBalance,
          double? currentBalance,
          String? currency,
          Value<String?> icon = const Value.absent(),
          int? sortOrder,
          DateTime? updatedAt,
          bool? isArchived}) =>
      Account(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        initialBalance: initialBalance ?? this.initialBalance,
        currentBalance: currentBalance ?? this.currentBalance,
        currency: currency ?? this.currency,
        icon: icon.present ? icon.value : this.icon,
        sortOrder: sortOrder ?? this.sortOrder,
        updatedAt: updatedAt ?? this.updatedAt,
        isArchived: isArchived ?? this.isArchived,
      );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      currency: data.currency.present ? data.currency.value : this.currency,
      icon: data.icon.present ? data.icon.value : this.icon,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived:
          data.isArchived.present ? data.isArchived.value : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('currency: $currency, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, initialBalance,
      currentBalance, currency, icon, sortOrder, updatedAt, isArchived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.initialBalance == this.initialBalance &&
          other.currentBalance == this.currentBalance &&
          other.currency == this.currency &&
          other.icon == this.icon &&
          other.sortOrder == this.sortOrder &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<AccountType> type;
  final Value<double> initialBalance;
  final Value<double> currentBalance;
  final Value<String> currency;
  final Value<String?> icon;
  final Value<int> sortOrder;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.currency = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required AccountType type,
    this.initialBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.currency = const Value.absent(),
    this.icon = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<double>? initialBalance,
    Expression<double>? currentBalance,
    Expression<String>? currency,
    Expression<String>? icon,
    Expression<int>? sortOrder,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (currency != null) 'currency': currency,
      if (icon != null) 'icon': icon,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<AccountType>? type,
      Value<double>? initialBalance,
      Value<double>? currentBalance,
      Value<String>? currency,
      Value<String?>? icon,
      Value<int>? sortOrder,
      Value<DateTime>? updatedAt,
      Value<bool>? isArchived,
      Value<int>? rowid}) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      currency: currency ?? this.currency,
      icon: icon ?? this.icon,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($AccountsTable.$convertertype.toSql(type.value));
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<double>(currentBalance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('currency: $currency, ')
          ..write('icon: $icon, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          (1000 + DateTime.now().microsecond).toString());
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _toAccountIdMeta =
      const VerificationMeta('toAccountId');
  @override
  late final GeneratedColumn<String> toAccountId = GeneratedColumn<String>(
      'to_account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($TransactionsTable.$convertertype);
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _merchantMeta =
      const VerificationMeta('merchant');
  @override
  late final GeneratedColumn<String> merchant = GeneratedColumn<String>(
      'merchant', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('manual'));
  static const VerificationMeta _transactionDateMeta =
      const VerificationMeta('transactionDate');
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>('transaction_date', aliasedName, false,
          type: DriftSqlType.dateTime,
          requiredDuringInsert: false,
          clientDefault: () => DateTime.now());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        accountId,
        toAccountId,
        amount,
        type,
        categoryId,
        merchant,
        description,
        source,
        transactionDate,
        createdAt,
        updatedAt,
        isDeleted
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(Insertable<Transaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('to_account_id')) {
      context.handle(
          _toAccountIdMeta,
          toAccountId.isAcceptableOrUnknown(
              data['to_account_id']!, _toAccountIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    }
    if (data.containsKey('merchant')) {
      context.handle(_merchantMeta,
          merchant.isAcceptableOrUnknown(data['merchant']!, _merchantMeta));
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
          _transactionDateMeta,
          transactionDate.isAcceptableOrUnknown(
              data['transaction_date']!, _transactionDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      toAccountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_account_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      type: $TransactionsTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id']),
      merchant: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}merchant']),
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      transactionDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}transaction_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }

  static TypeConverter<TransactionType, String> $convertertype =
      const TransactionTypeConverter();
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String accountId;
  final String? toAccountId;
  final double amount;
  final TransactionType type;
  final String? categoryId;
  final String? merchant;
  final String? description;
  final String source;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  const Transaction(
      {required this.id,
      required this.accountId,
      this.toAccountId,
      required this.amount,
      required this.type,
      this.categoryId,
      this.merchant,
      this.description,
      required this.source,
      required this.transactionDate,
      required this.createdAt,
      required this.updatedAt,
      required this.isDeleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || toAccountId != null) {
      map['to_account_id'] = Variable<String>(toAccountId);
    }
    map['amount'] = Variable<double>(amount);
    {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || merchant != null) {
      map['merchant'] = Variable<String>(merchant);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['source'] = Variable<String>(source);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_deleted'] = Variable<bool>(isDeleted);
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      toAccountId: toAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(toAccountId),
      amount: Value(amount),
      type: Value(type),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      merchant: merchant == null && nullToAbsent
          ? const Value.absent()
          : Value(merchant),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      source: Value(source),
      transactionDate: Value(transactionDate),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isDeleted: Value(isDeleted),
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      toAccountId: serializer.fromJson<String?>(json['toAccountId']),
      amount: serializer.fromJson<double>(json['amount']),
      type: serializer.fromJson<TransactionType>(json['type']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      merchant: serializer.fromJson<String?>(json['merchant']),
      description: serializer.fromJson<String?>(json['description']),
      source: serializer.fromJson<String>(json['source']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'toAccountId': serializer.toJson<String?>(toAccountId),
      'amount': serializer.toJson<double>(amount),
      'type': serializer.toJson<TransactionType>(type),
      'categoryId': serializer.toJson<String?>(categoryId),
      'merchant': serializer.toJson<String?>(merchant),
      'description': serializer.toJson<String?>(description),
      'source': serializer.toJson<String>(source),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isDeleted': serializer.toJson<bool>(isDeleted),
    };
  }

  Transaction copyWith(
          {String? id,
          String? accountId,
          Value<String?> toAccountId = const Value.absent(),
          double? amount,
          TransactionType? type,
          Value<String?> categoryId = const Value.absent(),
          Value<String?> merchant = const Value.absent(),
          Value<String?> description = const Value.absent(),
          String? source,
          DateTime? transactionDate,
          DateTime? createdAt,
          DateTime? updatedAt,
          bool? isDeleted}) =>
      Transaction(
        id: id ?? this.id,
        accountId: accountId ?? this.accountId,
        toAccountId: toAccountId.present ? toAccountId.value : this.toAccountId,
        amount: amount ?? this.amount,
        type: type ?? this.type,
        categoryId: categoryId.present ? categoryId.value : this.categoryId,
        merchant: merchant.present ? merchant.value : this.merchant,
        description: description.present ? description.value : this.description,
        source: source ?? this.source,
        transactionDate: transactionDate ?? this.transactionDate,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isDeleted: isDeleted ?? this.isDeleted,
      );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      toAccountId:
          data.toAccountId.present ? data.toAccountId.value : this.toAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      type: data.type.present ? data.type.value : this.type,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      merchant: data.merchant.present ? data.merchant.value : this.merchant,
      description:
          data.description.present ? data.description.value : this.description,
      source: data.source.present ? data.source.value : this.source,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('merchant: $merchant, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      accountId,
      toAccountId,
      amount,
      type,
      categoryId,
      merchant,
      description,
      source,
      transactionDate,
      createdAt,
      updatedAt,
      isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.toAccountId == this.toAccountId &&
          other.amount == this.amount &&
          other.type == this.type &&
          other.categoryId == this.categoryId &&
          other.merchant == this.merchant &&
          other.description == this.description &&
          other.source == this.source &&
          other.transactionDate == this.transactionDate &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isDeleted == this.isDeleted);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String?> toAccountId;
  final Value<double> amount;
  final Value<TransactionType> type;
  final Value<String?> categoryId;
  final Value<String?> merchant;
  final Value<String?> description;
  final Value<String> source;
  final Value<DateTime> transactionDate;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isDeleted;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.toAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.type = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.merchant = const Value.absent(),
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String accountId,
    this.toAccountId = const Value.absent(),
    required double amount,
    required TransactionType type,
    this.categoryId = const Value.absent(),
    this.merchant = const Value.absent(),
    this.description = const Value.absent(),
    this.source = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : accountId = Value(accountId),
        amount = Value(amount),
        type = Value(type);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? toAccountId,
    Expression<double>? amount,
    Expression<String>? type,
    Expression<String>? categoryId,
    Expression<String>? merchant,
    Expression<String>? description,
    Expression<String>? source,
    Expression<DateTime>? transactionDate,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (toAccountId != null) 'to_account_id': toAccountId,
      if (amount != null) 'amount': amount,
      if (type != null) 'type': type,
      if (categoryId != null) 'category_id': categoryId,
      if (merchant != null) 'merchant': merchant,
      if (description != null) 'description': description,
      if (source != null) 'source': source,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? accountId,
      Value<String?>? toAccountId,
      Value<double>? amount,
      Value<TransactionType>? type,
      Value<String?>? categoryId,
      Value<String?>? merchant,
      Value<String?>? description,
      Value<String>? source,
      Value<DateTime>? transactionDate,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<bool>? isDeleted,
      Value<int>? rowid}) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      merchant: merchant ?? this.merchant,
      description: description ?? this.description,
      source: source ?? this.source,
      transactionDate: transactionDate ?? this.transactionDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (toAccountId.present) {
      map['to_account_id'] = Variable<String>(toAccountId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($TransactionsTable.$convertertype.toSql(type.value));
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (merchant.present) {
      map['merchant'] = Variable<String>(merchant.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('toAccountId: $toAccountId, ')
          ..write('amount: $amount, ')
          ..write('type: $type, ')
          ..write('categoryId: $categoryId, ')
          ..write('merchant: $merchant, ')
          ..write('description: $description, ')
          ..write('source: $source, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecondsSinceEpoch.toString());
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<TransactionType, String> type =
      GeneratedColumn<String>('type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<TransactionType>($CategoriesTable.$convertertype);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
      'color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _sortOrderMeta =
      const VerificationMeta('sortOrder');
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
      'sort_order', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, parentId, type, icon, color, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(Insertable<Category> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('color')) {
      context.handle(
          _colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));
    }
    if (data.containsKey('sort_order')) {
      context.handle(_sortOrderMeta,
          sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}parent_id']),
      type: $CategoriesTable.$convertertype.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!),
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon']),
      color: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color']),
      sortOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }

  static TypeConverter<TransactionType, String> $convertertype =
      const TransactionTypeConverter();
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  final String? parentId;
  final TransactionType type;
  final String? icon;
  final int? color;
  final int sortOrder;
  const Category(
      {required this.id,
      required this.name,
      this.parentId,
      required this.type,
      this.icon,
      this.color,
      required this.sortOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    {
      map['type'] =
          Variable<String>($CategoriesTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<int>(color);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      type: Value(type),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      color:
          color == null && nullToAbsent ? const Value.absent() : Value(color),
      sortOrder: Value(sortOrder),
    );
  }

  factory Category.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      type: serializer.fromJson<TransactionType>(json['type']),
      icon: serializer.fromJson<String?>(json['icon']),
      color: serializer.fromJson<int?>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'type': serializer.toJson<TransactionType>(type),
      'icon': serializer.toJson<String?>(icon),
      'color': serializer.toJson<int?>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Category copyWith(
          {String? id,
          String? name,
          Value<String?> parentId = const Value.absent(),
          TransactionType? type,
          Value<String?> icon = const Value.absent(),
          Value<int?> color = const Value.absent(),
          int? sortOrder}) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        parentId: parentId.present ? parentId.value : this.parentId,
        type: type ?? this.type,
        icon: icon.present ? icon.value : this.icon,
        color: color.present ? color.value : this.color,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      type: data.type.present ? data.type.value : this.type,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parentId, type, icon, color, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.type == this.type &&
          other.icon == this.icon &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<TransactionType> type;
  final Value<String?> icon;
  final Value<int?> color;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.type = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    required TransactionType type,
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        type = Value(type);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<String>? type,
    Expression<String>? icon,
    Expression<int>? color,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (type != null) 'type': type,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? parentId,
      Value<TransactionType>? type,
      Value<String?>? icon,
      Value<int?>? color,
      Value<int>? sortOrder,
      Value<int>? rowid}) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (type.present) {
      map['type'] =
          Variable<String>($CategoriesTable.$convertertype.toSql(type.value));
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('type: $type, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FundHoldingsTable extends FundHoldings
    with TableInfo<$FundHoldingsTable, FundHolding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FundHoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          (1000 + DateTime.now().microsecond).toString());
  static const VerificationMeta _fundCodeMeta =
      const VerificationMeta('fundCode');
  @override
  late final GeneratedColumn<String> fundCode = GeneratedColumn<String>(
      'fund_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fundNameMeta =
      const VerificationMeta('fundName');
  @override
  late final GeneratedColumn<String> fundName = GeneratedColumn<String>(
      'fund_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalSharesMeta =
      const VerificationMeta('totalShares');
  @override
  late final GeneratedColumn<double> totalShares = GeneratedColumn<double>(
      'total_shares', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalCostMeta =
      const VerificationMeta('totalCost');
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
      'total_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lastNavMeta =
      const VerificationMeta('lastNav');
  @override
  late final GeneratedColumn<double> lastNav = GeneratedColumn<double>(
      'last_nav', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _lastUpdateMeta =
      const VerificationMeta('lastUpdate');
  @override
  late final GeneratedColumn<DateTime> lastUpdate = GeneratedColumn<DateTime>(
      'last_update', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fundCode,
        fundName,
        totalShares,
        totalCost,
        lastNav,
        accountId,
        lastUpdate,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fund_holdings';
  @override
  VerificationContext validateIntegrity(Insertable<FundHolding> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fund_code')) {
      context.handle(_fundCodeMeta,
          fundCode.isAcceptableOrUnknown(data['fund_code']!, _fundCodeMeta));
    } else if (isInserting) {
      context.missing(_fundCodeMeta);
    }
    if (data.containsKey('fund_name')) {
      context.handle(_fundNameMeta,
          fundName.isAcceptableOrUnknown(data['fund_name']!, _fundNameMeta));
    } else if (isInserting) {
      context.missing(_fundNameMeta);
    }
    if (data.containsKey('total_shares')) {
      context.handle(
          _totalSharesMeta,
          totalShares.isAcceptableOrUnknown(
              data['total_shares']!, _totalSharesMeta));
    } else if (isInserting) {
      context.missing(_totalSharesMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(_totalCostMeta,
          totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta));
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('last_nav')) {
      context.handle(_lastNavMeta,
          lastNav.isAcceptableOrUnknown(data['last_nav']!, _lastNavMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('last_update')) {
      context.handle(
          _lastUpdateMeta,
          lastUpdate.isAcceptableOrUnknown(
              data['last_update']!, _lastUpdateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FundHolding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FundHolding(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fundCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fund_code'])!,
      fundName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fund_name'])!,
      totalShares: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_shares'])!,
      totalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cost'])!,
      lastNav: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}last_nav'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      lastUpdate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_update']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $FundHoldingsTable createAlias(String alias) {
    return $FundHoldingsTable(attachedDatabase, alias);
  }
}

class FundHolding extends DataClass implements Insertable<FundHolding> {
  final String id;
  final String fundCode;
  final String fundName;
  final double totalShares;
  final double totalCost;
  final double lastNav;
  final String accountId;
  final DateTime? lastUpdate;
  final bool isActive;
  const FundHolding(
      {required this.id,
      required this.fundCode,
      required this.fundName,
      required this.totalShares,
      required this.totalCost,
      required this.lastNav,
      required this.accountId,
      this.lastUpdate,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fund_code'] = Variable<String>(fundCode);
    map['fund_name'] = Variable<String>(fundName);
    map['total_shares'] = Variable<double>(totalShares);
    map['total_cost'] = Variable<double>(totalCost);
    map['last_nav'] = Variable<double>(lastNav);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || lastUpdate != null) {
      map['last_update'] = Variable<DateTime>(lastUpdate);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  FundHoldingsCompanion toCompanion(bool nullToAbsent) {
    return FundHoldingsCompanion(
      id: Value(id),
      fundCode: Value(fundCode),
      fundName: Value(fundName),
      totalShares: Value(totalShares),
      totalCost: Value(totalCost),
      lastNav: Value(lastNav),
      accountId: Value(accountId),
      lastUpdate: lastUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdate),
      isActive: Value(isActive),
    );
  }

  factory FundHolding.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FundHolding(
      id: serializer.fromJson<String>(json['id']),
      fundCode: serializer.fromJson<String>(json['fundCode']),
      fundName: serializer.fromJson<String>(json['fundName']),
      totalShares: serializer.fromJson<double>(json['totalShares']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      lastNav: serializer.fromJson<double>(json['lastNav']),
      accountId: serializer.fromJson<String>(json['accountId']),
      lastUpdate: serializer.fromJson<DateTime?>(json['lastUpdate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fundCode': serializer.toJson<String>(fundCode),
      'fundName': serializer.toJson<String>(fundName),
      'totalShares': serializer.toJson<double>(totalShares),
      'totalCost': serializer.toJson<double>(totalCost),
      'lastNav': serializer.toJson<double>(lastNav),
      'accountId': serializer.toJson<String>(accountId),
      'lastUpdate': serializer.toJson<DateTime?>(lastUpdate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  FundHolding copyWith(
          {String? id,
          String? fundCode,
          String? fundName,
          double? totalShares,
          double? totalCost,
          double? lastNav,
          String? accountId,
          Value<DateTime?> lastUpdate = const Value.absent(),
          bool? isActive}) =>
      FundHolding(
        id: id ?? this.id,
        fundCode: fundCode ?? this.fundCode,
        fundName: fundName ?? this.fundName,
        totalShares: totalShares ?? this.totalShares,
        totalCost: totalCost ?? this.totalCost,
        lastNav: lastNav ?? this.lastNav,
        accountId: accountId ?? this.accountId,
        lastUpdate: lastUpdate.present ? lastUpdate.value : this.lastUpdate,
        isActive: isActive ?? this.isActive,
      );
  FundHolding copyWithCompanion(FundHoldingsCompanion data) {
    return FundHolding(
      id: data.id.present ? data.id.value : this.id,
      fundCode: data.fundCode.present ? data.fundCode.value : this.fundCode,
      fundName: data.fundName.present ? data.fundName.value : this.fundName,
      totalShares:
          data.totalShares.present ? data.totalShares.value : this.totalShares,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      lastNav: data.lastNav.present ? data.lastNav.value : this.lastNav,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      lastUpdate:
          data.lastUpdate.present ? data.lastUpdate.value : this.lastUpdate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FundHolding(')
          ..write('id: $id, ')
          ..write('fundCode: $fundCode, ')
          ..write('fundName: $fundName, ')
          ..write('totalShares: $totalShares, ')
          ..write('totalCost: $totalCost, ')
          ..write('lastNav: $lastNav, ')
          ..write('accountId: $accountId, ')
          ..write('lastUpdate: $lastUpdate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fundCode, fundName, totalShares,
      totalCost, lastNav, accountId, lastUpdate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FundHolding &&
          other.id == this.id &&
          other.fundCode == this.fundCode &&
          other.fundName == this.fundName &&
          other.totalShares == this.totalShares &&
          other.totalCost == this.totalCost &&
          other.lastNav == this.lastNav &&
          other.accountId == this.accountId &&
          other.lastUpdate == this.lastUpdate &&
          other.isActive == this.isActive);
}

class FundHoldingsCompanion extends UpdateCompanion<FundHolding> {
  final Value<String> id;
  final Value<String> fundCode;
  final Value<String> fundName;
  final Value<double> totalShares;
  final Value<double> totalCost;
  final Value<double> lastNav;
  final Value<String> accountId;
  final Value<DateTime?> lastUpdate;
  final Value<bool> isActive;
  final Value<int> rowid;
  const FundHoldingsCompanion({
    this.id = const Value.absent(),
    this.fundCode = const Value.absent(),
    this.fundName = const Value.absent(),
    this.totalShares = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.lastNav = const Value.absent(),
    this.accountId = const Value.absent(),
    this.lastUpdate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FundHoldingsCompanion.insert({
    this.id = const Value.absent(),
    required String fundCode,
    required String fundName,
    required double totalShares,
    required double totalCost,
    this.lastNav = const Value.absent(),
    required String accountId,
    this.lastUpdate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fundCode = Value(fundCode),
        fundName = Value(fundName),
        totalShares = Value(totalShares),
        totalCost = Value(totalCost),
        accountId = Value(accountId);
  static Insertable<FundHolding> custom({
    Expression<String>? id,
    Expression<String>? fundCode,
    Expression<String>? fundName,
    Expression<double>? totalShares,
    Expression<double>? totalCost,
    Expression<double>? lastNav,
    Expression<String>? accountId,
    Expression<DateTime>? lastUpdate,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fundCode != null) 'fund_code': fundCode,
      if (fundName != null) 'fund_name': fundName,
      if (totalShares != null) 'total_shares': totalShares,
      if (totalCost != null) 'total_cost': totalCost,
      if (lastNav != null) 'last_nav': lastNav,
      if (accountId != null) 'account_id': accountId,
      if (lastUpdate != null) 'last_update': lastUpdate,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FundHoldingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fundCode,
      Value<String>? fundName,
      Value<double>? totalShares,
      Value<double>? totalCost,
      Value<double>? lastNav,
      Value<String>? accountId,
      Value<DateTime?>? lastUpdate,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return FundHoldingsCompanion(
      id: id ?? this.id,
      fundCode: fundCode ?? this.fundCode,
      fundName: fundName ?? this.fundName,
      totalShares: totalShares ?? this.totalShares,
      totalCost: totalCost ?? this.totalCost,
      lastNav: lastNav ?? this.lastNav,
      accountId: accountId ?? this.accountId,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fundCode.present) {
      map['fund_code'] = Variable<String>(fundCode.value);
    }
    if (fundName.present) {
      map['fund_name'] = Variable<String>(fundName.value);
    }
    if (totalShares.present) {
      map['total_shares'] = Variable<double>(totalShares.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (lastNav.present) {
      map['last_nav'] = Variable<double>(lastNav.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (lastUpdate.present) {
      map['last_update'] = Variable<DateTime>(lastUpdate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FundHoldingsCompanion(')
          ..write('id: $id, ')
          ..write('fundCode: $fundCode, ')
          ..write('fundName: $fundName, ')
          ..write('totalShares: $totalShares, ')
          ..write('totalCost: $totalCost, ')
          ..write('lastNav: $lastNav, ')
          ..write('accountId: $accountId, ')
          ..write('lastUpdate: $lastUpdate, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FundTransactionsTable extends FundTransactions
    with TableInfo<$FundTransactionsTable, FundTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FundTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecondsSinceEpoch.toString());
  static const VerificationMeta _fundCodeMeta =
      const VerificationMeta('fundCode');
  @override
  late final GeneratedColumn<String> fundCode = GeneratedColumn<String>(
      'fund_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fundNameMeta =
      const VerificationMeta('fundName');
  @override
  late final GeneratedColumn<String> fundName = GeneratedColumn<String>(
      'fund_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<double> shares = GeneratedColumn<double>(
      'shares', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _navMeta = const VerificationMeta('nav');
  @override
  late final GeneratedColumn<double> nav = GeneratedColumn<double>(
      'nav', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tradeDateMeta =
      const VerificationMeta('tradeDate');
  @override
  late final GeneratedColumn<DateTime> tradeDate = GeneratedColumn<DateTime>(
      'trade_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        fundCode,
        fundName,
        operation,
        shares,
        amount,
        nav,
        tradeDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fund_transactions';
  @override
  VerificationContext validateIntegrity(Insertable<FundTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fund_code')) {
      context.handle(_fundCodeMeta,
          fundCode.isAcceptableOrUnknown(data['fund_code']!, _fundCodeMeta));
    } else if (isInserting) {
      context.missing(_fundCodeMeta);
    }
    if (data.containsKey('fund_name')) {
      context.handle(_fundNameMeta,
          fundName.isAcceptableOrUnknown(data['fund_name']!, _fundNameMeta));
    } else if (isInserting) {
      context.missing(_fundNameMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(_sharesMeta,
          shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta));
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('nav')) {
      context.handle(
          _navMeta, nav.isAcceptableOrUnknown(data['nav']!, _navMeta));
    } else if (isInserting) {
      context.missing(_navMeta);
    }
    if (data.containsKey('trade_date')) {
      context.handle(_tradeDateMeta,
          tradeDate.isAcceptableOrUnknown(data['trade_date']!, _tradeDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FundTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FundTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      fundCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fund_code'])!,
      fundName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}fund_name'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      shares: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shares'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      nav: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}nav'])!,
      tradeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trade_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $FundTransactionsTable createAlias(String alias) {
    return $FundTransactionsTable(attachedDatabase, alias);
  }
}

class FundTransaction extends DataClass implements Insertable<FundTransaction> {
  final String id;
  final String fundCode;
  final String fundName;
  final String operation;
  final double shares;
  final double amount;
  final double nav;
  final DateTime tradeDate;
  final DateTime createdAt;
  const FundTransaction(
      {required this.id,
      required this.fundCode,
      required this.fundName,
      required this.operation,
      required this.shares,
      required this.amount,
      required this.nav,
      required this.tradeDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['fund_code'] = Variable<String>(fundCode);
    map['fund_name'] = Variable<String>(fundName);
    map['operation'] = Variable<String>(operation);
    map['shares'] = Variable<double>(shares);
    map['amount'] = Variable<double>(amount);
    map['nav'] = Variable<double>(nav);
    map['trade_date'] = Variable<DateTime>(tradeDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FundTransactionsCompanion toCompanion(bool nullToAbsent) {
    return FundTransactionsCompanion(
      id: Value(id),
      fundCode: Value(fundCode),
      fundName: Value(fundName),
      operation: Value(operation),
      shares: Value(shares),
      amount: Value(amount),
      nav: Value(nav),
      tradeDate: Value(tradeDate),
      createdAt: Value(createdAt),
    );
  }

  factory FundTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FundTransaction(
      id: serializer.fromJson<String>(json['id']),
      fundCode: serializer.fromJson<String>(json['fundCode']),
      fundName: serializer.fromJson<String>(json['fundName']),
      operation: serializer.fromJson<String>(json['operation']),
      shares: serializer.fromJson<double>(json['shares']),
      amount: serializer.fromJson<double>(json['amount']),
      nav: serializer.fromJson<double>(json['nav']),
      tradeDate: serializer.fromJson<DateTime>(json['tradeDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fundCode': serializer.toJson<String>(fundCode),
      'fundName': serializer.toJson<String>(fundName),
      'operation': serializer.toJson<String>(operation),
      'shares': serializer.toJson<double>(shares),
      'amount': serializer.toJson<double>(amount),
      'nav': serializer.toJson<double>(nav),
      'tradeDate': serializer.toJson<DateTime>(tradeDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FundTransaction copyWith(
          {String? id,
          String? fundCode,
          String? fundName,
          String? operation,
          double? shares,
          double? amount,
          double? nav,
          DateTime? tradeDate,
          DateTime? createdAt}) =>
      FundTransaction(
        id: id ?? this.id,
        fundCode: fundCode ?? this.fundCode,
        fundName: fundName ?? this.fundName,
        operation: operation ?? this.operation,
        shares: shares ?? this.shares,
        amount: amount ?? this.amount,
        nav: nav ?? this.nav,
        tradeDate: tradeDate ?? this.tradeDate,
        createdAt: createdAt ?? this.createdAt,
      );
  FundTransaction copyWithCompanion(FundTransactionsCompanion data) {
    return FundTransaction(
      id: data.id.present ? data.id.value : this.id,
      fundCode: data.fundCode.present ? data.fundCode.value : this.fundCode,
      fundName: data.fundName.present ? data.fundName.value : this.fundName,
      operation: data.operation.present ? data.operation.value : this.operation,
      shares: data.shares.present ? data.shares.value : this.shares,
      amount: data.amount.present ? data.amount.value : this.amount,
      nav: data.nav.present ? data.nav.value : this.nav,
      tradeDate: data.tradeDate.present ? data.tradeDate.value : this.tradeDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FundTransaction(')
          ..write('id: $id, ')
          ..write('fundCode: $fundCode, ')
          ..write('fundName: $fundName, ')
          ..write('operation: $operation, ')
          ..write('shares: $shares, ')
          ..write('amount: $amount, ')
          ..write('nav: $nav, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, fundCode, fundName, operation, shares,
      amount, nav, tradeDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FundTransaction &&
          other.id == this.id &&
          other.fundCode == this.fundCode &&
          other.fundName == this.fundName &&
          other.operation == this.operation &&
          other.shares == this.shares &&
          other.amount == this.amount &&
          other.nav == this.nav &&
          other.tradeDate == this.tradeDate &&
          other.createdAt == this.createdAt);
}

class FundTransactionsCompanion extends UpdateCompanion<FundTransaction> {
  final Value<String> id;
  final Value<String> fundCode;
  final Value<String> fundName;
  final Value<String> operation;
  final Value<double> shares;
  final Value<double> amount;
  final Value<double> nav;
  final Value<DateTime> tradeDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FundTransactionsCompanion({
    this.id = const Value.absent(),
    this.fundCode = const Value.absent(),
    this.fundName = const Value.absent(),
    this.operation = const Value.absent(),
    this.shares = const Value.absent(),
    this.amount = const Value.absent(),
    this.nav = const Value.absent(),
    this.tradeDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FundTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String fundCode,
    required String fundName,
    required String operation,
    required double shares,
    required double amount,
    required double nav,
    this.tradeDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : fundCode = Value(fundCode),
        fundName = Value(fundName),
        operation = Value(operation),
        shares = Value(shares),
        amount = Value(amount),
        nav = Value(nav);
  static Insertable<FundTransaction> custom({
    Expression<String>? id,
    Expression<String>? fundCode,
    Expression<String>? fundName,
    Expression<String>? operation,
    Expression<double>? shares,
    Expression<double>? amount,
    Expression<double>? nav,
    Expression<DateTime>? tradeDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fundCode != null) 'fund_code': fundCode,
      if (fundName != null) 'fund_name': fundName,
      if (operation != null) 'operation': operation,
      if (shares != null) 'shares': shares,
      if (amount != null) 'amount': amount,
      if (nav != null) 'nav': nav,
      if (tradeDate != null) 'trade_date': tradeDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FundTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? fundCode,
      Value<String>? fundName,
      Value<String>? operation,
      Value<double>? shares,
      Value<double>? amount,
      Value<double>? nav,
      Value<DateTime>? tradeDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return FundTransactionsCompanion(
      id: id ?? this.id,
      fundCode: fundCode ?? this.fundCode,
      fundName: fundName ?? this.fundName,
      operation: operation ?? this.operation,
      shares: shares ?? this.shares,
      amount: amount ?? this.amount,
      nav: nav ?? this.nav,
      tradeDate: tradeDate ?? this.tradeDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fundCode.present) {
      map['fund_code'] = Variable<String>(fundCode.value);
    }
    if (fundName.present) {
      map['fund_name'] = Variable<String>(fundName.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (shares.present) {
      map['shares'] = Variable<double>(shares.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (nav.present) {
      map['nav'] = Variable<double>(nav.value);
    }
    if (tradeDate.present) {
      map['trade_date'] = Variable<DateTime>(tradeDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FundTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('fundCode: $fundCode, ')
          ..write('fundName: $fundName, ')
          ..write('operation: $operation, ')
          ..write('shares: $shares, ')
          ..write('amount: $amount, ')
          ..write('nav: $nav, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockHoldingsTable extends StockHoldings
    with TableInfo<$StockHoldingsTable, StockHolding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockHoldingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () =>
          DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          (1000 + DateTime.now().microsecond).toString());
  static const VerificationMeta _stockCodeMeta =
      const VerificationMeta('stockCode');
  @override
  late final GeneratedColumn<String> stockCode = GeneratedColumn<String>(
      'stock_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockNameMeta =
      const VerificationMeta('stockName');
  @override
  late final GeneratedColumn<String> stockName = GeneratedColumn<String>(
      'stock_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalSharesMeta =
      const VerificationMeta('totalShares');
  @override
  late final GeneratedColumn<double> totalShares = GeneratedColumn<double>(
      'total_shares', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _totalCostMeta =
      const VerificationMeta('totalCost');
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
      'total_cost', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lastPriceMeta =
      const VerificationMeta('lastPrice');
  @override
  late final GeneratedColumn<double> lastPrice = GeneratedColumn<double>(
      'last_price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES accounts (id)'));
  static const VerificationMeta _lastUpdateMeta =
      const VerificationMeta('lastUpdate');
  @override
  late final GeneratedColumn<DateTime> lastUpdate = GeneratedColumn<DateTime>(
      'last_update', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isActiveMeta =
      const VerificationMeta('isActive');
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
      'is_active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_active" IN (0, 1))'),
      defaultValue: const Constant(true));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        stockCode,
        stockName,
        totalShares,
        totalCost,
        lastPrice,
        accountId,
        lastUpdate,
        isActive
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_holdings';
  @override
  VerificationContext validateIntegrity(Insertable<StockHolding> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stock_code')) {
      context.handle(_stockCodeMeta,
          stockCode.isAcceptableOrUnknown(data['stock_code']!, _stockCodeMeta));
    } else if (isInserting) {
      context.missing(_stockCodeMeta);
    }
    if (data.containsKey('stock_name')) {
      context.handle(_stockNameMeta,
          stockName.isAcceptableOrUnknown(data['stock_name']!, _stockNameMeta));
    } else if (isInserting) {
      context.missing(_stockNameMeta);
    }
    if (data.containsKey('total_shares')) {
      context.handle(
          _totalSharesMeta,
          totalShares.isAcceptableOrUnknown(
              data['total_shares']!, _totalSharesMeta));
    } else if (isInserting) {
      context.missing(_totalSharesMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(_totalCostMeta,
          totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta));
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('last_price')) {
      context.handle(_lastPriceMeta,
          lastPrice.isAcceptableOrUnknown(data['last_price']!, _lastPriceMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('last_update')) {
      context.handle(
          _lastUpdateMeta,
          lastUpdate.isAcceptableOrUnknown(
              data['last_update']!, _lastUpdateMeta));
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockHolding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockHolding(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      stockCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stock_code'])!,
      stockName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stock_name'])!,
      totalShares: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_shares'])!,
      totalCost: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_cost'])!,
      lastPrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}last_price'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id'])!,
      lastUpdate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_update']),
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
    );
  }

  @override
  $StockHoldingsTable createAlias(String alias) {
    return $StockHoldingsTable(attachedDatabase, alias);
  }
}

class StockHolding extends DataClass implements Insertable<StockHolding> {
  final String id;
  final String stockCode;
  final String stockName;
  final double totalShares;
  final double totalCost;
  final double lastPrice;
  final String accountId;
  final DateTime? lastUpdate;
  final bool isActive;
  const StockHolding(
      {required this.id,
      required this.stockCode,
      required this.stockName,
      required this.totalShares,
      required this.totalCost,
      required this.lastPrice,
      required this.accountId,
      this.lastUpdate,
      required this.isActive});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['stock_code'] = Variable<String>(stockCode);
    map['stock_name'] = Variable<String>(stockName);
    map['total_shares'] = Variable<double>(totalShares);
    map['total_cost'] = Variable<double>(totalCost);
    map['last_price'] = Variable<double>(lastPrice);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || lastUpdate != null) {
      map['last_update'] = Variable<DateTime>(lastUpdate);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  StockHoldingsCompanion toCompanion(bool nullToAbsent) {
    return StockHoldingsCompanion(
      id: Value(id),
      stockCode: Value(stockCode),
      stockName: Value(stockName),
      totalShares: Value(totalShares),
      totalCost: Value(totalCost),
      lastPrice: Value(lastPrice),
      accountId: Value(accountId),
      lastUpdate: lastUpdate == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdate),
      isActive: Value(isActive),
    );
  }

  factory StockHolding.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockHolding(
      id: serializer.fromJson<String>(json['id']),
      stockCode: serializer.fromJson<String>(json['stockCode']),
      stockName: serializer.fromJson<String>(json['stockName']),
      totalShares: serializer.fromJson<double>(json['totalShares']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      lastPrice: serializer.fromJson<double>(json['lastPrice']),
      accountId: serializer.fromJson<String>(json['accountId']),
      lastUpdate: serializer.fromJson<DateTime?>(json['lastUpdate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stockCode': serializer.toJson<String>(stockCode),
      'stockName': serializer.toJson<String>(stockName),
      'totalShares': serializer.toJson<double>(totalShares),
      'totalCost': serializer.toJson<double>(totalCost),
      'lastPrice': serializer.toJson<double>(lastPrice),
      'accountId': serializer.toJson<String>(accountId),
      'lastUpdate': serializer.toJson<DateTime?>(lastUpdate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  StockHolding copyWith(
          {String? id,
          String? stockCode,
          String? stockName,
          double? totalShares,
          double? totalCost,
          double? lastPrice,
          String? accountId,
          Value<DateTime?> lastUpdate = const Value.absent(),
          bool? isActive}) =>
      StockHolding(
        id: id ?? this.id,
        stockCode: stockCode ?? this.stockCode,
        stockName: stockName ?? this.stockName,
        totalShares: totalShares ?? this.totalShares,
        totalCost: totalCost ?? this.totalCost,
        lastPrice: lastPrice ?? this.lastPrice,
        accountId: accountId ?? this.accountId,
        lastUpdate: lastUpdate.present ? lastUpdate.value : this.lastUpdate,
        isActive: isActive ?? this.isActive,
      );
  StockHolding copyWithCompanion(StockHoldingsCompanion data) {
    return StockHolding(
      id: data.id.present ? data.id.value : this.id,
      stockCode: data.stockCode.present ? data.stockCode.value : this.stockCode,
      stockName: data.stockName.present ? data.stockName.value : this.stockName,
      totalShares:
          data.totalShares.present ? data.totalShares.value : this.totalShares,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      lastPrice: data.lastPrice.present ? data.lastPrice.value : this.lastPrice,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      lastUpdate:
          data.lastUpdate.present ? data.lastUpdate.value : this.lastUpdate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockHolding(')
          ..write('id: $id, ')
          ..write('stockCode: $stockCode, ')
          ..write('stockName: $stockName, ')
          ..write('totalShares: $totalShares, ')
          ..write('totalCost: $totalCost, ')
          ..write('lastPrice: $lastPrice, ')
          ..write('accountId: $accountId, ')
          ..write('lastUpdate: $lastUpdate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, stockCode, stockName, totalShares,
      totalCost, lastPrice, accountId, lastUpdate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockHolding &&
          other.id == this.id &&
          other.stockCode == this.stockCode &&
          other.stockName == this.stockName &&
          other.totalShares == this.totalShares &&
          other.totalCost == this.totalCost &&
          other.lastPrice == this.lastPrice &&
          other.accountId == this.accountId &&
          other.lastUpdate == this.lastUpdate &&
          other.isActive == this.isActive);
}

class StockHoldingsCompanion extends UpdateCompanion<StockHolding> {
  final Value<String> id;
  final Value<String> stockCode;
  final Value<String> stockName;
  final Value<double> totalShares;
  final Value<double> totalCost;
  final Value<double> lastPrice;
  final Value<String> accountId;
  final Value<DateTime?> lastUpdate;
  final Value<bool> isActive;
  final Value<int> rowid;
  const StockHoldingsCompanion({
    this.id = const Value.absent(),
    this.stockCode = const Value.absent(),
    this.stockName = const Value.absent(),
    this.totalShares = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.lastPrice = const Value.absent(),
    this.accountId = const Value.absent(),
    this.lastUpdate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockHoldingsCompanion.insert({
    this.id = const Value.absent(),
    required String stockCode,
    required String stockName,
    required double totalShares,
    required double totalCost,
    this.lastPrice = const Value.absent(),
    required String accountId,
    this.lastUpdate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : stockCode = Value(stockCode),
        stockName = Value(stockName),
        totalShares = Value(totalShares),
        totalCost = Value(totalCost),
        accountId = Value(accountId);
  static Insertable<StockHolding> custom({
    Expression<String>? id,
    Expression<String>? stockCode,
    Expression<String>? stockName,
    Expression<double>? totalShares,
    Expression<double>? totalCost,
    Expression<double>? lastPrice,
    Expression<String>? accountId,
    Expression<DateTime>? lastUpdate,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stockCode != null) 'stock_code': stockCode,
      if (stockName != null) 'stock_name': stockName,
      if (totalShares != null) 'total_shares': totalShares,
      if (totalCost != null) 'total_cost': totalCost,
      if (lastPrice != null) 'last_price': lastPrice,
      if (accountId != null) 'account_id': accountId,
      if (lastUpdate != null) 'last_update': lastUpdate,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockHoldingsCompanion copyWith(
      {Value<String>? id,
      Value<String>? stockCode,
      Value<String>? stockName,
      Value<double>? totalShares,
      Value<double>? totalCost,
      Value<double>? lastPrice,
      Value<String>? accountId,
      Value<DateTime?>? lastUpdate,
      Value<bool>? isActive,
      Value<int>? rowid}) {
    return StockHoldingsCompanion(
      id: id ?? this.id,
      stockCode: stockCode ?? this.stockCode,
      stockName: stockName ?? this.stockName,
      totalShares: totalShares ?? this.totalShares,
      totalCost: totalCost ?? this.totalCost,
      lastPrice: lastPrice ?? this.lastPrice,
      accountId: accountId ?? this.accountId,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stockCode.present) {
      map['stock_code'] = Variable<String>(stockCode.value);
    }
    if (stockName.present) {
      map['stock_name'] = Variable<String>(stockName.value);
    }
    if (totalShares.present) {
      map['total_shares'] = Variable<double>(totalShares.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (lastPrice.present) {
      map['last_price'] = Variable<double>(lastPrice.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (lastUpdate.present) {
      map['last_update'] = Variable<DateTime>(lastUpdate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockHoldingsCompanion(')
          ..write('id: $id, ')
          ..write('stockCode: $stockCode, ')
          ..write('stockName: $stockName, ')
          ..write('totalShares: $totalShares, ')
          ..write('totalCost: $totalCost, ')
          ..write('lastPrice: $lastPrice, ')
          ..write('accountId: $accountId, ')
          ..write('lastUpdate: $lastUpdate, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockTransactionsTable extends StockTransactions
    with TableInfo<$StockTransactionsTable, StockTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now().millisecondsSinceEpoch.toString());
  static const VerificationMeta _stockCodeMeta =
      const VerificationMeta('stockCode');
  @override
  late final GeneratedColumn<String> stockCode = GeneratedColumn<String>(
      'stock_code', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stockNameMeta =
      const VerificationMeta('stockName');
  @override
  late final GeneratedColumn<String> stockName = GeneratedColumn<String>(
      'stock_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _operationMeta =
      const VerificationMeta('operation');
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
      'operation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sharesMeta = const VerificationMeta('shares');
  @override
  late final GeneratedColumn<double> shares = GeneratedColumn<double>(
      'shares', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _tradeDateMeta =
      const VerificationMeta('tradeDate');
  @override
  late final GeneratedColumn<DateTime> tradeDate = GeneratedColumn<DateTime>(
      'trade_date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        stockCode,
        stockName,
        operation,
        shares,
        amount,
        price,
        tradeDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_transactions';
  @override
  VerificationContext validateIntegrity(Insertable<StockTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stock_code')) {
      context.handle(_stockCodeMeta,
          stockCode.isAcceptableOrUnknown(data['stock_code']!, _stockCodeMeta));
    } else if (isInserting) {
      context.missing(_stockCodeMeta);
    }
    if (data.containsKey('stock_name')) {
      context.handle(_stockNameMeta,
          stockName.isAcceptableOrUnknown(data['stock_name']!, _stockNameMeta));
    } else if (isInserting) {
      context.missing(_stockNameMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(_operationMeta,
          operation.isAcceptableOrUnknown(data['operation']!, _operationMeta));
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('shares')) {
      context.handle(_sharesMeta,
          shares.isAcceptableOrUnknown(data['shares']!, _sharesMeta));
    } else if (isInserting) {
      context.missing(_sharesMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('trade_date')) {
      context.handle(_tradeDateMeta,
          tradeDate.isAcceptableOrUnknown(data['trade_date']!, _tradeDateMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      stockCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stock_code'])!,
      stockName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}stock_name'])!,
      operation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}operation'])!,
      shares: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}shares'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      tradeDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}trade_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $StockTransactionsTable createAlias(String alias) {
    return $StockTransactionsTable(attachedDatabase, alias);
  }
}

class StockTransaction extends DataClass
    implements Insertable<StockTransaction> {
  final String id;
  final String stockCode;
  final String stockName;
  final String operation;
  final double shares;
  final double amount;
  final double price;
  final DateTime tradeDate;
  final DateTime createdAt;
  const StockTransaction(
      {required this.id,
      required this.stockCode,
      required this.stockName,
      required this.operation,
      required this.shares,
      required this.amount,
      required this.price,
      required this.tradeDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['stock_code'] = Variable<String>(stockCode);
    map['stock_name'] = Variable<String>(stockName);
    map['operation'] = Variable<String>(operation);
    map['shares'] = Variable<double>(shares);
    map['amount'] = Variable<double>(amount);
    map['price'] = Variable<double>(price);
    map['trade_date'] = Variable<DateTime>(tradeDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StockTransactionsCompanion toCompanion(bool nullToAbsent) {
    return StockTransactionsCompanion(
      id: Value(id),
      stockCode: Value(stockCode),
      stockName: Value(stockName),
      operation: Value(operation),
      shares: Value(shares),
      amount: Value(amount),
      price: Value(price),
      tradeDate: Value(tradeDate),
      createdAt: Value(createdAt),
    );
  }

  factory StockTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockTransaction(
      id: serializer.fromJson<String>(json['id']),
      stockCode: serializer.fromJson<String>(json['stockCode']),
      stockName: serializer.fromJson<String>(json['stockName']),
      operation: serializer.fromJson<String>(json['operation']),
      shares: serializer.fromJson<double>(json['shares']),
      amount: serializer.fromJson<double>(json['amount']),
      price: serializer.fromJson<double>(json['price']),
      tradeDate: serializer.fromJson<DateTime>(json['tradeDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'stockCode': serializer.toJson<String>(stockCode),
      'stockName': serializer.toJson<String>(stockName),
      'operation': serializer.toJson<String>(operation),
      'shares': serializer.toJson<double>(shares),
      'amount': serializer.toJson<double>(amount),
      'price': serializer.toJson<double>(price),
      'tradeDate': serializer.toJson<DateTime>(tradeDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StockTransaction copyWith(
          {String? id,
          String? stockCode,
          String? stockName,
          String? operation,
          double? shares,
          double? amount,
          double? price,
          DateTime? tradeDate,
          DateTime? createdAt}) =>
      StockTransaction(
        id: id ?? this.id,
        stockCode: stockCode ?? this.stockCode,
        stockName: stockName ?? this.stockName,
        operation: operation ?? this.operation,
        shares: shares ?? this.shares,
        amount: amount ?? this.amount,
        price: price ?? this.price,
        tradeDate: tradeDate ?? this.tradeDate,
        createdAt: createdAt ?? this.createdAt,
      );
  StockTransaction copyWithCompanion(StockTransactionsCompanion data) {
    return StockTransaction(
      id: data.id.present ? data.id.value : this.id,
      stockCode: data.stockCode.present ? data.stockCode.value : this.stockCode,
      stockName: data.stockName.present ? data.stockName.value : this.stockName,
      operation: data.operation.present ? data.operation.value : this.operation,
      shares: data.shares.present ? data.shares.value : this.shares,
      amount: data.amount.present ? data.amount.value : this.amount,
      price: data.price.present ? data.price.value : this.price,
      tradeDate: data.tradeDate.present ? data.tradeDate.value : this.tradeDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockTransaction(')
          ..write('id: $id, ')
          ..write('stockCode: $stockCode, ')
          ..write('stockName: $stockName, ')
          ..write('operation: $operation, ')
          ..write('shares: $shares, ')
          ..write('amount: $amount, ')
          ..write('price: $price, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, stockCode, stockName, operation, shares,
      amount, price, tradeDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockTransaction &&
          other.id == this.id &&
          other.stockCode == this.stockCode &&
          other.stockName == this.stockName &&
          other.operation == this.operation &&
          other.shares == this.shares &&
          other.amount == this.amount &&
          other.price == this.price &&
          other.tradeDate == this.tradeDate &&
          other.createdAt == this.createdAt);
}

class StockTransactionsCompanion extends UpdateCompanion<StockTransaction> {
  final Value<String> id;
  final Value<String> stockCode;
  final Value<String> stockName;
  final Value<String> operation;
  final Value<double> shares;
  final Value<double> amount;
  final Value<double> price;
  final Value<DateTime> tradeDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StockTransactionsCompanion({
    this.id = const Value.absent(),
    this.stockCode = const Value.absent(),
    this.stockName = const Value.absent(),
    this.operation = const Value.absent(),
    this.shares = const Value.absent(),
    this.amount = const Value.absent(),
    this.price = const Value.absent(),
    this.tradeDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockTransactionsCompanion.insert({
    this.id = const Value.absent(),
    required String stockCode,
    required String stockName,
    required String operation,
    required double shares,
    required double amount,
    required double price,
    this.tradeDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : stockCode = Value(stockCode),
        stockName = Value(stockName),
        operation = Value(operation),
        shares = Value(shares),
        amount = Value(amount),
        price = Value(price);
  static Insertable<StockTransaction> custom({
    Expression<String>? id,
    Expression<String>? stockCode,
    Expression<String>? stockName,
    Expression<String>? operation,
    Expression<double>? shares,
    Expression<double>? amount,
    Expression<double>? price,
    Expression<DateTime>? tradeDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stockCode != null) 'stock_code': stockCode,
      if (stockName != null) 'stock_name': stockName,
      if (operation != null) 'operation': operation,
      if (shares != null) 'shares': shares,
      if (amount != null) 'amount': amount,
      if (price != null) 'price': price,
      if (tradeDate != null) 'trade_date': tradeDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? stockCode,
      Value<String>? stockName,
      Value<String>? operation,
      Value<double>? shares,
      Value<double>? amount,
      Value<double>? price,
      Value<DateTime>? tradeDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return StockTransactionsCompanion(
      id: id ?? this.id,
      stockCode: stockCode ?? this.stockCode,
      stockName: stockName ?? this.stockName,
      operation: operation ?? this.operation,
      shares: shares ?? this.shares,
      amount: amount ?? this.amount,
      price: price ?? this.price,
      tradeDate: tradeDate ?? this.tradeDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (stockCode.present) {
      map['stock_code'] = Variable<String>(stockCode.value);
    }
    if (stockName.present) {
      map['stock_name'] = Variable<String>(stockName.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (shares.present) {
      map['shares'] = Variable<double>(shares.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (tradeDate.present) {
      map['trade_date'] = Variable<DateTime>(tradeDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('stockCode: $stockCode, ')
          ..write('stockName: $stockName, ')
          ..write('operation: $operation, ')
          ..write('shares: $shares, ')
          ..write('amount: $amount, ')
          ..write('price: $price, ')
          ..write('tradeDate: $tradeDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $FundHoldingsTable fundHoldings = $FundHoldingsTable(this);
  late final $FundTransactionsTable fundTransactions =
      $FundTransactionsTable(this);
  late final $StockHoldingsTable stockHoldings = $StockHoldingsTable(this);
  late final $StockTransactionsTable stockTransactions =
      $StockTransactionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        accounts,
        transactions,
        categories,
        fundHoldings,
        fundTransactions,
        stockHoldings,
        stockTransactions
      ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  required String name,
  required AccountType type,
  Value<double> initialBalance,
  Value<double> currentBalance,
  Value<String> currency,
  Value<String?> icon,
  Value<int> sortOrder,
  Value<DateTime> updatedAt,
  Value<bool> isArchived,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<AccountType> type,
  Value<double> initialBalance,
  Value<double> currentBalance,
  Value<String> currency,
  Value<String?> icon,
  Value<int> sortOrder,
  Value<DateTime> updatedAt,
  Value<bool> isArchived,
  Value<int> rowid,
});

class $$AccountsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AccountsTable,
    Account,
    $$AccountsTableFilterComposer,
    $$AccountsTableOrderingComposer,
    $$AccountsTableCreateCompanionBuilder,
    $$AccountsTableUpdateCompanionBuilder> {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AccountsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AccountsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<AccountType> type = const Value.absent(),
            Value<double> initialBalance = const Value.absent(),
            Value<double> currentBalance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion(
            id: id,
            name: name,
            type: type,
            initialBalance: initialBalance,
            currentBalance: currentBalance,
            currency: currency,
            icon: icon,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            isArchived: isArchived,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required AccountType type,
            Value<double> initialBalance = const Value.absent(),
            Value<double> currentBalance = const Value.absent(),
            Value<String> currency = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isArchived = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AccountsCompanion.insert(
            id: id,
            name: name,
            type: type,
            initialBalance: initialBalance,
            currentBalance: currentBalance,
            currency: currency,
            icon: icon,
            sortOrder: sortOrder,
            updatedAt: updatedAt,
            isArchived: isArchived,
            rowid: rowid,
          ),
        ));
}

class $$AccountsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<AccountType, AccountType, String> get type =>
      $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<double> get initialBalance => $state.composableBuilder(
      column: $state.table.initialBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get currentBalance => $state.composableBuilder(
      column: $state.table.currentBalance,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isArchived => $state.composableBuilder(
      column: $state.table.isArchived,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ComposableFilter fundHoldingsRefs(
      ComposableFilter Function($$FundHoldingsTableFilterComposer f) f) {
    final $$FundHoldingsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.fundHoldings,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder, parentComposers) =>
            $$FundHoldingsTableFilterComposer(ComposerState($state.db,
                $state.db.fundHoldings, joinBuilder, parentComposers)));
    return f(composer);
  }

  ComposableFilter stockHoldingsRefs(
      ComposableFilter Function($$StockHoldingsTableFilterComposer f) f) {
    final $$StockHoldingsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $state.db.stockHoldings,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder, parentComposers) =>
            $$StockHoldingsTableFilterComposer(ComposerState($state.db,
                $state.db.stockHoldings, joinBuilder, parentComposers)));
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get initialBalance => $state.composableBuilder(
      column: $state.table.initialBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get currentBalance => $state.composableBuilder(
      column: $state.table.currentBalance,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get currency => $state.composableBuilder(
      column: $state.table.currency,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isArchived => $state.composableBuilder(
      column: $state.table.isArchived,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TransactionsTableCreateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  required String accountId,
  Value<String?> toAccountId,
  required double amount,
  required TransactionType type,
  Value<String?> categoryId,
  Value<String?> merchant,
  Value<String?> description,
  Value<String> source,
  Value<DateTime> transactionDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});
typedef $$TransactionsTableUpdateCompanionBuilder = TransactionsCompanion
    Function({
  Value<String> id,
  Value<String> accountId,
  Value<String?> toAccountId,
  Value<double> amount,
  Value<TransactionType> type,
  Value<String?> categoryId,
  Value<String?> merchant,
  Value<String?> description,
  Value<String> source,
  Value<DateTime> transactionDate,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<bool> isDeleted,
  Value<int> rowid,
});

class $$TransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TransactionsTable,
    Transaction,
    $$TransactionsTableFilterComposer,
    $$TransactionsTableOrderingComposer,
    $$TransactionsTableCreateCompanionBuilder,
    $$TransactionsTableUpdateCompanionBuilder> {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TransactionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TransactionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<String?> toAccountId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<String?> categoryId = const Value.absent(),
            Value<String?> merchant = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion(
            id: id,
            accountId: accountId,
            toAccountId: toAccountId,
            amount: amount,
            type: type,
            categoryId: categoryId,
            merchant: merchant,
            description: description,
            source: source,
            transactionDate: transactionDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String accountId,
            Value<String?> toAccountId = const Value.absent(),
            required double amount,
            required TransactionType type,
            Value<String?> categoryId = const Value.absent(),
            Value<String?> merchant = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<DateTime> transactionDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            toAccountId: toAccountId,
            amount: amount,
            type: type,
            categoryId: categoryId,
            merchant: merchant,
            description: description,
            source: source,
            transactionDate: transactionDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            isDeleted: isDeleted,
            rowid: rowid,
          ),
        ));
}

class $$TransactionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get merchant => $state.composableBuilder(
      column: $state.table.merchant,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get transactionDate => $state.composableBuilder(
      column: $state.table.transactionDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableFilterComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }

  $$AccountsTableFilterComposer get toAccountId {
    final $$AccountsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toAccountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableFilterComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$TransactionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get merchant => $state.composableBuilder(
      column: $state.table.merchant,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get description => $state.composableBuilder(
      column: $state.table.description,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get transactionDate => $state.composableBuilder(
      column: $state.table.transactionDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get updatedAt => $state.composableBuilder(
      column: $state.table.updatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDeleted => $state.composableBuilder(
      column: $state.table.isDeleted,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableOrderingComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }

  $$AccountsTableOrderingComposer get toAccountId {
    final $$AccountsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.toAccountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableOrderingComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> parentId,
  required TransactionType type,
  Value<String?> icon,
  Value<int?> color,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> parentId,
  Value<TransactionType> type,
  Value<String?> icon,
  Value<int?> color,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$CategoriesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTable,
    Category,
    $$CategoriesTableFilterComposer,
    $$CategoriesTableOrderingComposer,
    $$CategoriesTableCreateCompanionBuilder,
    $$CategoriesTableUpdateCompanionBuilder> {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$CategoriesTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$CategoriesTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> parentId = const Value.absent(),
            Value<TransactionType> type = const Value.absent(),
            Value<String?> icon = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion(
            id: id,
            name: name,
            parentId: parentId,
            type: type,
            icon: icon,
            color: color,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> parentId = const Value.absent(),
            required TransactionType type,
            Value<String?> icon = const Value.absent(),
            Value<int?> color = const Value.absent(),
            Value<int> sortOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesCompanion.insert(
            id: id,
            name: name,
            parentId: parentId,
            type: type,
            icon: icon,
            color: color,
            sortOrder: sortOrder,
            rowid: rowid,
          ),
        ));
}

class $$CategoriesTableFilterComposer
    extends FilterComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get parentId => $state.composableBuilder(
      column: $state.table.parentId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnWithTypeConverterFilters<TransactionType, TransactionType, String>
      get type => $state.composableBuilder(
          column: $state.table.type,
          builder: (column, joinBuilders) => ColumnWithTypeConverterFilters(
              column,
              joinBuilders: joinBuilders));

  ColumnFilters<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$CategoriesTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get parentId => $state.composableBuilder(
      column: $state.table.parentId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get icon => $state.composableBuilder(
      column: $state.table.icon,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get color => $state.composableBuilder(
      column: $state.table.color,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get sortOrder => $state.composableBuilder(
      column: $state.table.sortOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$FundHoldingsTableCreateCompanionBuilder = FundHoldingsCompanion
    Function({
  Value<String> id,
  required String fundCode,
  required String fundName,
  required double totalShares,
  required double totalCost,
  Value<double> lastNav,
  required String accountId,
  Value<DateTime?> lastUpdate,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$FundHoldingsTableUpdateCompanionBuilder = FundHoldingsCompanion
    Function({
  Value<String> id,
  Value<String> fundCode,
  Value<String> fundName,
  Value<double> totalShares,
  Value<double> totalCost,
  Value<double> lastNav,
  Value<String> accountId,
  Value<DateTime?> lastUpdate,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$FundHoldingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FundHoldingsTable,
    FundHolding,
    $$FundHoldingsTableFilterComposer,
    $$FundHoldingsTableOrderingComposer,
    $$FundHoldingsTableCreateCompanionBuilder,
    $$FundHoldingsTableUpdateCompanionBuilder> {
  $$FundHoldingsTableTableManager(_$AppDatabase db, $FundHoldingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FundHoldingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FundHoldingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fundCode = const Value.absent(),
            Value<String> fundName = const Value.absent(),
            Value<double> totalShares = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> lastNav = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<DateTime?> lastUpdate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FundHoldingsCompanion(
            id: id,
            fundCode: fundCode,
            fundName: fundName,
            totalShares: totalShares,
            totalCost: totalCost,
            lastNav: lastNav,
            accountId: accountId,
            lastUpdate: lastUpdate,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fundCode,
            required String fundName,
            required double totalShares,
            required double totalCost,
            Value<double> lastNav = const Value.absent(),
            required String accountId,
            Value<DateTime?> lastUpdate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FundHoldingsCompanion.insert(
            id: id,
            fundCode: fundCode,
            fundName: fundName,
            totalShares: totalShares,
            totalCost: totalCost,
            lastNav: lastNav,
            accountId: accountId,
            lastUpdate: lastUpdate,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$FundHoldingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FundHoldingsTable> {
  $$FundHoldingsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fundCode => $state.composableBuilder(
      column: $state.table.fundCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fundName => $state.composableBuilder(
      column: $state.table.fundName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalShares => $state.composableBuilder(
      column: $state.table.totalShares,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalCost => $state.composableBuilder(
      column: $state.table.totalCost,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastNav => $state.composableBuilder(
      column: $state.table.lastNav,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastUpdate => $state.composableBuilder(
      column: $state.table.lastUpdate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableFilterComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$FundHoldingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FundHoldingsTable> {
  $$FundHoldingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fundCode => $state.composableBuilder(
      column: $state.table.fundCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fundName => $state.composableBuilder(
      column: $state.table.fundName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalShares => $state.composableBuilder(
      column: $state.table.totalShares,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalCost => $state.composableBuilder(
      column: $state.table.totalCost,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastNav => $state.composableBuilder(
      column: $state.table.lastNav,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastUpdate => $state.composableBuilder(
      column: $state.table.lastUpdate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableOrderingComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$FundTransactionsTableCreateCompanionBuilder
    = FundTransactionsCompanion Function({
  Value<String> id,
  required String fundCode,
  required String fundName,
  required String operation,
  required double shares,
  required double amount,
  required double nav,
  Value<DateTime> tradeDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$FundTransactionsTableUpdateCompanionBuilder
    = FundTransactionsCompanion Function({
  Value<String> id,
  Value<String> fundCode,
  Value<String> fundName,
  Value<String> operation,
  Value<double> shares,
  Value<double> amount,
  Value<double> nav,
  Value<DateTime> tradeDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$FundTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FundTransactionsTable,
    FundTransaction,
    $$FundTransactionsTableFilterComposer,
    $$FundTransactionsTableOrderingComposer,
    $$FundTransactionsTableCreateCompanionBuilder,
    $$FundTransactionsTableUpdateCompanionBuilder> {
  $$FundTransactionsTableTableManager(
      _$AppDatabase db, $FundTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FundTransactionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FundTransactionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> fundCode = const Value.absent(),
            Value<String> fundName = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<double> shares = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> nav = const Value.absent(),
            Value<DateTime> tradeDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FundTransactionsCompanion(
            id: id,
            fundCode: fundCode,
            fundName: fundName,
            operation: operation,
            shares: shares,
            amount: amount,
            nav: nav,
            tradeDate: tradeDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String fundCode,
            required String fundName,
            required String operation,
            required double shares,
            required double amount,
            required double nav,
            Value<DateTime> tradeDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FundTransactionsCompanion.insert(
            id: id,
            fundCode: fundCode,
            fundName: fundName,
            operation: operation,
            shares: shares,
            amount: amount,
            nav: nav,
            tradeDate: tradeDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$FundTransactionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FundTransactionsTable> {
  $$FundTransactionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fundCode => $state.composableBuilder(
      column: $state.table.fundCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get fundName => $state.composableBuilder(
      column: $state.table.fundName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get operation => $state.composableBuilder(
      column: $state.table.operation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get shares => $state.composableBuilder(
      column: $state.table.shares,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get nav => $state.composableBuilder(
      column: $state.table.nav,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get tradeDate => $state.composableBuilder(
      column: $state.table.tradeDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FundTransactionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FundTransactionsTable> {
  $$FundTransactionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fundCode => $state.composableBuilder(
      column: $state.table.fundCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get fundName => $state.composableBuilder(
      column: $state.table.fundName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get operation => $state.composableBuilder(
      column: $state.table.operation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get shares => $state.composableBuilder(
      column: $state.table.shares,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get nav => $state.composableBuilder(
      column: $state.table.nav,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get tradeDate => $state.composableBuilder(
      column: $state.table.tradeDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$StockHoldingsTableCreateCompanionBuilder = StockHoldingsCompanion
    Function({
  Value<String> id,
  required String stockCode,
  required String stockName,
  required double totalShares,
  required double totalCost,
  Value<double> lastPrice,
  required String accountId,
  Value<DateTime?> lastUpdate,
  Value<bool> isActive,
  Value<int> rowid,
});
typedef $$StockHoldingsTableUpdateCompanionBuilder = StockHoldingsCompanion
    Function({
  Value<String> id,
  Value<String> stockCode,
  Value<String> stockName,
  Value<double> totalShares,
  Value<double> totalCost,
  Value<double> lastPrice,
  Value<String> accountId,
  Value<DateTime?> lastUpdate,
  Value<bool> isActive,
  Value<int> rowid,
});

class $$StockHoldingsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockHoldingsTable,
    StockHolding,
    $$StockHoldingsTableFilterComposer,
    $$StockHoldingsTableOrderingComposer,
    $$StockHoldingsTableCreateCompanionBuilder,
    $$StockHoldingsTableUpdateCompanionBuilder> {
  $$StockHoldingsTableTableManager(_$AppDatabase db, $StockHoldingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StockHoldingsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$StockHoldingsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> stockCode = const Value.absent(),
            Value<String> stockName = const Value.absent(),
            Value<double> totalShares = const Value.absent(),
            Value<double> totalCost = const Value.absent(),
            Value<double> lastPrice = const Value.absent(),
            Value<String> accountId = const Value.absent(),
            Value<DateTime?> lastUpdate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockHoldingsCompanion(
            id: id,
            stockCode: stockCode,
            stockName: stockName,
            totalShares: totalShares,
            totalCost: totalCost,
            lastPrice: lastPrice,
            accountId: accountId,
            lastUpdate: lastUpdate,
            isActive: isActive,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String stockCode,
            required String stockName,
            required double totalShares,
            required double totalCost,
            Value<double> lastPrice = const Value.absent(),
            required String accountId,
            Value<DateTime?> lastUpdate = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockHoldingsCompanion.insert(
            id: id,
            stockCode: stockCode,
            stockName: stockName,
            totalShares: totalShares,
            totalCost: totalCost,
            lastPrice: lastPrice,
            accountId: accountId,
            lastUpdate: lastUpdate,
            isActive: isActive,
            rowid: rowid,
          ),
        ));
}

class $$StockHoldingsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StockHoldingsTable> {
  $$StockHoldingsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get stockCode => $state.composableBuilder(
      column: $state.table.stockCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get stockName => $state.composableBuilder(
      column: $state.table.stockName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalShares => $state.composableBuilder(
      column: $state.table.totalShares,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalCost => $state.composableBuilder(
      column: $state.table.totalCost,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get lastPrice => $state.composableBuilder(
      column: $state.table.lastPrice,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastUpdate => $state.composableBuilder(
      column: $state.table.lastUpdate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableFilterComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }
}

class $$StockHoldingsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StockHoldingsTable> {
  $$StockHoldingsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get stockCode => $state.composableBuilder(
      column: $state.table.stockCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get stockName => $state.composableBuilder(
      column: $state.table.stockName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalShares => $state.composableBuilder(
      column: $state.table.totalShares,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalCost => $state.composableBuilder(
      column: $state.table.totalCost,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get lastPrice => $state.composableBuilder(
      column: $state.table.lastPrice,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastUpdate => $state.composableBuilder(
      column: $state.table.lastUpdate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isActive => $state.composableBuilder(
      column: $state.table.isActive,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $state.composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $state.db.accounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder, parentComposers) =>
            $$AccountsTableOrderingComposer(ComposerState(
                $state.db, $state.db.accounts, joinBuilder, parentComposers)));
    return composer;
  }
}

typedef $$StockTransactionsTableCreateCompanionBuilder
    = StockTransactionsCompanion Function({
  Value<String> id,
  required String stockCode,
  required String stockName,
  required String operation,
  required double shares,
  required double amount,
  required double price,
  Value<DateTime> tradeDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$StockTransactionsTableUpdateCompanionBuilder
    = StockTransactionsCompanion Function({
  Value<String> id,
  Value<String> stockCode,
  Value<String> stockName,
  Value<String> operation,
  Value<double> shares,
  Value<double> amount,
  Value<double> price,
  Value<DateTime> tradeDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$StockTransactionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockTransactionsTable,
    StockTransaction,
    $$StockTransactionsTableFilterComposer,
    $$StockTransactionsTableOrderingComposer,
    $$StockTransactionsTableCreateCompanionBuilder,
    $$StockTransactionsTableUpdateCompanionBuilder> {
  $$StockTransactionsTableTableManager(
      _$AppDatabase db, $StockTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$StockTransactionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$StockTransactionsTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> stockCode = const Value.absent(),
            Value<String> stockName = const Value.absent(),
            Value<String> operation = const Value.absent(),
            Value<double> shares = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<DateTime> tradeDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockTransactionsCompanion(
            id: id,
            stockCode: stockCode,
            stockName: stockName,
            operation: operation,
            shares: shares,
            amount: amount,
            price: price,
            tradeDate: tradeDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String stockCode,
            required String stockName,
            required String operation,
            required double shares,
            required double amount,
            required double price,
            Value<DateTime> tradeDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockTransactionsCompanion.insert(
            id: id,
            stockCode: stockCode,
            stockName: stockName,
            operation: operation,
            shares: shares,
            amount: amount,
            price: price,
            tradeDate: tradeDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$StockTransactionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $StockTransactionsTable> {
  $$StockTransactionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get stockCode => $state.composableBuilder(
      column: $state.table.stockCode,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get stockName => $state.composableBuilder(
      column: $state.table.stockName,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get operation => $state.composableBuilder(
      column: $state.table.operation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get shares => $state.composableBuilder(
      column: $state.table.shares,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get tradeDate => $state.composableBuilder(
      column: $state.table.tradeDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$StockTransactionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $StockTransactionsTable> {
  $$StockTransactionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get stockCode => $state.composableBuilder(
      column: $state.table.stockCode,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get stockName => $state.composableBuilder(
      column: $state.table.stockName,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get operation => $state.composableBuilder(
      column: $state.table.operation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get shares => $state.composableBuilder(
      column: $state.table.shares,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get price => $state.composableBuilder(
      column: $state.table.price,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get tradeDate => $state.composableBuilder(
      column: $state.table.tradeDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$FundHoldingsTableTableManager get fundHoldings =>
      $$FundHoldingsTableTableManager(_db, _db.fundHoldings);
  $$FundTransactionsTableTableManager get fundTransactions =>
      $$FundTransactionsTableTableManager(_db, _db.fundTransactions);
  $$StockHoldingsTableTableManager get stockHoldings =>
      $$StockHoldingsTableTableManager(_db, _db.stockHoldings);
  $$StockTransactionsTableTableManager get stockTransactions =>
      $$StockTransactionsTableTableManager(_db, _db.stockTransactions);
}
