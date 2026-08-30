// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
      'sku', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _baseUnitMeta =
      const VerificationMeta('baseUnit');
  @override
  late final GeneratedColumn<String> baseUnit = GeneratedColumn<String>(
      'base_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchasePriceMinorUnitsMeta =
      const VerificationMeta('purchasePriceMinorUnits');
  @override
  late final GeneratedColumn<int> purchasePriceMinorUnits =
      GeneratedColumn<int>('purchase_price_minor_units', aliasedName, false,
          type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _purchasePriceCurrencyMeta =
      const VerificationMeta('purchasePriceCurrency');
  @override
  late final GeneratedColumn<String> purchasePriceCurrency =
      GeneratedColumn<String>('purchase_price_currency', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('IDR'));
  static const VerificationMeta _sellingPriceMinorUnitsMeta =
      const VerificationMeta('sellingPriceMinorUnits');
  @override
  late final GeneratedColumn<int> sellingPriceMinorUnits = GeneratedColumn<int>(
      'selling_price_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sellingPriceCurrencyMeta =
      const VerificationMeta('sellingPriceCurrency');
  @override
  late final GeneratedColumn<String> sellingPriceCurrency =
      GeneratedColumn<String>('selling_price_currency', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('IDR'));
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
      'active', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("active" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        sku,
        name,
        baseUnit,
        purchasePriceMinorUnits,
        purchasePriceCurrency,
        sellingPriceMinorUnits,
        sellingPriceCurrency,
        active,
        isSynced,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(Insertable<ProductsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
          _skuMeta, sku.isAcceptableOrUnknown(data['sku']!, _skuMeta));
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('base_unit')) {
      context.handle(_baseUnitMeta,
          baseUnit.isAcceptableOrUnknown(data['base_unit']!, _baseUnitMeta));
    } else if (isInserting) {
      context.missing(_baseUnitMeta);
    }
    if (data.containsKey('purchase_price_minor_units')) {
      context.handle(
          _purchasePriceMinorUnitsMeta,
          purchasePriceMinorUnits.isAcceptableOrUnknown(
              data['purchase_price_minor_units']!,
              _purchasePriceMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_purchasePriceMinorUnitsMeta);
    }
    if (data.containsKey('purchase_price_currency')) {
      context.handle(
          _purchasePriceCurrencyMeta,
          purchasePriceCurrency.isAcceptableOrUnknown(
              data['purchase_price_currency']!, _purchasePriceCurrencyMeta));
    }
    if (data.containsKey('selling_price_minor_units')) {
      context.handle(
          _sellingPriceMinorUnitsMeta,
          sellingPriceMinorUnits.isAcceptableOrUnknown(
              data['selling_price_minor_units']!, _sellingPriceMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_sellingPriceMinorUnitsMeta);
    }
    if (data.containsKey('selling_price_currency')) {
      context.handle(
          _sellingPriceCurrencyMeta,
          sellingPriceCurrency.isAcceptableOrUnknown(
              data['selling_price_currency']!, _sellingPriceCurrencyMeta));
    }
    if (data.containsKey('active')) {
      context.handle(_activeMeta,
          active.isAcceptableOrUnknown(data['active']!, _activeMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      sku: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sku'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      baseUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}base_unit'])!,
      purchasePriceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}purchase_price_minor_units'])!,
      purchasePriceCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}purchase_price_currency'])!,
      sellingPriceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}selling_price_minor_units'])!,
      sellingPriceCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}selling_price_currency'])!,
      active: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}active'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductsTableData extends DataClass
    implements Insertable<ProductsTableData> {
  final String id;
  final String sku;
  final String name;
  final String baseUnit;
  final int purchasePriceMinorUnits;
  final String purchasePriceCurrency;
  final int sellingPriceMinorUnits;
  final String sellingPriceCurrency;
  final bool active;
  final bool isSynced;
  final DateTime? syncedAt;
  const ProductsTableData(
      {required this.id,
      required this.sku,
      required this.name,
      required this.baseUnit,
      required this.purchasePriceMinorUnits,
      required this.purchasePriceCurrency,
      required this.sellingPriceMinorUnits,
      required this.sellingPriceCurrency,
      required this.active,
      required this.isSynced,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sku'] = Variable<String>(sku);
    map['name'] = Variable<String>(name);
    map['base_unit'] = Variable<String>(baseUnit);
    map['purchase_price_minor_units'] = Variable<int>(purchasePriceMinorUnits);
    map['purchase_price_currency'] = Variable<String>(purchasePriceCurrency);
    map['selling_price_minor_units'] = Variable<int>(sellingPriceMinorUnits);
    map['selling_price_currency'] = Variable<String>(sellingPriceCurrency);
    map['active'] = Variable<bool>(active);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      sku: Value(sku),
      name: Value(name),
      baseUnit: Value(baseUnit),
      purchasePriceMinorUnits: Value(purchasePriceMinorUnits),
      purchasePriceCurrency: Value(purchasePriceCurrency),
      sellingPriceMinorUnits: Value(sellingPriceMinorUnits),
      sellingPriceCurrency: Value(sellingPriceCurrency),
      active: Value(active),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory ProductsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      name: serializer.fromJson<String>(json['name']),
      baseUnit: serializer.fromJson<String>(json['baseUnit']),
      purchasePriceMinorUnits:
          serializer.fromJson<int>(json['purchasePriceMinorUnits']),
      purchasePriceCurrency:
          serializer.fromJson<String>(json['purchasePriceCurrency']),
      sellingPriceMinorUnits:
          serializer.fromJson<int>(json['sellingPriceMinorUnits']),
      sellingPriceCurrency:
          serializer.fromJson<String>(json['sellingPriceCurrency']),
      active: serializer.fromJson<bool>(json['active']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sku': serializer.toJson<String>(sku),
      'name': serializer.toJson<String>(name),
      'baseUnit': serializer.toJson<String>(baseUnit),
      'purchasePriceMinorUnits':
          serializer.toJson<int>(purchasePriceMinorUnits),
      'purchasePriceCurrency': serializer.toJson<String>(purchasePriceCurrency),
      'sellingPriceMinorUnits': serializer.toJson<int>(sellingPriceMinorUnits),
      'sellingPriceCurrency': serializer.toJson<String>(sellingPriceCurrency),
      'active': serializer.toJson<bool>(active),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  ProductsTableData copyWith(
          {String? id,
          String? sku,
          String? name,
          String? baseUnit,
          int? purchasePriceMinorUnits,
          String? purchasePriceCurrency,
          int? sellingPriceMinorUnits,
          String? sellingPriceCurrency,
          bool? active,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      ProductsTableData(
        id: id ?? this.id,
        sku: sku ?? this.sku,
        name: name ?? this.name,
        baseUnit: baseUnit ?? this.baseUnit,
        purchasePriceMinorUnits:
            purchasePriceMinorUnits ?? this.purchasePriceMinorUnits,
        purchasePriceCurrency:
            purchasePriceCurrency ?? this.purchasePriceCurrency,
        sellingPriceMinorUnits:
            sellingPriceMinorUnits ?? this.sellingPriceMinorUnits,
        sellingPriceCurrency: sellingPriceCurrency ?? this.sellingPriceCurrency,
        active: active ?? this.active,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  ProductsTableData copyWithCompanion(ProductsTableCompanion data) {
    return ProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      name: data.name.present ? data.name.value : this.name,
      baseUnit: data.baseUnit.present ? data.baseUnit.value : this.baseUnit,
      purchasePriceMinorUnits: data.purchasePriceMinorUnits.present
          ? data.purchasePriceMinorUnits.value
          : this.purchasePriceMinorUnits,
      purchasePriceCurrency: data.purchasePriceCurrency.present
          ? data.purchasePriceCurrency.value
          : this.purchasePriceCurrency,
      sellingPriceMinorUnits: data.sellingPriceMinorUnits.present
          ? data.sellingPriceMinorUnits.value
          : this.sellingPriceMinorUnits,
      sellingPriceCurrency: data.sellingPriceCurrency.present
          ? data.sellingPriceCurrency.value
          : this.sellingPriceCurrency,
      active: data.active.present ? data.active.value : this.active,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableData(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('baseUnit: $baseUnit, ')
          ..write('purchasePriceMinorUnits: $purchasePriceMinorUnits, ')
          ..write('purchasePriceCurrency: $purchasePriceCurrency, ')
          ..write('sellingPriceMinorUnits: $sellingPriceMinorUnits, ')
          ..write('sellingPriceCurrency: $sellingPriceCurrency, ')
          ..write('active: $active, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      sku,
      name,
      baseUnit,
      purchasePriceMinorUnits,
      purchasePriceCurrency,
      sellingPriceMinorUnits,
      sellingPriceCurrency,
      active,
      isSynced,
      syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductsTableData &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.name == this.name &&
          other.baseUnit == this.baseUnit &&
          other.purchasePriceMinorUnits == this.purchasePriceMinorUnits &&
          other.purchasePriceCurrency == this.purchasePriceCurrency &&
          other.sellingPriceMinorUnits == this.sellingPriceMinorUnits &&
          other.sellingPriceCurrency == this.sellingPriceCurrency &&
          other.active == this.active &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class ProductsTableCompanion extends UpdateCompanion<ProductsTableData> {
  final Value<String> id;
  final Value<String> sku;
  final Value<String> name;
  final Value<String> baseUnit;
  final Value<int> purchasePriceMinorUnits;
  final Value<String> purchasePriceCurrency;
  final Value<int> sellingPriceMinorUnits;
  final Value<String> sellingPriceCurrency;
  final Value<bool> active;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.name = const Value.absent(),
    this.baseUnit = const Value.absent(),
    this.purchasePriceMinorUnits = const Value.absent(),
    this.purchasePriceCurrency = const Value.absent(),
    this.sellingPriceMinorUnits = const Value.absent(),
    this.sellingPriceCurrency = const Value.absent(),
    this.active = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    required String id,
    required String sku,
    required String name,
    required String baseUnit,
    required int purchasePriceMinorUnits,
    this.purchasePriceCurrency = const Value.absent(),
    required int sellingPriceMinorUnits,
    this.sellingPriceCurrency = const Value.absent(),
    this.active = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        sku = Value(sku),
        name = Value(name),
        baseUnit = Value(baseUnit),
        purchasePriceMinorUnits = Value(purchasePriceMinorUnits),
        sellingPriceMinorUnits = Value(sellingPriceMinorUnits);
  static Insertable<ProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? sku,
    Expression<String>? name,
    Expression<String>? baseUnit,
    Expression<int>? purchasePriceMinorUnits,
    Expression<String>? purchasePriceCurrency,
    Expression<int>? sellingPriceMinorUnits,
    Expression<String>? sellingPriceCurrency,
    Expression<bool>? active,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (baseUnit != null) 'base_unit': baseUnit,
      if (purchasePriceMinorUnits != null)
        'purchase_price_minor_units': purchasePriceMinorUnits,
      if (purchasePriceCurrency != null)
        'purchase_price_currency': purchasePriceCurrency,
      if (sellingPriceMinorUnits != null)
        'selling_price_minor_units': sellingPriceMinorUnits,
      if (sellingPriceCurrency != null)
        'selling_price_currency': sellingPriceCurrency,
      if (active != null) 'active': active,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? sku,
      Value<String>? name,
      Value<String>? baseUnit,
      Value<int>? purchasePriceMinorUnits,
      Value<String>? purchasePriceCurrency,
      Value<int>? sellingPriceMinorUnits,
      Value<String>? sellingPriceCurrency,
      Value<bool>? active,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      baseUnit: baseUnit ?? this.baseUnit,
      purchasePriceMinorUnits:
          purchasePriceMinorUnits ?? this.purchasePriceMinorUnits,
      purchasePriceCurrency:
          purchasePriceCurrency ?? this.purchasePriceCurrency,
      sellingPriceMinorUnits:
          sellingPriceMinorUnits ?? this.sellingPriceMinorUnits,
      sellingPriceCurrency: sellingPriceCurrency ?? this.sellingPriceCurrency,
      active: active ?? this.active,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (baseUnit.present) {
      map['base_unit'] = Variable<String>(baseUnit.value);
    }
    if (purchasePriceMinorUnits.present) {
      map['purchase_price_minor_units'] =
          Variable<int>(purchasePriceMinorUnits.value);
    }
    if (purchasePriceCurrency.present) {
      map['purchase_price_currency'] =
          Variable<String>(purchasePriceCurrency.value);
    }
    if (sellingPriceMinorUnits.present) {
      map['selling_price_minor_units'] =
          Variable<int>(sellingPriceMinorUnits.value);
    }
    if (sellingPriceCurrency.present) {
      map['selling_price_currency'] =
          Variable<String>(sellingPriceCurrency.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('baseUnit: $baseUnit, ')
          ..write('purchasePriceMinorUnits: $purchasePriceMinorUnits, ')
          ..write('purchasePriceCurrency: $purchasePriceCurrency, ')
          ..write('sellingPriceMinorUnits: $sellingPriceMinorUnits, ')
          ..write('sellingPriceCurrency: $sellingPriceCurrency, ')
          ..write('active: $active, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTableTable extends CustomersTable
    with TableInfo<$CustomersTableTable, CustomersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _phoneNumberMeta =
      const VerificationMeta('phoneNumber');
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
      'phone_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phoneNumber, address, notes, createdAt, isSynced, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers_table';
  @override
  VerificationContext validateIntegrity(Insertable<CustomersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
          _phoneNumberMeta,
          phoneNumber.isAcceptableOrUnknown(
              data['phone_number']!, _phoneNumberMeta));
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      phoneNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}phone_number'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $CustomersTableTable createAlias(String alias) {
    return $CustomersTableTable(attachedDatabase, alias);
  }
}

class CustomersTableData extends DataClass
    implements Insertable<CustomersTableData> {
  final String id;
  final String name;
  final String phoneNumber;
  final String? address;
  final String? notes;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? syncedAt;
  const CustomersTableData(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.address,
      this.notes,
      required this.createdAt,
      required this.isSynced,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['phone_number'] = Variable<String>(phoneNumber);
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  CustomersTableCompanion toCompanion(bool nullToAbsent) {
    return CustomersTableCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: Value(phoneNumber),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory CustomersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomersTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      address: serializer.fromJson<String?>(json['address']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'address': serializer.toJson<String?>(address),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  CustomersTableData copyWith(
          {String? id,
          String? name,
          String? phoneNumber,
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      CustomersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  CustomersTableData copyWithCompanion(CustomersTableCompanion data) {
    return CustomersTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber:
          data.phoneNumber.present ? data.phoneNumber.value : this.phoneNumber,
      address: data.address.present ? data.address.value : this.address,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomersTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, phoneNumber, address, notes, createdAt, isSynced, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class CustomersTableCompanion extends UpdateCompanion<CustomersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const CustomersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersTableCompanion.insert({
    required String id,
    required String name,
    required String phoneNumber,
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        phoneNumber = Value(phoneNumber),
        createdAt = Value(createdAt);
  static Insertable<CustomersTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<String>? address,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? phoneNumber,
      Value<String?>? address,
      Value<String?>? notes,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return CustomersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
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
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('address: $address, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CostLayersTableTable extends CostLayersTable
    with TableInfo<$CostLayersTableTable, CostLayersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CostLayersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _originalQuantityValueMeta =
      const VerificationMeta('originalQuantityValue');
  @override
  late final GeneratedColumn<int> originalQuantityValue = GeneratedColumn<int>(
      'original_quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _originalQuantityScaleMeta =
      const VerificationMeta('originalQuantityScale');
  @override
  late final GeneratedColumn<int> originalQuantityScale = GeneratedColumn<int>(
      'original_quantity_scale', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _remainingQuantityValueMeta =
      const VerificationMeta('remainingQuantityValue');
  @override
  late final GeneratedColumn<int> remainingQuantityValue = GeneratedColumn<int>(
      'remaining_quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _remainingQuantityScaleMeta =
      const VerificationMeta('remainingQuantityScale');
  @override
  late final GeneratedColumn<int> remainingQuantityScale = GeneratedColumn<int>(
      'remaining_quantity_scale', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostMinorUnitsMeta =
      const VerificationMeta('unitCostMinorUnits');
  @override
  late final GeneratedColumn<int> unitCostMinorUnits = GeneratedColumn<int>(
      'unit_cost_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostCurrencyMeta =
      const VerificationMeta('unitCostCurrency');
  @override
  late final GeneratedColumn<String> unitCostCurrency = GeneratedColumn<String>(
      'unit_cost_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('IDR'));
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
      'purchase_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _acquiredAtMeta =
      const VerificationMeta('acquiredAt');
  @override
  late final GeneratedColumn<DateTime> acquiredAt = GeneratedColumn<DateTime>(
      'acquired_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        originalQuantityValue,
        originalQuantityScale,
        remainingQuantityValue,
        remainingQuantityScale,
        unitCostMinorUnits,
        unitCostCurrency,
        purchaseId,
        acquiredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cost_layers_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CostLayersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('original_quantity_value')) {
      context.handle(
          _originalQuantityValueMeta,
          originalQuantityValue.isAcceptableOrUnknown(
              data['original_quantity_value']!, _originalQuantityValueMeta));
    } else if (isInserting) {
      context.missing(_originalQuantityValueMeta);
    }
    if (data.containsKey('original_quantity_scale')) {
      context.handle(
          _originalQuantityScaleMeta,
          originalQuantityScale.isAcceptableOrUnknown(
              data['original_quantity_scale']!, _originalQuantityScaleMeta));
    } else if (isInserting) {
      context.missing(_originalQuantityScaleMeta);
    }
    if (data.containsKey('remaining_quantity_value')) {
      context.handle(
          _remainingQuantityValueMeta,
          remainingQuantityValue.isAcceptableOrUnknown(
              data['remaining_quantity_value']!, _remainingQuantityValueMeta));
    } else if (isInserting) {
      context.missing(_remainingQuantityValueMeta);
    }
    if (data.containsKey('remaining_quantity_scale')) {
      context.handle(
          _remainingQuantityScaleMeta,
          remainingQuantityScale.isAcceptableOrUnknown(
              data['remaining_quantity_scale']!, _remainingQuantityScaleMeta));
    } else if (isInserting) {
      context.missing(_remainingQuantityScaleMeta);
    }
    if (data.containsKey('unit_cost_minor_units')) {
      context.handle(
          _unitCostMinorUnitsMeta,
          unitCostMinorUnits.isAcceptableOrUnknown(
              data['unit_cost_minor_units']!, _unitCostMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_unitCostMinorUnitsMeta);
    }
    if (data.containsKey('unit_cost_currency')) {
      context.handle(
          _unitCostCurrencyMeta,
          unitCostCurrency.isAcceptableOrUnknown(
              data['unit_cost_currency']!, _unitCostCurrencyMeta));
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    }
    if (data.containsKey('acquired_at')) {
      context.handle(
          _acquiredAtMeta,
          acquiredAt.isAcceptableOrUnknown(
              data['acquired_at']!, _acquiredAtMeta));
    } else if (isInserting) {
      context.missing(_acquiredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CostLayersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CostLayersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      originalQuantityValue: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}original_quantity_value'])!,
      originalQuantityScale: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}original_quantity_scale'])!,
      remainingQuantityValue: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}remaining_quantity_value'])!,
      remainingQuantityScale: attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}remaining_quantity_scale'])!,
      unitCostMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_cost_minor_units'])!,
      unitCostCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_cost_currency'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_id']),
      acquiredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}acquired_at'])!,
    );
  }

  @override
  $CostLayersTableTable createAlias(String alias) {
    return $CostLayersTableTable(attachedDatabase, alias);
  }
}

class CostLayersTableData extends DataClass
    implements Insertable<CostLayersTableData> {
  final String id;
  final String productId;
  final int originalQuantityValue;
  final int originalQuantityScale;
  final int remainingQuantityValue;
  final int remainingQuantityScale;
  final int unitCostMinorUnits;
  final String unitCostCurrency;
  final String? purchaseId;
  final DateTime acquiredAt;
  const CostLayersTableData(
      {required this.id,
      required this.productId,
      required this.originalQuantityValue,
      required this.originalQuantityScale,
      required this.remainingQuantityValue,
      required this.remainingQuantityScale,
      required this.unitCostMinorUnits,
      required this.unitCostCurrency,
      this.purchaseId,
      required this.acquiredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['original_quantity_value'] = Variable<int>(originalQuantityValue);
    map['original_quantity_scale'] = Variable<int>(originalQuantityScale);
    map['remaining_quantity_value'] = Variable<int>(remainingQuantityValue);
    map['remaining_quantity_scale'] = Variable<int>(remainingQuantityScale);
    map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits);
    map['unit_cost_currency'] = Variable<String>(unitCostCurrency);
    if (!nullToAbsent || purchaseId != null) {
      map['purchase_id'] = Variable<String>(purchaseId);
    }
    map['acquired_at'] = Variable<DateTime>(acquiredAt);
    return map;
  }

  CostLayersTableCompanion toCompanion(bool nullToAbsent) {
    return CostLayersTableCompanion(
      id: Value(id),
      productId: Value(productId),
      originalQuantityValue: Value(originalQuantityValue),
      originalQuantityScale: Value(originalQuantityScale),
      remainingQuantityValue: Value(remainingQuantityValue),
      remainingQuantityScale: Value(remainingQuantityScale),
      unitCostMinorUnits: Value(unitCostMinorUnits),
      unitCostCurrency: Value(unitCostCurrency),
      purchaseId: purchaseId == null && nullToAbsent
          ? const Value.absent()
          : Value(purchaseId),
      acquiredAt: Value(acquiredAt),
    );
  }

  factory CostLayersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CostLayersTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      originalQuantityValue:
          serializer.fromJson<int>(json['originalQuantityValue']),
      originalQuantityScale:
          serializer.fromJson<int>(json['originalQuantityScale']),
      remainingQuantityValue:
          serializer.fromJson<int>(json['remainingQuantityValue']),
      remainingQuantityScale:
          serializer.fromJson<int>(json['remainingQuantityScale']),
      unitCostMinorUnits: serializer.fromJson<int>(json['unitCostMinorUnits']),
      unitCostCurrency: serializer.fromJson<String>(json['unitCostCurrency']),
      purchaseId: serializer.fromJson<String?>(json['purchaseId']),
      acquiredAt: serializer.fromJson<DateTime>(json['acquiredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'originalQuantityValue': serializer.toJson<int>(originalQuantityValue),
      'originalQuantityScale': serializer.toJson<int>(originalQuantityScale),
      'remainingQuantityValue': serializer.toJson<int>(remainingQuantityValue),
      'remainingQuantityScale': serializer.toJson<int>(remainingQuantityScale),
      'unitCostMinorUnits': serializer.toJson<int>(unitCostMinorUnits),
      'unitCostCurrency': serializer.toJson<String>(unitCostCurrency),
      'purchaseId': serializer.toJson<String?>(purchaseId),
      'acquiredAt': serializer.toJson<DateTime>(acquiredAt),
    };
  }

  CostLayersTableData copyWith(
          {String? id,
          String? productId,
          int? originalQuantityValue,
          int? originalQuantityScale,
          int? remainingQuantityValue,
          int? remainingQuantityScale,
          int? unitCostMinorUnits,
          String? unitCostCurrency,
          Value<String?> purchaseId = const Value.absent(),
          DateTime? acquiredAt}) =>
      CostLayersTableData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        originalQuantityValue:
            originalQuantityValue ?? this.originalQuantityValue,
        originalQuantityScale:
            originalQuantityScale ?? this.originalQuantityScale,
        remainingQuantityValue:
            remainingQuantityValue ?? this.remainingQuantityValue,
        remainingQuantityScale:
            remainingQuantityScale ?? this.remainingQuantityScale,
        unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
        unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
        purchaseId: purchaseId.present ? purchaseId.value : this.purchaseId,
        acquiredAt: acquiredAt ?? this.acquiredAt,
      );
  CostLayersTableData copyWithCompanion(CostLayersTableCompanion data) {
    return CostLayersTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      originalQuantityValue: data.originalQuantityValue.present
          ? data.originalQuantityValue.value
          : this.originalQuantityValue,
      originalQuantityScale: data.originalQuantityScale.present
          ? data.originalQuantityScale.value
          : this.originalQuantityScale,
      remainingQuantityValue: data.remainingQuantityValue.present
          ? data.remainingQuantityValue.value
          : this.remainingQuantityValue,
      remainingQuantityScale: data.remainingQuantityScale.present
          ? data.remainingQuantityScale.value
          : this.remainingQuantityScale,
      unitCostMinorUnits: data.unitCostMinorUnits.present
          ? data.unitCostMinorUnits.value
          : this.unitCostMinorUnits,
      unitCostCurrency: data.unitCostCurrency.present
          ? data.unitCostCurrency.value
          : this.unitCostCurrency,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      acquiredAt:
          data.acquiredAt.present ? data.acquiredAt.value : this.acquiredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CostLayersTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('originalQuantityValue: $originalQuantityValue, ')
          ..write('originalQuantityScale: $originalQuantityScale, ')
          ..write('remainingQuantityValue: $remainingQuantityValue, ')
          ..write('remainingQuantityScale: $remainingQuantityScale, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('acquiredAt: $acquiredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      productId,
      originalQuantityValue,
      originalQuantityScale,
      remainingQuantityValue,
      remainingQuantityScale,
      unitCostMinorUnits,
      unitCostCurrency,
      purchaseId,
      acquiredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CostLayersTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.originalQuantityValue == this.originalQuantityValue &&
          other.originalQuantityScale == this.originalQuantityScale &&
          other.remainingQuantityValue == this.remainingQuantityValue &&
          other.remainingQuantityScale == this.remainingQuantityScale &&
          other.unitCostMinorUnits == this.unitCostMinorUnits &&
          other.unitCostCurrency == this.unitCostCurrency &&
          other.purchaseId == this.purchaseId &&
          other.acquiredAt == this.acquiredAt);
}

class CostLayersTableCompanion extends UpdateCompanion<CostLayersTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<int> originalQuantityValue;
  final Value<int> originalQuantityScale;
  final Value<int> remainingQuantityValue;
  final Value<int> remainingQuantityScale;
  final Value<int> unitCostMinorUnits;
  final Value<String> unitCostCurrency;
  final Value<String?> purchaseId;
  final Value<DateTime> acquiredAt;
  final Value<int> rowid;
  const CostLayersTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.originalQuantityValue = const Value.absent(),
    this.originalQuantityScale = const Value.absent(),
    this.remainingQuantityValue = const Value.absent(),
    this.remainingQuantityScale = const Value.absent(),
    this.unitCostMinorUnits = const Value.absent(),
    this.unitCostCurrency = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.acquiredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CostLayersTableCompanion.insert({
    required String id,
    required String productId,
    required int originalQuantityValue,
    required int originalQuantityScale,
    required int remainingQuantityValue,
    required int remainingQuantityScale,
    required int unitCostMinorUnits,
    this.unitCostCurrency = const Value.absent(),
    this.purchaseId = const Value.absent(),
    required DateTime acquiredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        originalQuantityValue = Value(originalQuantityValue),
        originalQuantityScale = Value(originalQuantityScale),
        remainingQuantityValue = Value(remainingQuantityValue),
        remainingQuantityScale = Value(remainingQuantityScale),
        unitCostMinorUnits = Value(unitCostMinorUnits),
        acquiredAt = Value(acquiredAt);
  static Insertable<CostLayersTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<int>? originalQuantityValue,
    Expression<int>? originalQuantityScale,
    Expression<int>? remainingQuantityValue,
    Expression<int>? remainingQuantityScale,
    Expression<int>? unitCostMinorUnits,
    Expression<String>? unitCostCurrency,
    Expression<String>? purchaseId,
    Expression<DateTime>? acquiredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (originalQuantityValue != null)
        'original_quantity_value': originalQuantityValue,
      if (originalQuantityScale != null)
        'original_quantity_scale': originalQuantityScale,
      if (remainingQuantityValue != null)
        'remaining_quantity_value': remainingQuantityValue,
      if (remainingQuantityScale != null)
        'remaining_quantity_scale': remainingQuantityScale,
      if (unitCostMinorUnits != null)
        'unit_cost_minor_units': unitCostMinorUnits,
      if (unitCostCurrency != null) 'unit_cost_currency': unitCostCurrency,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (acquiredAt != null) 'acquired_at': acquiredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CostLayersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<int>? originalQuantityValue,
      Value<int>? originalQuantityScale,
      Value<int>? remainingQuantityValue,
      Value<int>? remainingQuantityScale,
      Value<int>? unitCostMinorUnits,
      Value<String>? unitCostCurrency,
      Value<String?>? purchaseId,
      Value<DateTime>? acquiredAt,
      Value<int>? rowid}) {
    return CostLayersTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      originalQuantityValue:
          originalQuantityValue ?? this.originalQuantityValue,
      originalQuantityScale:
          originalQuantityScale ?? this.originalQuantityScale,
      remainingQuantityValue:
          remainingQuantityValue ?? this.remainingQuantityValue,
      remainingQuantityScale:
          remainingQuantityScale ?? this.remainingQuantityScale,
      unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
      unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
      purchaseId: purchaseId ?? this.purchaseId,
      acquiredAt: acquiredAt ?? this.acquiredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (originalQuantityValue.present) {
      map['original_quantity_value'] =
          Variable<int>(originalQuantityValue.value);
    }
    if (originalQuantityScale.present) {
      map['original_quantity_scale'] =
          Variable<int>(originalQuantityScale.value);
    }
    if (remainingQuantityValue.present) {
      map['remaining_quantity_value'] =
          Variable<int>(remainingQuantityValue.value);
    }
    if (remainingQuantityScale.present) {
      map['remaining_quantity_scale'] =
          Variable<int>(remainingQuantityScale.value);
    }
    if (unitCostMinorUnits.present) {
      map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits.value);
    }
    if (unitCostCurrency.present) {
      map['unit_cost_currency'] = Variable<String>(unitCostCurrency.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (acquiredAt.present) {
      map['acquired_at'] = Variable<DateTime>(acquiredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CostLayersTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('originalQuantityValue: $originalQuantityValue, ')
          ..write('originalQuantityScale: $originalQuantityScale, ')
          ..write('remainingQuantityValue: $remainingQuantityValue, ')
          ..write('remainingQuantityScale: $remainingQuantityScale, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('acquiredAt: $acquiredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceivingsTableTable extends ReceivingsTable
    with TableInfo<$ReceivingsTableTable, ReceivingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceivingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receivedAtMeta =
      const VerificationMeta('receivedAt');
  @override
  late final GeneratedColumn<DateTime> receivedAt = GeneratedColumn<DateTime>(
      'received_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchaseId, receivedAt, isSynced, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receivings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReceivingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('received_at')) {
      context.handle(
          _receivedAtMeta,
          receivedAt.isAcceptableOrUnknown(
              data['received_at']!, _receivedAtMeta));
    } else if (isInserting) {
      context.missing(_receivedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceivingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceivingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_id'])!,
      receivedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}received_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $ReceivingsTableTable createAlias(String alias) {
    return $ReceivingsTableTable(attachedDatabase, alias);
  }
}

class ReceivingsTableData extends DataClass
    implements Insertable<ReceivingsTableData> {
  final String id;
  final String purchaseId;
  final DateTime receivedAt;
  final bool isSynced;
  final DateTime? syncedAt;
  const ReceivingsTableData(
      {required this.id,
      required this.purchaseId,
      required this.receivedAt,
      required this.isSynced,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['received_at'] = Variable<DateTime>(receivedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  ReceivingsTableCompanion toCompanion(bool nullToAbsent) {
    return ReceivingsTableCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      receivedAt: Value(receivedAt),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory ReceivingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceivingsTableData(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  ReceivingsTableData copyWith(
          {String? id,
          String? purchaseId,
          DateTime? receivedAt,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      ReceivingsTableData(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        receivedAt: receivedAt ?? this.receivedAt,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  ReceivingsTableData copyWithCompanion(ReceivingsTableCompanion data) {
    return ReceivingsTableData(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceivingsTableData(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, purchaseId, receivedAt, isSynced, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceivingsTableData &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.receivedAt == this.receivedAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class ReceivingsTableCompanion extends UpdateCompanion<ReceivingsTableData> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<DateTime> receivedAt;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const ReceivingsTableCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceivingsTableCompanion.insert({
    required String id,
    required String purchaseId,
    required DateTime receivedAt,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchaseId = Value(purchaseId),
        receivedAt = Value(receivedAt);
  static Insertable<ReceivingsTableData> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<DateTime>? receivedAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (receivedAt != null) 'received_at': receivedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceivingsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? purchaseId,
      Value<DateTime>? receivedAt,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return ReceivingsTableCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      receivedAt: receivedAt ?? this.receivedAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (receivedAt.present) {
      map['received_at'] = Variable<DateTime>(receivedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceivingsTableCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('receivedAt: $receivedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReceivingItemsTableTable extends ReceivingItemsTable
    with TableInfo<$ReceivingItemsTableTable, ReceivingItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReceivingItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _receivingIdMeta =
      const VerificationMeta('receivingId');
  @override
  late final GeneratedColumn<String> receivingId = GeneratedColumn<String>(
      'receiving_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityValueMeta =
      const VerificationMeta('quantityValue');
  @override
  late final GeneratedColumn<int> quantityValue = GeneratedColumn<int>(
      'quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitCostMinorUnitsMeta =
      const VerificationMeta('unitCostMinorUnits');
  @override
  late final GeneratedColumn<int> unitCostMinorUnits = GeneratedColumn<int>(
      'unit_cost_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostCurrencyMeta =
      const VerificationMeta('unitCostCurrency');
  @override
  late final GeneratedColumn<String> unitCostCurrency = GeneratedColumn<String>(
      'unit_cost_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('IDR'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        receivingId,
        productId,
        quantityValue,
        quantityScale,
        unit,
        unitCostMinorUnits,
        unitCostCurrency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'receiving_items_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ReceivingItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('receiving_id')) {
      context.handle(
          _receivingIdMeta,
          receivingId.isAcceptableOrUnknown(
              data['receiving_id']!, _receivingIdMeta));
    } else if (isInserting) {
      context.missing(_receivingIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_value')) {
      context.handle(
          _quantityValueMeta,
          quantityValue.isAcceptableOrUnknown(
              data['quantity_value']!, _quantityValueMeta));
    } else if (isInserting) {
      context.missing(_quantityValueMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('unit_cost_minor_units')) {
      context.handle(
          _unitCostMinorUnitsMeta,
          unitCostMinorUnits.isAcceptableOrUnknown(
              data['unit_cost_minor_units']!, _unitCostMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_unitCostMinorUnitsMeta);
    }
    if (data.containsKey('unit_cost_currency')) {
      context.handle(
          _unitCostCurrencyMeta,
          unitCostCurrency.isAcceptableOrUnknown(
              data['unit_cost_currency']!, _unitCostCurrencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReceivingItemsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReceivingItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      receivingId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}receiving_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_value'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      unitCostMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_cost_minor_units'])!,
      unitCostCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_cost_currency'])!,
    );
  }

  @override
  $ReceivingItemsTableTable createAlias(String alias) {
    return $ReceivingItemsTableTable(attachedDatabase, alias);
  }
}

class ReceivingItemsTableData extends DataClass
    implements Insertable<ReceivingItemsTableData> {
  final String id;
  final String receivingId;
  final String productId;
  final int quantityValue;
  final int quantityScale;
  final String? unit;
  final int unitCostMinorUnits;
  final String unitCostCurrency;
  const ReceivingItemsTableData(
      {required this.id,
      required this.receivingId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
      this.unit,
      required this.unitCostMinorUnits,
      required this.unitCostCurrency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['receiving_id'] = Variable<String>(receivingId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_value'] = Variable<int>(quantityValue);
    map['quantity_scale'] = Variable<int>(quantityScale);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits);
    map['unit_cost_currency'] = Variable<String>(unitCostCurrency);
    return map;
  }

  ReceivingItemsTableCompanion toCompanion(bool nullToAbsent) {
    return ReceivingItemsTableCompanion(
      id: Value(id),
      receivingId: Value(receivingId),
      productId: Value(productId),
      quantityValue: Value(quantityValue),
      quantityScale: Value(quantityScale),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      unitCostMinorUnits: Value(unitCostMinorUnits),
      unitCostCurrency: Value(unitCostCurrency),
    );
  }

  factory ReceivingItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceivingItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      receivingId: serializer.fromJson<String>(json['receivingId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityValue: serializer.fromJson<int>(json['quantityValue']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      unit: serializer.fromJson<String?>(json['unit']),
      unitCostMinorUnits: serializer.fromJson<int>(json['unitCostMinorUnits']),
      unitCostCurrency: serializer.fromJson<String>(json['unitCostCurrency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'receivingId': serializer.toJson<String>(receivingId),
      'productId': serializer.toJson<String>(productId),
      'quantityValue': serializer.toJson<int>(quantityValue),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'unit': serializer.toJson<String?>(unit),
      'unitCostMinorUnits': serializer.toJson<int>(unitCostMinorUnits),
      'unitCostCurrency': serializer.toJson<String>(unitCostCurrency),
    };
  }

  ReceivingItemsTableData copyWith(
          {String? id,
          String? receivingId,
          String? productId,
          int? quantityValue,
          int? quantityScale,
          Value<String?> unit = const Value.absent(),
          int? unitCostMinorUnits,
          String? unitCostCurrency}) =>
      ReceivingItemsTableData(
        id: id ?? this.id,
        receivingId: receivingId ?? this.receivingId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
        unit: unit.present ? unit.value : this.unit,
        unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
        unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
      );
  ReceivingItemsTableData copyWithCompanion(ReceivingItemsTableCompanion data) {
    return ReceivingItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      receivingId:
          data.receivingId.present ? data.receivingId.value : this.receivingId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityValue: data.quantityValue.present
          ? data.quantityValue.value
          : this.quantityValue,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitCostMinorUnits: data.unitCostMinorUnits.present
          ? data.unitCostMinorUnits.value
          : this.unitCostMinorUnits,
      unitCostCurrency: data.unitCostCurrency.present
          ? data.unitCostCurrency.value
          : this.unitCostCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceivingItemsTableData(')
          ..write('id: $id, ')
          ..write('receivingId: $receivingId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('unit: $unit, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, receivingId, productId, quantityValue,
      quantityScale, unit, unitCostMinorUnits, unitCostCurrency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceivingItemsTableData &&
          other.id == this.id &&
          other.receivingId == this.receivingId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
          other.unit == this.unit &&
          other.unitCostMinorUnits == this.unitCostMinorUnits &&
          other.unitCostCurrency == this.unitCostCurrency);
}

class ReceivingItemsTableCompanion
    extends UpdateCompanion<ReceivingItemsTableData> {
  final Value<String> id;
  final Value<String> receivingId;
  final Value<String> productId;
  final Value<int> quantityValue;
  final Value<int> quantityScale;
  final Value<String?> unit;
  final Value<int> unitCostMinorUnits;
  final Value<String> unitCostCurrency;
  final Value<int> rowid;
  const ReceivingItemsTableCompanion({
    this.id = const Value.absent(),
    this.receivingId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitCostMinorUnits = const Value.absent(),
    this.unitCostCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceivingItemsTableCompanion.insert({
    required String id,
    required String receivingId,
    required String productId,
    required int quantityValue,
    this.quantityScale = const Value.absent(),
    this.unit = const Value.absent(),
    required int unitCostMinorUnits,
    this.unitCostCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        receivingId = Value(receivingId),
        productId = Value(productId),
        quantityValue = Value(quantityValue),
        unitCostMinorUnits = Value(unitCostMinorUnits);
  static Insertable<ReceivingItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? receivingId,
    Expression<String>? productId,
    Expression<int>? quantityValue,
    Expression<int>? quantityScale,
    Expression<String>? unit,
    Expression<int>? unitCostMinorUnits,
    Expression<String>? unitCostCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receivingId != null) 'receiving_id': receivingId,
      if (productId != null) 'product_id': productId,
      if (quantityValue != null) 'quantity_value': quantityValue,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (unit != null) 'unit': unit,
      if (unitCostMinorUnits != null)
        'unit_cost_minor_units': unitCostMinorUnits,
      if (unitCostCurrency != null) 'unit_cost_currency': unitCostCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceivingItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? receivingId,
      Value<String>? productId,
      Value<int>? quantityValue,
      Value<int>? quantityScale,
      Value<String?>? unit,
      Value<int>? unitCostMinorUnits,
      Value<String>? unitCostCurrency,
      Value<int>? rowid}) {
    return ReceivingItemsTableCompanion(
      id: id ?? this.id,
      receivingId: receivingId ?? this.receivingId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
      unit: unit ?? this.unit,
      unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
      unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (receivingId.present) {
      map['receiving_id'] = Variable<String>(receivingId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityValue.present) {
      map['quantity_value'] = Variable<int>(quantityValue.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitCostMinorUnits.present) {
      map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits.value);
    }
    if (unitCostCurrency.present) {
      map['unit_cost_currency'] = Variable<String>(unitCostCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReceivingItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('receivingId: $receivingId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('unit: $unit, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchasesTableTable extends PurchasesTable
    with TableInfo<$PurchasesTableTable, PurchasesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchasesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchasedAtMeta =
      const VerificationMeta('purchasedAt');
  @override
  late final GeneratedColumn<DateTime> purchasedAt = GeneratedColumn<DateTime>(
      'purchased_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _supplierIdMeta =
      const VerificationMeta('supplierId');
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
      'supplier_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<String> referenceNumber = GeneratedColumn<String>(
      'reference_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchasedAt, supplierId, referenceNumber, isSynced, syncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchases_table';
  @override
  VerificationContext validateIntegrity(Insertable<PurchasesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchased_at')) {
      context.handle(
          _purchasedAtMeta,
          purchasedAt.isAcceptableOrUnknown(
              data['purchased_at']!, _purchasedAtMeta));
    } else if (isInserting) {
      context.missing(_purchasedAtMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
          _supplierIdMeta,
          supplierId.isAcceptableOrUnknown(
              data['supplier_id']!, _supplierIdMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchasesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchasesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      purchasedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}purchased_at'])!,
      supplierId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_id']),
      referenceNumber: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}reference_number']),
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $PurchasesTableTable createAlias(String alias) {
    return $PurchasesTableTable(attachedDatabase, alias);
  }
}

class PurchasesTableData extends DataClass
    implements Insertable<PurchasesTableData> {
  final String id;
  final DateTime purchasedAt;
  final String? supplierId;
  final String? referenceNumber;
  final bool isSynced;
  final DateTime? syncedAt;
  const PurchasesTableData(
      {required this.id,
      required this.purchasedAt,
      this.supplierId,
      this.referenceNumber,
      required this.isSynced,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchased_at'] = Variable<DateTime>(purchasedAt);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || referenceNumber != null) {
      map['reference_number'] = Variable<String>(referenceNumber);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  PurchasesTableCompanion toCompanion(bool nullToAbsent) {
    return PurchasesTableCompanion(
      id: Value(id),
      purchasedAt: Value(purchasedAt),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      referenceNumber: referenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNumber),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory PurchasesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchasesTableData(
      id: serializer.fromJson<String>(json['id']),
      purchasedAt: serializer.fromJson<DateTime>(json['purchasedAt']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      referenceNumber: serializer.fromJson<String?>(json['referenceNumber']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchasedAt': serializer.toJson<DateTime>(purchasedAt),
      'supplierId': serializer.toJson<String?>(supplierId),
      'referenceNumber': serializer.toJson<String?>(referenceNumber),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  PurchasesTableData copyWith(
          {String? id,
          DateTime? purchasedAt,
          Value<String?> supplierId = const Value.absent(),
          Value<String?> referenceNumber = const Value.absent(),
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      PurchasesTableData(
        id: id ?? this.id,
        purchasedAt: purchasedAt ?? this.purchasedAt,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        referenceNumber: referenceNumber.present
            ? referenceNumber.value
            : this.referenceNumber,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  PurchasesTableData copyWithCompanion(PurchasesTableCompanion data) {
    return PurchasesTableData(
      id: data.id.present ? data.id.value : this.id,
      purchasedAt:
          data.purchasedAt.present ? data.purchasedAt.value : this.purchasedAt,
      supplierId:
          data.supplierId.present ? data.supplierId.value : this.supplierId,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesTableData(')
          ..write('id: $id, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('supplierId: $supplierId, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, purchasedAt, supplierId, referenceNumber, isSynced, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchasesTableData &&
          other.id == this.id &&
          other.purchasedAt == this.purchasedAt &&
          other.supplierId == this.supplierId &&
          other.referenceNumber == this.referenceNumber &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class PurchasesTableCompanion extends UpdateCompanion<PurchasesTableData> {
  final Value<String> id;
  final Value<DateTime> purchasedAt;
  final Value<String?> supplierId;
  final Value<String?> referenceNumber;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const PurchasesTableCompanion({
    this.id = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesTableCompanion.insert({
    required String id,
    required DateTime purchasedAt,
    this.supplierId = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchasedAt = Value(purchasedAt);
  static Insertable<PurchasesTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? purchasedAt,
    Expression<String>? supplierId,
    Expression<String>? referenceNumber,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (supplierId != null) 'supplier_id': supplierId,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesTableCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? purchasedAt,
      Value<String?>? supplierId,
      Value<String?>? referenceNumber,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return PurchasesTableCompanion(
      id: id ?? this.id,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      supplierId: supplierId ?? this.supplierId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchasedAt.present) {
      map['purchased_at'] = Variable<DateTime>(purchasedAt.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<String>(referenceNumber.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesTableCompanion(')
          ..write('id: $id, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('supplierId: $supplierId, ')
          ..write('referenceNumber: $referenceNumber, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseItemsTableTable extends PurchaseItemsTable
    with TableInfo<$PurchaseItemsTableTable, PurchaseItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _purchaseIdMeta =
      const VerificationMeta('purchaseId');
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
      'purchase_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityValueMeta =
      const VerificationMeta('quantityValue');
  @override
  late final GeneratedColumn<int> quantityValue = GeneratedColumn<int>(
      'quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitCostMinorUnitsMeta =
      const VerificationMeta('unitCostMinorUnits');
  @override
  late final GeneratedColumn<int> unitCostMinorUnits = GeneratedColumn<int>(
      'unit_cost_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostCurrencyMeta =
      const VerificationMeta('unitCostCurrency');
  @override
  late final GeneratedColumn<String> unitCostCurrency = GeneratedColumn<String>(
      'unit_cost_currency', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('IDR'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        purchaseId,
        productId,
        quantityValue,
        quantityScale,
        unit,
        unitCostMinorUnits,
        unitCostCurrency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_items_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<PurchaseItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
          _purchaseIdMeta,
          purchaseId.isAcceptableOrUnknown(
              data['purchase_id']!, _purchaseIdMeta));
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_value')) {
      context.handle(
          _quantityValueMeta,
          quantityValue.isAcceptableOrUnknown(
              data['quantity_value']!, _quantityValueMeta));
    } else if (isInserting) {
      context.missing(_quantityValueMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('unit_cost_minor_units')) {
      context.handle(
          _unitCostMinorUnitsMeta,
          unitCostMinorUnits.isAcceptableOrUnknown(
              data['unit_cost_minor_units']!, _unitCostMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_unitCostMinorUnitsMeta);
    }
    if (data.containsKey('unit_cost_currency')) {
      context.handle(
          _unitCostCurrencyMeta,
          unitCostCurrency.isAcceptableOrUnknown(
              data['unit_cost_currency']!, _unitCostCurrencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PurchaseItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      purchaseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}purchase_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_value'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      unitCostMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_cost_minor_units'])!,
      unitCostCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_cost_currency'])!,
    );
  }

  @override
  $PurchaseItemsTableTable createAlias(String alias) {
    return $PurchaseItemsTableTable(attachedDatabase, alias);
  }
}

class PurchaseItemsTableData extends DataClass
    implements Insertable<PurchaseItemsTableData> {
  final String id;
  final String purchaseId;
  final String productId;
  final int quantityValue;
  final int quantityScale;
  final String? unit;
  final int unitCostMinorUnits;
  final String unitCostCurrency;
  const PurchaseItemsTableData(
      {required this.id,
      required this.purchaseId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
      this.unit,
      required this.unitCostMinorUnits,
      required this.unitCostCurrency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_value'] = Variable<int>(quantityValue);
    map['quantity_scale'] = Variable<int>(quantityScale);
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits);
    map['unit_cost_currency'] = Variable<String>(unitCostCurrency);
    return map;
  }

  PurchaseItemsTableCompanion toCompanion(bool nullToAbsent) {
    return PurchaseItemsTableCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      productId: Value(productId),
      quantityValue: Value(quantityValue),
      quantityScale: Value(quantityScale),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      unitCostMinorUnits: Value(unitCostMinorUnits),
      unitCostCurrency: Value(unitCostCurrency),
    );
  }

  factory PurchaseItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityValue: serializer.fromJson<int>(json['quantityValue']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      unit: serializer.fromJson<String?>(json['unit']),
      unitCostMinorUnits: serializer.fromJson<int>(json['unitCostMinorUnits']),
      unitCostCurrency: serializer.fromJson<String>(json['unitCostCurrency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'productId': serializer.toJson<String>(productId),
      'quantityValue': serializer.toJson<int>(quantityValue),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'unit': serializer.toJson<String?>(unit),
      'unitCostMinorUnits': serializer.toJson<int>(unitCostMinorUnits),
      'unitCostCurrency': serializer.toJson<String>(unitCostCurrency),
    };
  }

  PurchaseItemsTableData copyWith(
          {String? id,
          String? purchaseId,
          String? productId,
          int? quantityValue,
          int? quantityScale,
          Value<String?> unit = const Value.absent(),
          int? unitCostMinorUnits,
          String? unitCostCurrency}) =>
      PurchaseItemsTableData(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
        unit: unit.present ? unit.value : this.unit,
        unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
        unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
      );
  PurchaseItemsTableData copyWithCompanion(PurchaseItemsTableCompanion data) {
    return PurchaseItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityValue: data.quantityValue.present
          ? data.quantityValue.value
          : this.quantityValue,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitCostMinorUnits: data.unitCostMinorUnits.present
          ? data.unitCostMinorUnits.value
          : this.unitCostMinorUnits,
      unitCostCurrency: data.unitCostCurrency.present
          ? data.unitCostCurrency.value
          : this.unitCostCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsTableData(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('unit: $unit, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseId, productId, quantityValue,
      quantityScale, unit, unitCostMinorUnits, unitCostCurrency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItemsTableData &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
          other.unit == this.unit &&
          other.unitCostMinorUnits == this.unitCostMinorUnits &&
          other.unitCostCurrency == this.unitCostCurrency);
}

class PurchaseItemsTableCompanion
    extends UpdateCompanion<PurchaseItemsTableData> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<String> productId;
  final Value<int> quantityValue;
  final Value<int> quantityScale;
  final Value<String?> unit;
  final Value<int> unitCostMinorUnits;
  final Value<String> unitCostCurrency;
  final Value<int> rowid;
  const PurchaseItemsTableCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitCostMinorUnits = const Value.absent(),
    this.unitCostCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseItemsTableCompanion.insert({
    required String id,
    required String purchaseId,
    required String productId,
    required int quantityValue,
    this.quantityScale = const Value.absent(),
    this.unit = const Value.absent(),
    required int unitCostMinorUnits,
    this.unitCostCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchaseId = Value(purchaseId),
        productId = Value(productId),
        quantityValue = Value(quantityValue),
        unitCostMinorUnits = Value(unitCostMinorUnits);
  static Insertable<PurchaseItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<String>? productId,
    Expression<int>? quantityValue,
    Expression<int>? quantityScale,
    Expression<String>? unit,
    Expression<int>? unitCostMinorUnits,
    Expression<String>? unitCostCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (productId != null) 'product_id': productId,
      if (quantityValue != null) 'quantity_value': quantityValue,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (unit != null) 'unit': unit,
      if (unitCostMinorUnits != null)
        'unit_cost_minor_units': unitCostMinorUnits,
      if (unitCostCurrency != null) 'unit_cost_currency': unitCostCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? purchaseId,
      Value<String>? productId,
      Value<int>? quantityValue,
      Value<int>? quantityScale,
      Value<String?>? unit,
      Value<int>? unitCostMinorUnits,
      Value<String>? unitCostCurrency,
      Value<int>? rowid}) {
    return PurchaseItemsTableCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
      unit: unit ?? this.unit,
      unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
      unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityValue.present) {
      map['quantity_value'] = Variable<int>(quantityValue.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitCostMinorUnits.present) {
      map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits.value);
    }
    if (unitCostCurrency.present) {
      map['unit_cost_currency'] = Variable<String>(unitCostCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('unit: $unit, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTableTable extends SalesTable
    with TableInfo<$SalesTableTable, SalesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _invoiceNumberMeta =
      const VerificationMeta('invoiceNumber');
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
      'invoice_number', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _discountMinorUnitsMeta =
      const VerificationMeta('discountMinorUnits');
  @override
  late final GeneratedColumn<int> discountMinorUnits = GeneratedColumn<int>(
      'discount_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _taxMinorUnitsMeta =
      const VerificationMeta('taxMinorUnits');
  @override
  late final GeneratedColumn<int> taxMinorUnits = GeneratedColumn<int>(
      'tax_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _soldAtMeta = const VerificationMeta('soldAt');
  @override
  late final GeneratedColumn<DateTime> soldAt = GeneratedColumn<DateTime>(
      'sold_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        invoiceNumber,
        discountMinorUnits,
        taxMinorUnits,
        createdAt,
        soldAt,
        isSynced,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales_table';
  @override
  VerificationContext validateIntegrity(Insertable<SalesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
          _invoiceNumberMeta,
          invoiceNumber.isAcceptableOrUnknown(
              data['invoice_number']!, _invoiceNumberMeta));
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('discount_minor_units')) {
      context.handle(
          _discountMinorUnitsMeta,
          discountMinorUnits.isAcceptableOrUnknown(
              data['discount_minor_units']!, _discountMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_discountMinorUnitsMeta);
    }
    if (data.containsKey('tax_minor_units')) {
      context.handle(
          _taxMinorUnitsMeta,
          taxMinorUnits.isAcceptableOrUnknown(
              data['tax_minor_units']!, _taxMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_taxMinorUnitsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sold_at')) {
      context.handle(_soldAtMeta,
          soldAt.isAcceptableOrUnknown(data['sold_at']!, _soldAtMeta));
    } else if (isInserting) {
      context.missing(_soldAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      invoiceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}invoice_number'])!,
      discountMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}discount_minor_units'])!,
      taxMinorUnits: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tax_minor_units'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      soldAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}sold_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $SalesTableTable createAlias(String alias) {
    return $SalesTableTable(attachedDatabase, alias);
  }
}

class SalesTableData extends DataClass implements Insertable<SalesTableData> {
  final String id;
  final String invoiceNumber;
  final int discountMinorUnits;
  final int taxMinorUnits;
  final DateTime createdAt;
  final DateTime soldAt;
  final bool isSynced;
  final DateTime? syncedAt;
  const SalesTableData(
      {required this.id,
      required this.invoiceNumber,
      required this.discountMinorUnits,
      required this.taxMinorUnits,
      required this.createdAt,
      required this.soldAt,
      required this.isSynced,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['discount_minor_units'] = Variable<int>(discountMinorUnits);
    map['tax_minor_units'] = Variable<int>(taxMinorUnits);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sold_at'] = Variable<DateTime>(soldAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  SalesTableCompanion toCompanion(bool nullToAbsent) {
    return SalesTableCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      discountMinorUnits: Value(discountMinorUnits),
      taxMinorUnits: Value(taxMinorUnits),
      createdAt: Value(createdAt),
      soldAt: Value(soldAt),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory SalesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalesTableData(
      id: serializer.fromJson<String>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      discountMinorUnits: serializer.fromJson<int>(json['discountMinorUnits']),
      taxMinorUnits: serializer.fromJson<int>(json['taxMinorUnits']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      soldAt: serializer.fromJson<DateTime>(json['soldAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'discountMinorUnits': serializer.toJson<int>(discountMinorUnits),
      'taxMinorUnits': serializer.toJson<int>(taxMinorUnits),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'soldAt': serializer.toJson<DateTime>(soldAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  SalesTableData copyWith(
          {String? id,
          String? invoiceNumber,
          int? discountMinorUnits,
          int? taxMinorUnits,
          DateTime? createdAt,
          DateTime? soldAt,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      SalesTableData(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        discountMinorUnits: discountMinorUnits ?? this.discountMinorUnits,
        taxMinorUnits: taxMinorUnits ?? this.taxMinorUnits,
        createdAt: createdAt ?? this.createdAt,
        soldAt: soldAt ?? this.soldAt,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  SalesTableData copyWithCompanion(SalesTableCompanion data) {
    return SalesTableData(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      discountMinorUnits: data.discountMinorUnits.present
          ? data.discountMinorUnits.value
          : this.discountMinorUnits,
      taxMinorUnits: data.taxMinorUnits.present
          ? data.taxMinorUnits.value
          : this.taxMinorUnits,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      soldAt: data.soldAt.present ? data.soldAt.value : this.soldAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalesTableData(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('discountMinorUnits: $discountMinorUnits, ')
          ..write('taxMinorUnits: $taxMinorUnits, ')
          ..write('createdAt: $createdAt, ')
          ..write('soldAt: $soldAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, invoiceNumber, discountMinorUnits,
      taxMinorUnits, createdAt, soldAt, isSynced, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesTableData &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.discountMinorUnits == this.discountMinorUnits &&
          other.taxMinorUnits == this.taxMinorUnits &&
          other.createdAt == this.createdAt &&
          other.soldAt == this.soldAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class SalesTableCompanion extends UpdateCompanion<SalesTableData> {
  final Value<String> id;
  final Value<String> invoiceNumber;
  final Value<int> discountMinorUnits;
  final Value<int> taxMinorUnits;
  final Value<DateTime> createdAt;
  final Value<DateTime> soldAt;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const SalesTableCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.discountMinorUnits = const Value.absent(),
    this.taxMinorUnits = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesTableCompanion.insert({
    required String id,
    required String invoiceNumber,
    required int discountMinorUnits,
    required int taxMinorUnits,
    required DateTime createdAt,
    required DateTime soldAt,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        invoiceNumber = Value(invoiceNumber),
        discountMinorUnits = Value(discountMinorUnits),
        taxMinorUnits = Value(taxMinorUnits),
        createdAt = Value(createdAt),
        soldAt = Value(soldAt);
  static Insertable<SalesTableData> custom({
    Expression<String>? id,
    Expression<String>? invoiceNumber,
    Expression<int>? discountMinorUnits,
    Expression<int>? taxMinorUnits,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? soldAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (discountMinorUnits != null)
        'discount_minor_units': discountMinorUnits,
      if (taxMinorUnits != null) 'tax_minor_units': taxMinorUnits,
      if (createdAt != null) 'created_at': createdAt,
      if (soldAt != null) 'sold_at': soldAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? invoiceNumber,
      Value<int>? discountMinorUnits,
      Value<int>? taxMinorUnits,
      Value<DateTime>? createdAt,
      Value<DateTime>? soldAt,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return SalesTableCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      discountMinorUnits: discountMinorUnits ?? this.discountMinorUnits,
      taxMinorUnits: taxMinorUnits ?? this.taxMinorUnits,
      createdAt: createdAt ?? this.createdAt,
      soldAt: soldAt ?? this.soldAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (discountMinorUnits.present) {
      map['discount_minor_units'] = Variable<int>(discountMinorUnits.value);
    }
    if (taxMinorUnits.present) {
      map['tax_minor_units'] = Variable<int>(taxMinorUnits.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (soldAt.present) {
      map['sold_at'] = Variable<DateTime>(soldAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesTableCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('discountMinorUnits: $discountMinorUnits, ')
          ..write('taxMinorUnits: $taxMinorUnits, ')
          ..write('createdAt: $createdAt, ')
          ..write('soldAt: $soldAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTableTable extends SaleItemsTable
    with TableInfo<$SaleItemsTableTable, SaleItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityValueMeta =
      const VerificationMeta('quantityValue');
  @override
  late final GeneratedColumn<int> quantityValue = GeneratedColumn<int>(
      'quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _unitPriceMinorUnitsMeta =
      const VerificationMeta('unitPriceMinorUnits');
  @override
  late final GeneratedColumn<int> unitPriceMinorUnits = GeneratedColumn<int>(
      'unit_price_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitCostMinorUnitsMeta =
      const VerificationMeta('unitCostMinorUnits');
  @override
  late final GeneratedColumn<int> unitCostMinorUnits = GeneratedColumn<int>(
      'unit_cost_minor_units', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _unitCostCurrencyMeta =
      const VerificationMeta('unitCostCurrency');
  @override
  late final GeneratedColumn<String> unitCostCurrency = GeneratedColumn<String>(
      'unit_cost_currency', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saleId,
        productId,
        quantityValue,
        quantityScale,
        productName,
        unit,
        unitPriceMinorUnits,
        unitCostMinorUnits,
        unitCostCurrency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items_table';
  @override
  VerificationContext validateIntegrity(Insertable<SaleItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_value')) {
      context.handle(
          _quantityValueMeta,
          quantityValue.isAcceptableOrUnknown(
              data['quantity_value']!, _quantityValueMeta));
    } else if (isInserting) {
      context.missing(_quantityValueMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    }
    if (data.containsKey('unit_price_minor_units')) {
      context.handle(
          _unitPriceMinorUnitsMeta,
          unitPriceMinorUnits.isAcceptableOrUnknown(
              data['unit_price_minor_units']!, _unitPriceMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMinorUnitsMeta);
    }
    if (data.containsKey('unit_cost_minor_units')) {
      context.handle(
          _unitCostMinorUnitsMeta,
          unitCostMinorUnits.isAcceptableOrUnknown(
              data['unit_cost_minor_units']!, _unitCostMinorUnitsMeta));
    }
    if (data.containsKey('unit_cost_currency')) {
      context.handle(
          _unitCostCurrencyMeta,
          unitCostCurrency.isAcceptableOrUnknown(
              data['unit_cost_currency']!, _unitCostCurrencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_value'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name']),
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit']),
      unitPriceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_price_minor_units'])!,
      unitCostMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_cost_minor_units']),
      unitCostCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_cost_currency']),
    );
  }

  @override
  $SaleItemsTableTable createAlias(String alias) {
    return $SaleItemsTableTable(attachedDatabase, alias);
  }
}

class SaleItemsTableData extends DataClass
    implements Insertable<SaleItemsTableData> {
  final String id;
  final String saleId;
  final String productId;
  final int quantityValue;
  final int quantityScale;
  final String? productName;
  final String? unit;
  final int unitPriceMinorUnits;
  final int? unitCostMinorUnits;
  final String? unitCostCurrency;
  const SaleItemsTableData(
      {required this.id,
      required this.saleId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
      this.productName,
      this.unit,
      required this.unitPriceMinorUnits,
      this.unitCostMinorUnits,
      this.unitCostCurrency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_value'] = Variable<int>(quantityValue);
    map['quantity_scale'] = Variable<int>(quantityScale);
    if (!nullToAbsent || productName != null) {
      map['product_name'] = Variable<String>(productName);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['unit_price_minor_units'] = Variable<int>(unitPriceMinorUnits);
    if (!nullToAbsent || unitCostMinorUnits != null) {
      map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits);
    }
    if (!nullToAbsent || unitCostCurrency != null) {
      map['unit_cost_currency'] = Variable<String>(unitCostCurrency);
    }
    return map;
  }

  SaleItemsTableCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsTableCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      quantityValue: Value(quantityValue),
      quantityScale: Value(quantityScale),
      productName: productName == null && nullToAbsent
          ? const Value.absent()
          : Value(productName),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      unitPriceMinorUnits: Value(unitPriceMinorUnits),
      unitCostMinorUnits: unitCostMinorUnits == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostMinorUnits),
      unitCostCurrency: unitCostCurrency == null && nullToAbsent
          ? const Value.absent()
          : Value(unitCostCurrency),
    );
  }

  factory SaleItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityValue: serializer.fromJson<int>(json['quantityValue']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      productName: serializer.fromJson<String?>(json['productName']),
      unit: serializer.fromJson<String?>(json['unit']),
      unitPriceMinorUnits:
          serializer.fromJson<int>(json['unitPriceMinorUnits']),
      unitCostMinorUnits: serializer.fromJson<int?>(json['unitCostMinorUnits']),
      unitCostCurrency: serializer.fromJson<String?>(json['unitCostCurrency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'quantityValue': serializer.toJson<int>(quantityValue),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'productName': serializer.toJson<String?>(productName),
      'unit': serializer.toJson<String?>(unit),
      'unitPriceMinorUnits': serializer.toJson<int>(unitPriceMinorUnits),
      'unitCostMinorUnits': serializer.toJson<int?>(unitCostMinorUnits),
      'unitCostCurrency': serializer.toJson<String?>(unitCostCurrency),
    };
  }

  SaleItemsTableData copyWith(
          {String? id,
          String? saleId,
          String? productId,
          int? quantityValue,
          int? quantityScale,
          Value<String?> productName = const Value.absent(),
          Value<String?> unit = const Value.absent(),
          int? unitPriceMinorUnits,
          Value<int?> unitCostMinorUnits = const Value.absent(),
          Value<String?> unitCostCurrency = const Value.absent()}) =>
      SaleItemsTableData(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
        productName: productName.present ? productName.value : this.productName,
        unit: unit.present ? unit.value : this.unit,
        unitPriceMinorUnits: unitPriceMinorUnits ?? this.unitPriceMinorUnits,
        unitCostMinorUnits: unitCostMinorUnits.present
            ? unitCostMinorUnits.value
            : this.unitCostMinorUnits,
        unitCostCurrency: unitCostCurrency.present
            ? unitCostCurrency.value
            : this.unitCostCurrency,
      );
  SaleItemsTableData copyWithCompanion(SaleItemsTableCompanion data) {
    return SaleItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityValue: data.quantityValue.present
          ? data.quantityValue.value
          : this.quantityValue,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPriceMinorUnits: data.unitPriceMinorUnits.present
          ? data.unitPriceMinorUnits.value
          : this.unitPriceMinorUnits,
      unitCostMinorUnits: data.unitCostMinorUnits.present
          ? data.unitCostMinorUnits.value
          : this.unitCostMinorUnits,
      unitCostCurrency: data.unitCostCurrency.present
          ? data.unitCostCurrency.value
          : this.unitCostCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsTableData(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('productName: $productName, ')
          ..write('unit: $unit, ')
          ..write('unitPriceMinorUnits: $unitPriceMinorUnits, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      saleId,
      productId,
      quantityValue,
      quantityScale,
      productName,
      unit,
      unitPriceMinorUnits,
      unitCostMinorUnits,
      unitCostCurrency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItemsTableData &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
          other.productName == this.productName &&
          other.unit == this.unit &&
          other.unitPriceMinorUnits == this.unitPriceMinorUnits &&
          other.unitCostMinorUnits == this.unitCostMinorUnits &&
          other.unitCostCurrency == this.unitCostCurrency);
}

class SaleItemsTableCompanion extends UpdateCompanion<SaleItemsTableData> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<int> quantityValue;
  final Value<int> quantityScale;
  final Value<String?> productName;
  final Value<String?> unit;
  final Value<int> unitPriceMinorUnits;
  final Value<int?> unitCostMinorUnits;
  final Value<String?> unitCostCurrency;
  final Value<int> rowid;
  const SaleItemsTableCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.productName = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPriceMinorUnits = const Value.absent(),
    this.unitCostMinorUnits = const Value.absent(),
    this.unitCostCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleItemsTableCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required int quantityValue,
    this.quantityScale = const Value.absent(),
    this.productName = const Value.absent(),
    this.unit = const Value.absent(),
    required int unitPriceMinorUnits,
    this.unitCostMinorUnits = const Value.absent(),
    this.unitCostCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        productId = Value(productId),
        quantityValue = Value(quantityValue),
        unitPriceMinorUnits = Value(unitPriceMinorUnits);
  static Insertable<SaleItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<int>? quantityValue,
    Expression<int>? quantityScale,
    Expression<String>? productName,
    Expression<String>? unit,
    Expression<int>? unitPriceMinorUnits,
    Expression<int>? unitCostMinorUnits,
    Expression<String>? unitCostCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (quantityValue != null) 'quantity_value': quantityValue,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (productName != null) 'product_name': productName,
      if (unit != null) 'unit': unit,
      if (unitPriceMinorUnits != null)
        'unit_price_minor_units': unitPriceMinorUnits,
      if (unitCostMinorUnits != null)
        'unit_cost_minor_units': unitCostMinorUnits,
      if (unitCostCurrency != null) 'unit_cost_currency': unitCostCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<String>? productId,
      Value<int>? quantityValue,
      Value<int>? quantityScale,
      Value<String?>? productName,
      Value<String?>? unit,
      Value<int>? unitPriceMinorUnits,
      Value<int?>? unitCostMinorUnits,
      Value<String?>? unitCostCurrency,
      Value<int>? rowid}) {
    return SaleItemsTableCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
      productName: productName ?? this.productName,
      unit: unit ?? this.unit,
      unitPriceMinorUnits: unitPriceMinorUnits ?? this.unitPriceMinorUnits,
      unitCostMinorUnits: unitCostMinorUnits ?? this.unitCostMinorUnits,
      unitCostCurrency: unitCostCurrency ?? this.unitCostCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityValue.present) {
      map['quantity_value'] = Variable<int>(quantityValue.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPriceMinorUnits.present) {
      map['unit_price_minor_units'] = Variable<int>(unitPriceMinorUnits.value);
    }
    if (unitCostMinorUnits.present) {
      map['unit_cost_minor_units'] = Variable<int>(unitCostMinorUnits.value);
    }
    if (unitCostCurrency.present) {
      map['unit_cost_currency'] = Variable<String>(unitCostCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('productName: $productName, ')
          ..write('unit: $unit, ')
          ..write('unitPriceMinorUnits: $unitPriceMinorUnits, ')
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTableTable extends StockMovementsTable
    with TableInfo<$StockMovementsTableTable, StockMovementsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityValueMeta =
      const VerificationMeta('quantityValue');
  @override
  late final GeneratedColumn<int> quantityValue = GeneratedColumn<int>(
      'quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _occurredAtMeta =
      const VerificationMeta('occurredAt');
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
      'occurred_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        productId,
        quantityValue,
        quantityScale,
        type,
        referenceId,
        occurredAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<StockMovementsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_value')) {
      context.handle(
          _quantityValueMeta,
          quantityValue.isAcceptableOrUnknown(
              data['quantity_value']!, _quantityValueMeta));
    } else if (isInserting) {
      context.missing(_quantityValueMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
          _occurredAtMeta,
          occurredAt.isAcceptableOrUnknown(
              data['occurred_at']!, _occurredAtMeta));
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovementsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovementsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_value'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
      occurredAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}occurred_at'])!,
    );
  }

  @override
  $StockMovementsTableTable createAlias(String alias) {
    return $StockMovementsTableTable(attachedDatabase, alias);
  }
}

class StockMovementsTableData extends DataClass
    implements Insertable<StockMovementsTableData> {
  final String id;
  final String productId;
  final int quantityValue;
  final int quantityScale;
  final String type;
  final String? referenceId;
  final DateTime occurredAt;
  const StockMovementsTableData(
      {required this.id,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
      required this.type,
      this.referenceId,
      required this.occurredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['quantity_value'] = Variable<int>(quantityValue);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    return map;
  }

  StockMovementsTableCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      quantityValue: Value(quantityValue),
      quantityScale: Value(quantityScale),
      type: Value(type),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      occurredAt: Value(occurredAt),
    );
  }

  factory StockMovementsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovementsTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityValue: serializer.fromJson<int>(json['quantityValue']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      type: serializer.fromJson<String>(json['type']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      occurredAt: serializer.fromJson<DateTime>(json['occurredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'quantityValue': serializer.toJson<int>(quantityValue),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'type': serializer.toJson<String>(type),
      'referenceId': serializer.toJson<String?>(referenceId),
      'occurredAt': serializer.toJson<DateTime>(occurredAt),
    };
  }

  StockMovementsTableData copyWith(
          {String? id,
          String? productId,
          int? quantityValue,
          int? quantityScale,
          String? type,
          Value<String?> referenceId = const Value.absent(),
          DateTime? occurredAt}) =>
      StockMovementsTableData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
        type: type ?? this.type,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        occurredAt: occurredAt ?? this.occurredAt,
      );
  StockMovementsTableData copyWithCompanion(StockMovementsTableCompanion data) {
    return StockMovementsTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityValue: data.quantityValue.present
          ? data.quantityValue.value
          : this.quantityValue,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      type: data.type.present ? data.type.value : this.type,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      occurredAt:
          data.occurredAt.present ? data.occurredAt.value : this.occurredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('occurredAt: $occurredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, quantityValue, quantityScale,
      type, referenceId, occurredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovementsTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
          other.type == this.type &&
          other.referenceId == this.referenceId &&
          other.occurredAt == this.occurredAt);
}

class StockMovementsTableCompanion
    extends UpdateCompanion<StockMovementsTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<int> quantityValue;
  final Value<int> quantityScale;
  final Value<String> type;
  final Value<String?> referenceId;
  final Value<DateTime> occurredAt;
  final Value<int> rowid;
  const StockMovementsTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.type = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsTableCompanion.insert({
    required String id,
    required String productId,
    required int quantityValue,
    this.quantityScale = const Value.absent(),
    required String type,
    this.referenceId = const Value.absent(),
    required DateTime occurredAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        quantityValue = Value(quantityValue),
        type = Value(type),
        occurredAt = Value(occurredAt);
  static Insertable<StockMovementsTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<int>? quantityValue,
    Expression<int>? quantityScale,
    Expression<String>? type,
    Expression<String>? referenceId,
    Expression<DateTime>? occurredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (quantityValue != null) 'quantity_value': quantityValue,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (type != null) 'type': type,
      if (referenceId != null) 'reference_id': referenceId,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<int>? quantityValue,
      Value<int>? quantityScale,
      Value<String>? type,
      Value<String?>? referenceId,
      Value<DateTime>? occurredAt,
      Value<int>? rowid}) {
    return StockMovementsTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      occurredAt: occurredAt ?? this.occurredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityValue.present) {
      map['quantity_value'] = Variable<int>(quantityValue.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('type: $type, ')
          ..write('referenceId: $referenceId, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, OrdersTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
      'sale_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _paymentMethodMeta =
      const VerificationMeta('paymentMethod');
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
      'payment_method', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isSyncedMeta =
      const VerificationMeta('isSynced');
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
      'is_synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _syncedAtMeta =
      const VerificationMeta('syncedAt');
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
      'synced_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        saleId,
        source,
        status,
        paymentMethod,
        createdAt,
        isSynced,
        syncedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(Insertable<OrdersTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(_saleIdMeta,
          saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta));
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
          _paymentMethodMeta,
          paymentMethod.isAcceptableOrUnknown(
              data['payment_method']!, _paymentMethodMeta));
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(_isSyncedMeta,
          isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta));
    }
    if (data.containsKey('synced_at')) {
      context.handle(_syncedAtMeta,
          syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      saleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sale_id'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      paymentMethod: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payment_method'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      isSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_synced'])!,
      syncedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}synced_at']),
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class OrdersTableData extends DataClass implements Insertable<OrdersTableData> {
  final String id;
  final String saleId;
  final String source;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;
  final bool isSynced;
  final DateTime? syncedAt;
  const OrdersTableData(
      {required this.id,
      required this.saleId,
      required this.source,
      required this.status,
      required this.paymentMethod,
      required this.createdAt,
      required this.isSynced,
      this.syncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['source'] = Variable<String>(source);
    map['status'] = Variable<String>(status);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    if (!nullToAbsent || syncedAt != null) {
      map['synced_at'] = Variable<DateTime>(syncedAt);
    }
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      saleId: Value(saleId),
      source: Value(source),
      status: Value(status),
      paymentMethod: Value(paymentMethod),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      syncedAt: syncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(syncedAt),
    );
  }

  factory OrdersTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersTableData(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      source: serializer.fromJson<String>(json['source']),
      status: serializer.fromJson<String>(json['status']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      syncedAt: serializer.fromJson<DateTime?>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'source': serializer.toJson<String>(source),
      'status': serializer.toJson<String>(status),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'syncedAt': serializer.toJson<DateTime?>(syncedAt),
    };
  }

  OrdersTableData copyWith(
          {String? id,
          String? saleId,
          String? source,
          String? status,
          String? paymentMethod,
          DateTime? createdAt,
          bool? isSynced,
          Value<DateTime?> syncedAt = const Value.absent()}) =>
      OrdersTableData(
        id: id ?? this.id,
        saleId: saleId ?? this.saleId,
        source: source ?? this.source,
        status: status ?? this.status,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
        syncedAt: syncedAt.present ? syncedAt.value : this.syncedAt,
      );
  OrdersTableData copyWithCompanion(OrdersTableCompanion data) {
    return OrdersTableData(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableData(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, saleId, source, status, paymentMethod, createdAt, isSynced, syncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersTableData &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.source == this.source &&
          other.status == this.status &&
          other.paymentMethod == this.paymentMethod &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.syncedAt == this.syncedAt);
}

class OrdersTableCompanion extends UpdateCompanion<OrdersTableData> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> source;
  final Value<String> status;
  final Value<String> paymentMethod;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<DateTime?> syncedAt;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    required String id,
    required String saleId,
    required String source,
    required String status,
    required String paymentMethod,
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.syncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        saleId = Value(saleId),
        source = Value(source),
        status = Value(status),
        paymentMethod = Value(paymentMethod),
        createdAt = Value(createdAt);
  static Insertable<OrdersTableData> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? source,
    Expression<String>? status,
    Expression<String>? paymentMethod,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<DateTime>? syncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (syncedAt != null) 'synced_at': syncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? saleId,
      Value<String>? source,
      Value<String>? status,
      Value<String>? paymentMethod,
      Value<DateTime>? createdAt,
      Value<bool>? isSynced,
      Value<DateTime?>? syncedAt,
      Value<int>? rowid}) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      source: source ?? this.source,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('syncedAt: $syncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTableTable extends OrderItemsTable
    with TableInfo<$OrderItemsTableTable, OrderItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityValueMeta =
      const VerificationMeta('quantityValue');
  @override
  late final GeneratedColumn<int> quantityValue = GeneratedColumn<int>(
      'quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _productNameMeta =
      const VerificationMeta('productName');
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
      'product_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
      'unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceMinorUnitsMeta =
      const VerificationMeta('unitPriceMinorUnits');
  @override
  late final GeneratedColumn<int> unitPriceMinorUnits = GeneratedColumn<int>(
      'unit_price_minor_units', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _unitPriceCurrencyMeta =
      const VerificationMeta('unitPriceCurrency');
  @override
  late final GeneratedColumn<String> unitPriceCurrency =
      GeneratedColumn<String>('unit_price_currency', aliasedName, false,
          type: DriftSqlType.string,
          requiredDuringInsert: false,
          defaultValue: const Constant('IDR'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        productId,
        quantityValue,
        quantityScale,
        productName,
        unit,
        unitPriceMinorUnits,
        unitPriceCurrency
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<OrderItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_value')) {
      context.handle(
          _quantityValueMeta,
          quantityValue.isAcceptableOrUnknown(
              data['quantity_value']!, _quantityValueMeta));
    } else if (isInserting) {
      context.missing(_quantityValueMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    if (data.containsKey('product_name')) {
      context.handle(
          _productNameMeta,
          productName.isAcceptableOrUnknown(
              data['product_name']!, _productNameMeta));
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
          _unitMeta, unit.isAcceptableOrUnknown(data['unit']!, _unitMeta));
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('unit_price_minor_units')) {
      context.handle(
          _unitPriceMinorUnitsMeta,
          unitPriceMinorUnits.isAcceptableOrUnknown(
              data['unit_price_minor_units']!, _unitPriceMinorUnitsMeta));
    } else if (isInserting) {
      context.missing(_unitPriceMinorUnitsMeta);
    }
    if (data.containsKey('unit_price_currency')) {
      context.handle(
          _unitPriceCurrencyMeta,
          unitPriceCurrency.isAcceptableOrUnknown(
              data['unit_price_currency']!, _unitPriceCurrencyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_value'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
      productName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_name'])!,
      unit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}unit'])!,
      unitPriceMinorUnits: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}unit_price_minor_units'])!,
      unitPriceCurrency: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}unit_price_currency'])!,
    );
  }

  @override
  $OrderItemsTableTable createAlias(String alias) {
    return $OrderItemsTableTable(attachedDatabase, alias);
  }
}

class OrderItemsTableData extends DataClass
    implements Insertable<OrderItemsTableData> {
  final String id;
  final String orderId;
  final String productId;
  final int quantityValue;
  final int quantityScale;
  final String productName;
  final String unit;
  final int unitPriceMinorUnits;
  final String unitPriceCurrency;
  const OrderItemsTableData(
      {required this.id,
      required this.orderId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
      required this.productName,
      required this.unit,
      required this.unitPriceMinorUnits,
      required this.unitPriceCurrency});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_value'] = Variable<int>(quantityValue);
    map['quantity_scale'] = Variable<int>(quantityScale);
    map['product_name'] = Variable<String>(productName);
    map['unit'] = Variable<String>(unit);
    map['unit_price_minor_units'] = Variable<int>(unitPriceMinorUnits);
    map['unit_price_currency'] = Variable<String>(unitPriceCurrency);
    return map;
  }

  OrderItemsTableCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsTableCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      quantityValue: Value(quantityValue),
      quantityScale: Value(quantityScale),
      productName: Value(productName),
      unit: Value(unit),
      unitPriceMinorUnits: Value(unitPriceMinorUnits),
      unitPriceCurrency: Value(unitPriceCurrency),
    );
  }

  factory OrderItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityValue: serializer.fromJson<int>(json['quantityValue']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
      productName: serializer.fromJson<String>(json['productName']),
      unit: serializer.fromJson<String>(json['unit']),
      unitPriceMinorUnits:
          serializer.fromJson<int>(json['unitPriceMinorUnits']),
      unitPriceCurrency: serializer.fromJson<String>(json['unitPriceCurrency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'quantityValue': serializer.toJson<int>(quantityValue),
      'quantityScale': serializer.toJson<int>(quantityScale),
      'productName': serializer.toJson<String>(productName),
      'unit': serializer.toJson<String>(unit),
      'unitPriceMinorUnits': serializer.toJson<int>(unitPriceMinorUnits),
      'unitPriceCurrency': serializer.toJson<String>(unitPriceCurrency),
    };
  }

  OrderItemsTableData copyWith(
          {String? id,
          String? orderId,
          String? productId,
          int? quantityValue,
          int? quantityScale,
          String? productName,
          String? unit,
          int? unitPriceMinorUnits,
          String? unitPriceCurrency}) =>
      OrderItemsTableData(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
        productName: productName ?? this.productName,
        unit: unit ?? this.unit,
        unitPriceMinorUnits: unitPriceMinorUnits ?? this.unitPriceMinorUnits,
        unitPriceCurrency: unitPriceCurrency ?? this.unitPriceCurrency,
      );
  OrderItemsTableData copyWithCompanion(OrderItemsTableCompanion data) {
    return OrderItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityValue: data.quantityValue.present
          ? data.quantityValue.value
          : this.quantityValue,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
      productName:
          data.productName.present ? data.productName.value : this.productName,
      unit: data.unit.present ? data.unit.value : this.unit,
      unitPriceMinorUnits: data.unitPriceMinorUnits.present
          ? data.unitPriceMinorUnits.value
          : this.unitPriceMinorUnits,
      unitPriceCurrency: data.unitPriceCurrency.present
          ? data.unitPriceCurrency.value
          : this.unitPriceCurrency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableData(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('productName: $productName, ')
          ..write('unit: $unit, ')
          ..write('unitPriceMinorUnits: $unitPriceMinorUnits, ')
          ..write('unitPriceCurrency: $unitPriceCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, productId, quantityValue,
      quantityScale, productName, unit, unitPriceMinorUnits, unitPriceCurrency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItemsTableData &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
          other.productName == this.productName &&
          other.unit == this.unit &&
          other.unitPriceMinorUnits == this.unitPriceMinorUnits &&
          other.unitPriceCurrency == this.unitPriceCurrency);
}

class OrderItemsTableCompanion extends UpdateCompanion<OrderItemsTableData> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<int> quantityValue;
  final Value<int> quantityScale;
  final Value<String> productName;
  final Value<String> unit;
  final Value<int> unitPriceMinorUnits;
  final Value<String> unitPriceCurrency;
  final Value<int> rowid;
  const OrderItemsTableCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.productName = const Value.absent(),
    this.unit = const Value.absent(),
    this.unitPriceMinorUnits = const Value.absent(),
    this.unitPriceCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderItemsTableCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required int quantityValue,
    this.quantityScale = const Value.absent(),
    required String productName,
    required String unit,
    required int unitPriceMinorUnits,
    this.unitPriceCurrency = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        orderId = Value(orderId),
        productId = Value(productId),
        quantityValue = Value(quantityValue),
        productName = Value(productName),
        unit = Value(unit),
        unitPriceMinorUnits = Value(unitPriceMinorUnits);
  static Insertable<OrderItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<int>? quantityValue,
    Expression<int>? quantityScale,
    Expression<String>? productName,
    Expression<String>? unit,
    Expression<int>? unitPriceMinorUnits,
    Expression<String>? unitPriceCurrency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (quantityValue != null) 'quantity_value': quantityValue,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (productName != null) 'product_name': productName,
      if (unit != null) 'unit': unit,
      if (unitPriceMinorUnits != null)
        'unit_price_minor_units': unitPriceMinorUnits,
      if (unitPriceCurrency != null) 'unit_price_currency': unitPriceCurrency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? orderId,
      Value<String>? productId,
      Value<int>? quantityValue,
      Value<int>? quantityScale,
      Value<String>? productName,
      Value<String>? unit,
      Value<int>? unitPriceMinorUnits,
      Value<String>? unitPriceCurrency,
      Value<int>? rowid}) {
    return OrderItemsTableCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
      productName: productName ?? this.productName,
      unit: unit ?? this.unit,
      unitPriceMinorUnits: unitPriceMinorUnits ?? this.unitPriceMinorUnits,
      unitPriceCurrency: unitPriceCurrency ?? this.unitPriceCurrency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityValue.present) {
      map['quantity_value'] = Variable<int>(quantityValue.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (unitPriceMinorUnits.present) {
      map['unit_price_minor_units'] = Variable<int>(unitPriceMinorUnits.value);
    }
    if (unitPriceCurrency.present) {
      map['unit_price_currency'] = Variable<String>(unitPriceCurrency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('productName: $productName, ')
          ..write('unit: $unit, ')
          ..write('unitPriceMinorUnits: $unitPriceMinorUnits, ')
          ..write('unitPriceCurrency: $unitPriceCurrency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTableTable extends RecipesTable
    with TableInfo<$RecipesTableTable, RecipesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _expectedOutputValueMeta =
      const VerificationMeta('expectedOutputValue');
  @override
  late final GeneratedColumn<int> expectedOutputValue = GeneratedColumn<int>(
      'expected_output_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _expectedOutputScaleMeta =
      const VerificationMeta('expectedOutputScale');
  @override
  late final GeneratedColumn<int> expectedOutputScale = GeneratedColumn<int>(
      'expected_output_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _outputProductIdMeta =
      const VerificationMeta('outputProductId');
  @override
  late final GeneratedColumn<String> outputProductId = GeneratedColumn<String>(
      'output_product_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, expectedOutputValue, expectedOutputScale, outputProductId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes_table';
  @override
  VerificationContext validateIntegrity(Insertable<RecipesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('expected_output_value')) {
      context.handle(
          _expectedOutputValueMeta,
          expectedOutputValue.isAcceptableOrUnknown(
              data['expected_output_value']!, _expectedOutputValueMeta));
    } else if (isInserting) {
      context.missing(_expectedOutputValueMeta);
    }
    if (data.containsKey('expected_output_scale')) {
      context.handle(
          _expectedOutputScaleMeta,
          expectedOutputScale.isAcceptableOrUnknown(
              data['expected_output_scale']!, _expectedOutputScaleMeta));
    }
    if (data.containsKey('output_product_id')) {
      context.handle(
          _outputProductIdMeta,
          outputProductId.isAcceptableOrUnknown(
              data['output_product_id']!, _outputProductIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      expectedOutputValue: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_output_value'])!,
      expectedOutputScale: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}expected_output_scale'])!,
      outputProductId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}output_product_id']),
    );
  }

  @override
  $RecipesTableTable createAlias(String alias) {
    return $RecipesTableTable(attachedDatabase, alias);
  }
}

class RecipesTableData extends DataClass
    implements Insertable<RecipesTableData> {
  final String id;
  final String name;
  final int expectedOutputValue;
  final int expectedOutputScale;
  final String? outputProductId;
  const RecipesTableData(
      {required this.id,
      required this.name,
      required this.expectedOutputValue,
      required this.expectedOutputScale,
      this.outputProductId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['expected_output_value'] = Variable<int>(expectedOutputValue);
    map['expected_output_scale'] = Variable<int>(expectedOutputScale);
    if (!nullToAbsent || outputProductId != null) {
      map['output_product_id'] = Variable<String>(outputProductId);
    }
    return map;
  }

  RecipesTableCompanion toCompanion(bool nullToAbsent) {
    return RecipesTableCompanion(
      id: Value(id),
      name: Value(name),
      expectedOutputValue: Value(expectedOutputValue),
      expectedOutputScale: Value(expectedOutputScale),
      outputProductId: outputProductId == null && nullToAbsent
          ? const Value.absent()
          : Value(outputProductId),
    );
  }

  factory RecipesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      expectedOutputValue:
          serializer.fromJson<int>(json['expectedOutputValue']),
      expectedOutputScale:
          serializer.fromJson<int>(json['expectedOutputScale']),
      outputProductId: serializer.fromJson<String?>(json['outputProductId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'expectedOutputValue': serializer.toJson<int>(expectedOutputValue),
      'expectedOutputScale': serializer.toJson<int>(expectedOutputScale),
      'outputProductId': serializer.toJson<String?>(outputProductId),
    };
  }

  RecipesTableData copyWith(
          {String? id,
          String? name,
          int? expectedOutputValue,
          int? expectedOutputScale,
          Value<String?> outputProductId = const Value.absent()}) =>
      RecipesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        expectedOutputValue: expectedOutputValue ?? this.expectedOutputValue,
        expectedOutputScale: expectedOutputScale ?? this.expectedOutputScale,
        outputProductId: outputProductId.present
            ? outputProductId.value
            : this.outputProductId,
      );
  RecipesTableData copyWithCompanion(RecipesTableCompanion data) {
    return RecipesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      expectedOutputValue: data.expectedOutputValue.present
          ? data.expectedOutputValue.value
          : this.expectedOutputValue,
      expectedOutputScale: data.expectedOutputScale.present
          ? data.expectedOutputScale.value
          : this.expectedOutputScale,
      outputProductId: data.outputProductId.present
          ? data.outputProductId.value
          : this.outputProductId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('expectedOutputValue: $expectedOutputValue, ')
          ..write('expectedOutputScale: $expectedOutputScale, ')
          ..write('outputProductId: $outputProductId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, expectedOutputValue, expectedOutputScale, outputProductId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.expectedOutputValue == this.expectedOutputValue &&
          other.expectedOutputScale == this.expectedOutputScale &&
          other.outputProductId == this.outputProductId);
}

class RecipesTableCompanion extends UpdateCompanion<RecipesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> expectedOutputValue;
  final Value<int> expectedOutputScale;
  final Value<String?> outputProductId;
  final Value<int> rowid;
  const RecipesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.expectedOutputValue = const Value.absent(),
    this.expectedOutputScale = const Value.absent(),
    this.outputProductId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesTableCompanion.insert({
    required String id,
    required String name,
    required int expectedOutputValue,
    this.expectedOutputScale = const Value.absent(),
    this.outputProductId = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        expectedOutputValue = Value(expectedOutputValue);
  static Insertable<RecipesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? expectedOutputValue,
    Expression<int>? expectedOutputScale,
    Expression<String>? outputProductId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (expectedOutputValue != null)
        'expected_output_value': expectedOutputValue,
      if (expectedOutputScale != null)
        'expected_output_scale': expectedOutputScale,
      if (outputProductId != null) 'output_product_id': outputProductId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<int>? expectedOutputValue,
      Value<int>? expectedOutputScale,
      Value<String?>? outputProductId,
      Value<int>? rowid}) {
    return RecipesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      expectedOutputValue: expectedOutputValue ?? this.expectedOutputValue,
      expectedOutputScale: expectedOutputScale ?? this.expectedOutputScale,
      outputProductId: outputProductId ?? this.outputProductId,
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
    if (expectedOutputValue.present) {
      map['expected_output_value'] = Variable<int>(expectedOutputValue.value);
    }
    if (expectedOutputScale.present) {
      map['expected_output_scale'] = Variable<int>(expectedOutputScale.value);
    }
    if (outputProductId.present) {
      map['output_product_id'] = Variable<String>(outputProductId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('expectedOutputValue: $expectedOutputValue, ')
          ..write('expectedOutputScale: $expectedOutputScale, ')
          ..write('outputProductId: $outputProductId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeItemsTableTable extends RecipeItemsTable
    with TableInfo<$RecipeItemsTableTable, RecipeItemsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeItemsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeIdMeta =
      const VerificationMeta('recipeId');
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
      'recipe_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityValueMeta =
      const VerificationMeta('quantityValue');
  @override
  late final GeneratedColumn<int> quantityValue = GeneratedColumn<int>(
      'quantity_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _quantityScaleMeta =
      const VerificationMeta('quantityScale');
  @override
  late final GeneratedColumn<int> quantityScale = GeneratedColumn<int>(
      'quantity_scale', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns =>
      [id, recipeId, productId, quantityValue, quantityScale];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_items_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<RecipeItemsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(_recipeIdMeta,
          recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta));
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity_value')) {
      context.handle(
          _quantityValueMeta,
          quantityValue.isAcceptableOrUnknown(
              data['quantity_value']!, _quantityValueMeta));
    } else if (isInserting) {
      context.missing(_quantityValueMeta);
    }
    if (data.containsKey('quantity_scale')) {
      context.handle(
          _quantityScaleMeta,
          quantityScale.isAcceptableOrUnknown(
              data['quantity_scale']!, _quantityScaleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeItemsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeItemsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      recipeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}recipe_id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      quantityValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_value'])!,
      quantityScale: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity_scale'])!,
    );
  }

  @override
  $RecipeItemsTableTable createAlias(String alias) {
    return $RecipeItemsTableTable(attachedDatabase, alias);
  }
}

class RecipeItemsTableData extends DataClass
    implements Insertable<RecipeItemsTableData> {
  final String id;
  final String recipeId;
  final String productId;
  final int quantityValue;
  final int quantityScale;
  const RecipeItemsTableData(
      {required this.id,
      required this.recipeId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['product_id'] = Variable<String>(productId);
    map['quantity_value'] = Variable<int>(quantityValue);
    map['quantity_scale'] = Variable<int>(quantityScale);
    return map;
  }

  RecipeItemsTableCompanion toCompanion(bool nullToAbsent) {
    return RecipeItemsTableCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      productId: Value(productId),
      quantityValue: Value(quantityValue),
      quantityScale: Value(quantityScale),
    );
  }

  factory RecipeItemsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeItemsTableData(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      productId: serializer.fromJson<String>(json['productId']),
      quantityValue: serializer.fromJson<int>(json['quantityValue']),
      quantityScale: serializer.fromJson<int>(json['quantityScale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'productId': serializer.toJson<String>(productId),
      'quantityValue': serializer.toJson<int>(quantityValue),
      'quantityScale': serializer.toJson<int>(quantityScale),
    };
  }

  RecipeItemsTableData copyWith(
          {String? id,
          String? recipeId,
          String? productId,
          int? quantityValue,
          int? quantityScale}) =>
      RecipeItemsTableData(
        id: id ?? this.id,
        recipeId: recipeId ?? this.recipeId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
      );
  RecipeItemsTableData copyWithCompanion(RecipeItemsTableCompanion data) {
    return RecipeItemsTableData(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantityValue: data.quantityValue.present
          ? data.quantityValue.value
          : this.quantityValue,
      quantityScale: data.quantityScale.present
          ? data.quantityScale.value
          : this.quantityScale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsTableData(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, productId, quantityValue, quantityScale);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeItemsTableData &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale);
}

class RecipeItemsTableCompanion extends UpdateCompanion<RecipeItemsTableData> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String> productId;
  final Value<int> quantityValue;
  final Value<int> quantityScale;
  final Value<int> rowid;
  const RecipeItemsTableCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeItemsTableCompanion.insert({
    required String id,
    required String recipeId,
    required String productId,
    required int quantityValue,
    this.quantityScale = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        recipeId = Value(recipeId),
        productId = Value(productId),
        quantityValue = Value(quantityValue);
  static Insertable<RecipeItemsTableData> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? productId,
    Expression<int>? quantityValue,
    Expression<int>? quantityScale,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (productId != null) 'product_id': productId,
      if (quantityValue != null) 'quantity_value': quantityValue,
      if (quantityScale != null) 'quantity_scale': quantityScale,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeItemsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? recipeId,
      Value<String>? productId,
      Value<int>? quantityValue,
      Value<int>? quantityScale,
      Value<int>? rowid}) {
    return RecipeItemsTableCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantityValue.present) {
      map['quantity_value'] = Variable<int>(quantityValue.value);
    }
    if (quantityScale.present) {
      map['quantity_scale'] = Variable<int>(quantityScale.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeItemsTableCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('productId: $productId, ')
          ..write('quantityValue: $quantityValue, ')
          ..write('quantityScale: $quantityScale, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductPackagingsTableTable extends ProductPackagingsTable
    with TableInfo<$ProductPackagingsTableTable, ProductPackagingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductPackagingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _productIdMeta =
      const VerificationMeta('productId');
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
      'product_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fromUnitMeta =
      const VerificationMeta('fromUnit');
  @override
  late final GeneratedColumn<String> fromUnit = GeneratedColumn<String>(
      'from_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _toUnitMeta = const VerificationMeta('toUnit');
  @override
  late final GeneratedColumn<String> toUnit = GeneratedColumn<String>(
      'to_unit', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _multiplierValueMeta =
      const VerificationMeta('multiplierValue');
  @override
  late final GeneratedColumn<int> multiplierValue = GeneratedColumn<int>(
      'multiplier_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _divisorValueMeta =
      const VerificationMeta('divisorValue');
  @override
  late final GeneratedColumn<int> divisorValue = GeneratedColumn<int>(
      'divisor_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, productId, fromUnit, toUnit, multiplierValue, divisorValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_packagings_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ProductPackagingsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(_productIdMeta,
          productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta));
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('from_unit')) {
      context.handle(_fromUnitMeta,
          fromUnit.isAcceptableOrUnknown(data['from_unit']!, _fromUnitMeta));
    } else if (isInserting) {
      context.missing(_fromUnitMeta);
    }
    if (data.containsKey('to_unit')) {
      context.handle(_toUnitMeta,
          toUnit.isAcceptableOrUnknown(data['to_unit']!, _toUnitMeta));
    } else if (isInserting) {
      context.missing(_toUnitMeta);
    }
    if (data.containsKey('multiplier_value')) {
      context.handle(
          _multiplierValueMeta,
          multiplierValue.isAcceptableOrUnknown(
              data['multiplier_value']!, _multiplierValueMeta));
    } else if (isInserting) {
      context.missing(_multiplierValueMeta);
    }
    if (data.containsKey('divisor_value')) {
      context.handle(
          _divisorValueMeta,
          divisorValue.isAcceptableOrUnknown(
              data['divisor_value']!, _divisorValueMeta));
    } else if (isInserting) {
      context.missing(_divisorValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductPackagingsTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductPackagingsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      productId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}product_id'])!,
      fromUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}from_unit'])!,
      toUnit: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}to_unit'])!,
      multiplierValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}multiplier_value'])!,
      divisorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}divisor_value'])!,
    );
  }

  @override
  $ProductPackagingsTableTable createAlias(String alias) {
    return $ProductPackagingsTableTable(attachedDatabase, alias);
  }
}

class ProductPackagingsTableData extends DataClass
    implements Insertable<ProductPackagingsTableData> {
  final String id;
  final String productId;
  final String fromUnit;
  final String toUnit;
  final int multiplierValue;
  final int divisorValue;
  const ProductPackagingsTableData(
      {required this.id,
      required this.productId,
      required this.fromUnit,
      required this.toUnit,
      required this.multiplierValue,
      required this.divisorValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['from_unit'] = Variable<String>(fromUnit);
    map['to_unit'] = Variable<String>(toUnit);
    map['multiplier_value'] = Variable<int>(multiplierValue);
    map['divisor_value'] = Variable<int>(divisorValue);
    return map;
  }

  ProductPackagingsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductPackagingsTableCompanion(
      id: Value(id),
      productId: Value(productId),
      fromUnit: Value(fromUnit),
      toUnit: Value(toUnit),
      multiplierValue: Value(multiplierValue),
      divisorValue: Value(divisorValue),
    );
  }

  factory ProductPackagingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductPackagingsTableData(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      fromUnit: serializer.fromJson<String>(json['fromUnit']),
      toUnit: serializer.fromJson<String>(json['toUnit']),
      multiplierValue: serializer.fromJson<int>(json['multiplierValue']),
      divisorValue: serializer.fromJson<int>(json['divisorValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'fromUnit': serializer.toJson<String>(fromUnit),
      'toUnit': serializer.toJson<String>(toUnit),
      'multiplierValue': serializer.toJson<int>(multiplierValue),
      'divisorValue': serializer.toJson<int>(divisorValue),
    };
  }

  ProductPackagingsTableData copyWith(
          {String? id,
          String? productId,
          String? fromUnit,
          String? toUnit,
          int? multiplierValue,
          int? divisorValue}) =>
      ProductPackagingsTableData(
        id: id ?? this.id,
        productId: productId ?? this.productId,
        fromUnit: fromUnit ?? this.fromUnit,
        toUnit: toUnit ?? this.toUnit,
        multiplierValue: multiplierValue ?? this.multiplierValue,
        divisorValue: divisorValue ?? this.divisorValue,
      );
  ProductPackagingsTableData copyWithCompanion(
      ProductPackagingsTableCompanion data) {
    return ProductPackagingsTableData(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      fromUnit: data.fromUnit.present ? data.fromUnit.value : this.fromUnit,
      toUnit: data.toUnit.present ? data.toUnit.value : this.toUnit,
      multiplierValue: data.multiplierValue.present
          ? data.multiplierValue.value
          : this.multiplierValue,
      divisorValue: data.divisorValue.present
          ? data.divisorValue.value
          : this.divisorValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductPackagingsTableData(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('fromUnit: $fromUnit, ')
          ..write('toUnit: $toUnit, ')
          ..write('multiplierValue: $multiplierValue, ')
          ..write('divisorValue: $divisorValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, productId, fromUnit, toUnit, multiplierValue, divisorValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductPackagingsTableData &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.fromUnit == this.fromUnit &&
          other.toUnit == this.toUnit &&
          other.multiplierValue == this.multiplierValue &&
          other.divisorValue == this.divisorValue);
}

class ProductPackagingsTableCompanion
    extends UpdateCompanion<ProductPackagingsTableData> {
  final Value<String> id;
  final Value<String> productId;
  final Value<String> fromUnit;
  final Value<String> toUnit;
  final Value<int> multiplierValue;
  final Value<int> divisorValue;
  final Value<int> rowid;
  const ProductPackagingsTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.fromUnit = const Value.absent(),
    this.toUnit = const Value.absent(),
    this.multiplierValue = const Value.absent(),
    this.divisorValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductPackagingsTableCompanion.insert({
    required String id,
    required String productId,
    required String fromUnit,
    required String toUnit,
    required int multiplierValue,
    required int divisorValue,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        productId = Value(productId),
        fromUnit = Value(fromUnit),
        toUnit = Value(toUnit),
        multiplierValue = Value(multiplierValue),
        divisorValue = Value(divisorValue);
  static Insertable<ProductPackagingsTableData> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<String>? fromUnit,
    Expression<String>? toUnit,
    Expression<int>? multiplierValue,
    Expression<int>? divisorValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (fromUnit != null) 'from_unit': fromUnit,
      if (toUnit != null) 'to_unit': toUnit,
      if (multiplierValue != null) 'multiplier_value': multiplierValue,
      if (divisorValue != null) 'divisor_value': divisorValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductPackagingsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? productId,
      Value<String>? fromUnit,
      Value<String>? toUnit,
      Value<int>? multiplierValue,
      Value<int>? divisorValue,
      Value<int>? rowid}) {
    return ProductPackagingsTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
      multiplierValue: multiplierValue ?? this.multiplierValue,
      divisorValue: divisorValue ?? this.divisorValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (fromUnit.present) {
      map['from_unit'] = Variable<String>(fromUnit.value);
    }
    if (toUnit.present) {
      map['to_unit'] = Variable<String>(toUnit.value);
    }
    if (multiplierValue.present) {
      map['multiplier_value'] = Variable<int>(multiplierValue.value);
    }
    if (divisorValue.present) {
      map['divisor_value'] = Variable<int>(divisorValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductPackagingsTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('fromUnit: $fromUnit, ')
          ..write('toUnit: $toUnit, ')
          ..write('multiplierValue: $multiplierValue, ')
          ..write('divisorValue: $divisorValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTableTable extends SyncQueueTable
    with TableInfo<$SyncQueueTableTable, SyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _endpointMeta =
      const VerificationMeta('endpoint');
  @override
  late final GeneratedColumn<String> endpoint = GeneratedColumn<String>(
      'endpoint', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sourceTableMeta =
      const VerificationMeta('sourceTable');
  @override
  late final GeneratedColumn<String> sourceTable = GeneratedColumn<String>(
      'source_table', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retryCountMeta =
      const VerificationMeta('retryCount');
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
      'retry_count', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        endpoint,
        sourceTable,
        referenceId,
        payloadJson,
        status,
        retryCount,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue_table';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('endpoint')) {
      context.handle(_endpointMeta,
          endpoint.isAcceptableOrUnknown(data['endpoint']!, _endpointMeta));
    } else if (isInserting) {
      context.missing(_endpointMeta);
    }
    if (data.containsKey('source_table')) {
      context.handle(
          _sourceTableMeta,
          sourceTable.isAcceptableOrUnknown(
              data['source_table']!, _sourceTableMeta));
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
          _retryCountMeta,
          retryCount.isAcceptableOrUnknown(
              data['retry_count']!, _retryCountMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      endpoint: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}endpoint'])!,
      sourceTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_table'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id']),
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      retryCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retry_count'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SyncQueueTableTable createAlias(String alias) {
    return $SyncQueueTableTable(attachedDatabase, alias);
  }
}

class SyncQueueTableData extends DataClass
    implements Insertable<SyncQueueTableData> {
  final String id;
  final String endpoint;
  final String sourceTable;
  final String? referenceId;
  final String payloadJson;
  final String status;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SyncQueueTableData(
      {required this.id,
      required this.endpoint,
      required this.sourceTable,
      this.referenceId,
      required this.payloadJson,
      required this.status,
      required this.retryCount,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['endpoint'] = Variable<String>(endpoint);
    map['source_table'] = Variable<String>(sourceTable);
    if (!nullToAbsent || referenceId != null) {
      map['reference_id'] = Variable<String>(referenceId);
    }
    map['payload_json'] = Variable<String>(payloadJson);
    map['status'] = Variable<String>(status);
    map['retry_count'] = Variable<int>(retryCount);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueTableCompanion(
      id: Value(id),
      endpoint: Value(endpoint),
      sourceTable: Value(sourceTable),
      referenceId: referenceId == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceId),
      payloadJson: Value(payloadJson),
      status: Value(status),
      retryCount: Value(retryCount),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SyncQueueTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueTableData(
      id: serializer.fromJson<String>(json['id']),
      endpoint: serializer.fromJson<String>(json['endpoint']),
      sourceTable: serializer.fromJson<String>(json['sourceTable']),
      referenceId: serializer.fromJson<String?>(json['referenceId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      status: serializer.fromJson<String>(json['status']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'endpoint': serializer.toJson<String>(endpoint),
      'sourceTable': serializer.toJson<String>(sourceTable),
      'referenceId': serializer.toJson<String?>(referenceId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'status': serializer.toJson<String>(status),
      'retryCount': serializer.toJson<int>(retryCount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SyncQueueTableData copyWith(
          {String? id,
          String? endpoint,
          String? sourceTable,
          Value<String?> referenceId = const Value.absent(),
          String? payloadJson,
          String? status,
          int? retryCount,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SyncQueueTableData(
        id: id ?? this.id,
        endpoint: endpoint ?? this.endpoint,
        sourceTable: sourceTable ?? this.sourceTable,
        referenceId: referenceId.present ? referenceId.value : this.referenceId,
        payloadJson: payloadJson ?? this.payloadJson,
        status: status ?? this.status,
        retryCount: retryCount ?? this.retryCount,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SyncQueueTableData copyWithCompanion(SyncQueueTableCompanion data) {
    return SyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      endpoint: data.endpoint.present ? data.endpoint.value : this.endpoint,
      sourceTable:
          data.sourceTable.present ? data.sourceTable.value : this.sourceTable,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      status: data.status.present ? data.status.value : this.status,
      retryCount:
          data.retryCount.present ? data.retryCount.value : this.retryCount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableData(')
          ..write('id: $id, ')
          ..write('endpoint: $endpoint, ')
          ..write('sourceTable: $sourceTable, ')
          ..write('referenceId: $referenceId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, endpoint, sourceTable, referenceId,
      payloadJson, status, retryCount, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueTableData &&
          other.id == this.id &&
          other.endpoint == this.endpoint &&
          other.sourceTable == this.sourceTable &&
          other.referenceId == this.referenceId &&
          other.payloadJson == this.payloadJson &&
          other.status == this.status &&
          other.retryCount == this.retryCount &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SyncQueueTableCompanion extends UpdateCompanion<SyncQueueTableData> {
  final Value<String> id;
  final Value<String> endpoint;
  final Value<String> sourceTable;
  final Value<String?> referenceId;
  final Value<String> payloadJson;
  final Value<String> status;
  final Value<int> retryCount;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.endpoint = const Value.absent(),
    this.sourceTable = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.status = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncQueueTableCompanion.insert({
    required String id,
    required String endpoint,
    this.sourceTable = const Value.absent(),
    this.referenceId = const Value.absent(),
    required String payloadJson,
    required String status,
    this.retryCount = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        endpoint = Value(endpoint),
        payloadJson = Value(payloadJson),
        status = Value(status),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<SyncQueueTableData> custom({
    Expression<String>? id,
    Expression<String>? endpoint,
    Expression<String>? sourceTable,
    Expression<String>? referenceId,
    Expression<String>? payloadJson,
    Expression<String>? status,
    Expression<int>? retryCount,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (endpoint != null) 'endpoint': endpoint,
      if (sourceTable != null) 'source_table': sourceTable,
      if (referenceId != null) 'reference_id': referenceId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (status != null) 'status': status,
      if (retryCount != null) 'retry_count': retryCount,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncQueueTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? endpoint,
      Value<String>? sourceTable,
      Value<String?>? referenceId,
      Value<String>? payloadJson,
      Value<String>? status,
      Value<int>? retryCount,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return SyncQueueTableCompanion(
      id: id ?? this.id,
      endpoint: endpoint ?? this.endpoint,
      sourceTable: sourceTable ?? this.sourceTable,
      referenceId: referenceId ?? this.referenceId,
      payloadJson: payloadJson ?? this.payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (endpoint.present) {
      map['endpoint'] = Variable<String>(endpoint.value);
    }
    if (sourceTable.present) {
      map['source_table'] = Variable<String>(sourceTable.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('endpoint: $endpoint, ')
          ..write('sourceTable: $sourceTable, ')
          ..write('referenceId: $referenceId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('status: $status, ')
          ..write('retryCount: $retryCount, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UomsTableTable extends UomsTable
    with TableInfo<$UomsTableTable, UomsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UomsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
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
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, symbol, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'uoms_table';
  @override
  VerificationContext validateIntegrity(Insertable<UomsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UomsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UomsTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $UomsTableTable createAlias(String alias) {
    return $UomsTableTable(attachedDatabase, alias);
  }
}

class UomsTableData extends DataClass implements Insertable<UomsTableData> {
  final String id;
  final String name;
  final String symbol;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UomsTableData(
      {required this.id,
      required this.name,
      required this.symbol,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['symbol'] = Variable<String>(symbol);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UomsTableCompanion toCompanion(bool nullToAbsent) {
    return UomsTableCompanion(
      id: Value(id),
      name: Value(name),
      symbol: Value(symbol),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UomsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UomsTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      symbol: serializer.fromJson<String>(json['symbol']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'symbol': serializer.toJson<String>(symbol),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UomsTableData copyWith(
          {String? id,
          String? name,
          String? symbol,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      UomsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        symbol: symbol ?? this.symbol,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  UomsTableData copyWithCompanion(UomsTableCompanion data) {
    return UomsTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UomsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, symbol, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UomsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.symbol == this.symbol &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UomsTableCompanion extends UpdateCompanion<UomsTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> symbol;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UomsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.symbol = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UomsTableCompanion.insert({
    required String id,
    required String name,
    required String symbol,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        symbol = Value(symbol),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<UomsTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? symbol,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (symbol != null) 'symbol': symbol,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UomsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? symbol,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return UomsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UomsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('symbol: $symbol, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoriesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
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
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, isActive, createdAt, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CategoriesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(_isActiveMeta,
          isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoriesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoriesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isActive: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_active'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoriesTableData extends DataClass
    implements Insertable<CategoriesTableData> {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CategoriesTableData(
      {required this.id,
      required this.name,
      required this.isActive,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CategoriesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoriesTableData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CategoriesTableData copyWith(
          {String? id,
          String? name,
          bool? isActive,
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      CategoriesTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CategoriesTableData copyWithCompanion(CategoriesTableCompanion data) {
    return CategoriesTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, isActive, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoriesTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoriesTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        createdAt = Value(createdAt),
        updatedAt = Value(updatedAt);
  static Insertable<CategoriesTableData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<bool>? isActive,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt,
      Value<int>? rowid}) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $CustomersTableTable customersTable = $CustomersTableTable(this);
  late final $CostLayersTableTable costLayersTable =
      $CostLayersTableTable(this);
  late final $ReceivingsTableTable receivingsTable =
      $ReceivingsTableTable(this);
  late final $ReceivingItemsTableTable receivingItemsTable =
      $ReceivingItemsTableTable(this);
  late final $PurchasesTableTable purchasesTable = $PurchasesTableTable(this);
  late final $PurchaseItemsTableTable purchaseItemsTable =
      $PurchaseItemsTableTable(this);
  late final $SalesTableTable salesTable = $SalesTableTable(this);
  late final $SaleItemsTableTable saleItemsTable = $SaleItemsTableTable(this);
  late final $StockMovementsTableTable stockMovementsTable =
      $StockMovementsTableTable(this);
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $OrderItemsTableTable orderItemsTable =
      $OrderItemsTableTable(this);
  late final $RecipesTableTable recipesTable = $RecipesTableTable(this);
  late final $RecipeItemsTableTable recipeItemsTable =
      $RecipeItemsTableTable(this);
  late final $ProductPackagingsTableTable productPackagingsTable =
      $ProductPackagingsTableTable(this);
  late final $SyncQueueTableTable syncQueueTable = $SyncQueueTableTable(this);
  late final $UomsTableTable uomsTable = $UomsTableTable(this);
  late final $CategoriesTableTable categoriesTable =
      $CategoriesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        productsTable,
        customersTable,
        costLayersTable,
        receivingsTable,
        receivingItemsTable,
        purchasesTable,
        purchaseItemsTable,
        salesTable,
        saleItemsTable,
        stockMovementsTable,
        ordersTable,
        orderItemsTable,
        recipesTable,
        recipeItemsTable,
        productPackagingsTable,
        syncQueueTable,
        uomsTable,
        categoriesTable
      ];
}

typedef $$ProductsTableTableCreateCompanionBuilder = ProductsTableCompanion
    Function({
  required String id,
  required String sku,
  required String name,
  required String baseUnit,
  required int purchasePriceMinorUnits,
  Value<String> purchasePriceCurrency,
  required int sellingPriceMinorUnits,
  Value<String> sellingPriceCurrency,
  Value<bool> active,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$ProductsTableTableUpdateCompanionBuilder = ProductsTableCompanion
    Function({
  Value<String> id,
  Value<String> sku,
  Value<String> name,
  Value<String> baseUnit,
  Value<int> purchasePriceMinorUnits,
  Value<String> purchasePriceCurrency,
  Value<int> sellingPriceMinorUnits,
  Value<String> sellingPriceCurrency,
  Value<bool> active,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get baseUnit => $composableBuilder(
      column: $table.baseUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get purchasePriceMinorUnits => $composableBuilder(
      column: $table.purchasePriceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchasePriceCurrency => $composableBuilder(
      column: $table.purchasePriceCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sellingPriceMinorUnits => $composableBuilder(
      column: $table.sellingPriceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sellingPriceCurrency => $composableBuilder(
      column: $table.sellingPriceCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sku => $composableBuilder(
      column: $table.sku, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get baseUnit => $composableBuilder(
      column: $table.baseUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get purchasePriceMinorUnits => $composableBuilder(
      column: $table.purchasePriceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchasePriceCurrency => $composableBuilder(
      column: $table.purchasePriceCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sellingPriceMinorUnits => $composableBuilder(
      column: $table.sellingPriceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sellingPriceCurrency => $composableBuilder(
      column: $table.sellingPriceCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get active => $composableBuilder(
      column: $table.active, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get baseUnit =>
      $composableBuilder(column: $table.baseUnit, builder: (column) => column);

  GeneratedColumn<int> get purchasePriceMinorUnits => $composableBuilder(
      column: $table.purchasePriceMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get purchasePriceCurrency => $composableBuilder(
      column: $table.purchasePriceCurrency, builder: (column) => column);

  GeneratedColumn<int> get sellingPriceMinorUnits => $composableBuilder(
      column: $table.sellingPriceMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get sellingPriceCurrency => $composableBuilder(
      column: $table.sellingPriceCurrency, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$ProductsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()> {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> sku = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> baseUnit = const Value.absent(),
            Value<int> purchasePriceMinorUnits = const Value.absent(),
            Value<String> purchasePriceCurrency = const Value.absent(),
            Value<int> sellingPriceMinorUnits = const Value.absent(),
            Value<String> sellingPriceCurrency = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsTableCompanion(
            id: id,
            sku: sku,
            name: name,
            baseUnit: baseUnit,
            purchasePriceMinorUnits: purchasePriceMinorUnits,
            purchasePriceCurrency: purchasePriceCurrency,
            sellingPriceMinorUnits: sellingPriceMinorUnits,
            sellingPriceCurrency: sellingPriceCurrency,
            active: active,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String sku,
            required String name,
            required String baseUnit,
            required int purchasePriceMinorUnits,
            Value<String> purchasePriceCurrency = const Value.absent(),
            required int sellingPriceMinorUnits,
            Value<String> sellingPriceCurrency = const Value.absent(),
            Value<bool> active = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductsTableCompanion.insert(
            id: id,
            sku: sku,
            name: name,
            baseUnit: baseUnit,
            purchasePriceMinorUnits: purchasePriceMinorUnits,
            purchasePriceCurrency: purchasePriceCurrency,
            sellingPriceMinorUnits: sellingPriceMinorUnits,
            sellingPriceCurrency: sellingPriceCurrency,
            active: active,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProductsTableTable,
    ProductsTableData,
    $$ProductsTableTableFilterComposer,
    $$ProductsTableTableOrderingComposer,
    $$ProductsTableTableAnnotationComposer,
    $$ProductsTableTableCreateCompanionBuilder,
    $$ProductsTableTableUpdateCompanionBuilder,
    (
      ProductsTableData,
      BaseReferences<_$AppDatabase, $ProductsTableTable, ProductsTableData>
    ),
    ProductsTableData,
    PrefetchHooks Function()>;
typedef $$CustomersTableTableCreateCompanionBuilder = CustomersTableCompanion
    Function({
  required String id,
  required String name,
  required String phoneNumber,
  Value<String?> address,
  Value<String?> notes,
  required DateTime createdAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$CustomersTableTableUpdateCompanionBuilder = CustomersTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> phoneNumber,
  Value<String?> address,
  Value<String?> notes,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$CustomersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTableTable> {
  $$CustomersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$CustomersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTableTable> {
  $$CustomersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$CustomersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTableTable> {
  $$CustomersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
      column: $table.phoneNumber, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CustomersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CustomersTableTable,
    CustomersTableData,
    $$CustomersTableTableFilterComposer,
    $$CustomersTableTableOrderingComposer,
    $$CustomersTableTableAnnotationComposer,
    $$CustomersTableTableCreateCompanionBuilder,
    $$CustomersTableTableUpdateCompanionBuilder,
    (
      CustomersTableData,
      BaseReferences<_$AppDatabase, $CustomersTableTable, CustomersTableData>
    ),
    CustomersTableData,
    PrefetchHooks Function()> {
  $$CustomersTableTableTableManager(
      _$AppDatabase db, $CustomersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> phoneNumber = const Value.absent(),
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersTableCompanion(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            address: address,
            notes: notes,
            createdAt: createdAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String phoneNumber,
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersTableCompanion.insert(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            address: address,
            notes: notes,
            createdAt: createdAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CustomersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CustomersTableTable,
    CustomersTableData,
    $$CustomersTableTableFilterComposer,
    $$CustomersTableTableOrderingComposer,
    $$CustomersTableTableAnnotationComposer,
    $$CustomersTableTableCreateCompanionBuilder,
    $$CustomersTableTableUpdateCompanionBuilder,
    (
      CustomersTableData,
      BaseReferences<_$AppDatabase, $CustomersTableTable, CustomersTableData>
    ),
    CustomersTableData,
    PrefetchHooks Function()>;
typedef $$CostLayersTableTableCreateCompanionBuilder = CostLayersTableCompanion
    Function({
  required String id,
  required String productId,
  required int originalQuantityValue,
  required int originalQuantityScale,
  required int remainingQuantityValue,
  required int remainingQuantityScale,
  required int unitCostMinorUnits,
  Value<String> unitCostCurrency,
  Value<String?> purchaseId,
  required DateTime acquiredAt,
  Value<int> rowid,
});
typedef $$CostLayersTableTableUpdateCompanionBuilder = CostLayersTableCompanion
    Function({
  Value<String> id,
  Value<String> productId,
  Value<int> originalQuantityValue,
  Value<int> originalQuantityScale,
  Value<int> remainingQuantityValue,
  Value<int> remainingQuantityScale,
  Value<int> unitCostMinorUnits,
  Value<String> unitCostCurrency,
  Value<String?> purchaseId,
  Value<DateTime> acquiredAt,
  Value<int> rowid,
});

class $$CostLayersTableTableFilterComposer
    extends Composer<_$AppDatabase, $CostLayersTableTable> {
  $$CostLayersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get originalQuantityValue => $composableBuilder(
      column: $table.originalQuantityValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get originalQuantityScale => $composableBuilder(
      column: $table.originalQuantityScale,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remainingQuantityValue => $composableBuilder(
      column: $table.remainingQuantityValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get remainingQuantityScale => $composableBuilder(
      column: $table.remainingQuantityScale,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get acquiredAt => $composableBuilder(
      column: $table.acquiredAt, builder: (column) => ColumnFilters(column));
}

class $$CostLayersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CostLayersTableTable> {
  $$CostLayersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get originalQuantityValue => $composableBuilder(
      column: $table.originalQuantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get originalQuantityScale => $composableBuilder(
      column: $table.originalQuantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remainingQuantityValue => $composableBuilder(
      column: $table.remainingQuantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get remainingQuantityScale => $composableBuilder(
      column: $table.remainingQuantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get acquiredAt => $composableBuilder(
      column: $table.acquiredAt, builder: (column) => ColumnOrderings(column));
}

class $$CostLayersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CostLayersTableTable> {
  $$CostLayersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get originalQuantityValue => $composableBuilder(
      column: $table.originalQuantityValue, builder: (column) => column);

  GeneratedColumn<int> get originalQuantityScale => $composableBuilder(
      column: $table.originalQuantityScale, builder: (column) => column);

  GeneratedColumn<int> get remainingQuantityValue => $composableBuilder(
      column: $table.remainingQuantityValue, builder: (column) => column);

  GeneratedColumn<int> get remainingQuantityScale => $composableBuilder(
      column: $table.remainingQuantityScale, builder: (column) => column);

  GeneratedColumn<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => column);

  GeneratedColumn<DateTime> get acquiredAt => $composableBuilder(
      column: $table.acquiredAt, builder: (column) => column);
}

class $$CostLayersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CostLayersTableTable,
    CostLayersTableData,
    $$CostLayersTableTableFilterComposer,
    $$CostLayersTableTableOrderingComposer,
    $$CostLayersTableTableAnnotationComposer,
    $$CostLayersTableTableCreateCompanionBuilder,
    $$CostLayersTableTableUpdateCompanionBuilder,
    (
      CostLayersTableData,
      BaseReferences<_$AppDatabase, $CostLayersTableTable, CostLayersTableData>
    ),
    CostLayersTableData,
    PrefetchHooks Function()> {
  $$CostLayersTableTableTableManager(
      _$AppDatabase db, $CostLayersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CostLayersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CostLayersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CostLayersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> originalQuantityValue = const Value.absent(),
            Value<int> originalQuantityScale = const Value.absent(),
            Value<int> remainingQuantityValue = const Value.absent(),
            Value<int> remainingQuantityScale = const Value.absent(),
            Value<int> unitCostMinorUnits = const Value.absent(),
            Value<String> unitCostCurrency = const Value.absent(),
            Value<String?> purchaseId = const Value.absent(),
            Value<DateTime> acquiredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CostLayersTableCompanion(
            id: id,
            productId: productId,
            originalQuantityValue: originalQuantityValue,
            originalQuantityScale: originalQuantityScale,
            remainingQuantityValue: remainingQuantityValue,
            remainingQuantityScale: remainingQuantityScale,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            purchaseId: purchaseId,
            acquiredAt: acquiredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required int originalQuantityValue,
            required int originalQuantityScale,
            required int remainingQuantityValue,
            required int remainingQuantityScale,
            required int unitCostMinorUnits,
            Value<String> unitCostCurrency = const Value.absent(),
            Value<String?> purchaseId = const Value.absent(),
            required DateTime acquiredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CostLayersTableCompanion.insert(
            id: id,
            productId: productId,
            originalQuantityValue: originalQuantityValue,
            originalQuantityScale: originalQuantityScale,
            remainingQuantityValue: remainingQuantityValue,
            remainingQuantityScale: remainingQuantityScale,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            purchaseId: purchaseId,
            acquiredAt: acquiredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CostLayersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CostLayersTableTable,
    CostLayersTableData,
    $$CostLayersTableTableFilterComposer,
    $$CostLayersTableTableOrderingComposer,
    $$CostLayersTableTableAnnotationComposer,
    $$CostLayersTableTableCreateCompanionBuilder,
    $$CostLayersTableTableUpdateCompanionBuilder,
    (
      CostLayersTableData,
      BaseReferences<_$AppDatabase, $CostLayersTableTable, CostLayersTableData>
    ),
    CostLayersTableData,
    PrefetchHooks Function()>;
typedef $$ReceivingsTableTableCreateCompanionBuilder = ReceivingsTableCompanion
    Function({
  required String id,
  required String purchaseId,
  required DateTime receivedAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$ReceivingsTableTableUpdateCompanionBuilder = ReceivingsTableCompanion
    Function({
  Value<String> id,
  Value<String> purchaseId,
  Value<DateTime> receivedAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$ReceivingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReceivingsTableTable> {
  $$ReceivingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$ReceivingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceivingsTableTable> {
  $$ReceivingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$ReceivingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceivingsTableTable> {
  $$ReceivingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => column);

  GeneratedColumn<DateTime> get receivedAt => $composableBuilder(
      column: $table.receivedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$ReceivingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceivingsTableTable,
    ReceivingsTableData,
    $$ReceivingsTableTableFilterComposer,
    $$ReceivingsTableTableOrderingComposer,
    $$ReceivingsTableTableAnnotationComposer,
    $$ReceivingsTableTableCreateCompanionBuilder,
    $$ReceivingsTableTableUpdateCompanionBuilder,
    (
      ReceivingsTableData,
      BaseReferences<_$AppDatabase, $ReceivingsTableTable, ReceivingsTableData>
    ),
    ReceivingsTableData,
    PrefetchHooks Function()> {
  $$ReceivingsTableTableTableManager(
      _$AppDatabase db, $ReceivingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceivingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceivingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceivingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> purchaseId = const Value.absent(),
            Value<DateTime> receivedAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceivingsTableCompanion(
            id: id,
            purchaseId: purchaseId,
            receivedAt: receivedAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String purchaseId,
            required DateTime receivedAt,
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceivingsTableCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            receivedAt: receivedAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReceivingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceivingsTableTable,
    ReceivingsTableData,
    $$ReceivingsTableTableFilterComposer,
    $$ReceivingsTableTableOrderingComposer,
    $$ReceivingsTableTableAnnotationComposer,
    $$ReceivingsTableTableCreateCompanionBuilder,
    $$ReceivingsTableTableUpdateCompanionBuilder,
    (
      ReceivingsTableData,
      BaseReferences<_$AppDatabase, $ReceivingsTableTable, ReceivingsTableData>
    ),
    ReceivingsTableData,
    PrefetchHooks Function()>;
typedef $$ReceivingItemsTableTableCreateCompanionBuilder
    = ReceivingItemsTableCompanion Function({
  required String id,
  required String receivingId,
  required String productId,
  required int quantityValue,
  Value<int> quantityScale,
  Value<String?> unit,
  required int unitCostMinorUnits,
  Value<String> unitCostCurrency,
  Value<int> rowid,
});
typedef $$ReceivingItemsTableTableUpdateCompanionBuilder
    = ReceivingItemsTableCompanion Function({
  Value<String> id,
  Value<String> receivingId,
  Value<String> productId,
  Value<int> quantityValue,
  Value<int> quantityScale,
  Value<String?> unit,
  Value<int> unitCostMinorUnits,
  Value<String> unitCostCurrency,
  Value<int> rowid,
});

class $$ReceivingItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ReceivingItemsTableTable> {
  $$ReceivingItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get receivingId => $composableBuilder(
      column: $table.receivingId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnFilters(column));
}

class $$ReceivingItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ReceivingItemsTableTable> {
  $$ReceivingItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get receivingId => $composableBuilder(
      column: $table.receivingId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnOrderings(column));
}

class $$ReceivingItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReceivingItemsTableTable> {
  $$ReceivingItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receivingId => $composableBuilder(
      column: $table.receivingId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency, builder: (column) => column);
}

class $$ReceivingItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReceivingItemsTableTable,
    ReceivingItemsTableData,
    $$ReceivingItemsTableTableFilterComposer,
    $$ReceivingItemsTableTableOrderingComposer,
    $$ReceivingItemsTableTableAnnotationComposer,
    $$ReceivingItemsTableTableCreateCompanionBuilder,
    $$ReceivingItemsTableTableUpdateCompanionBuilder,
    (
      ReceivingItemsTableData,
      BaseReferences<_$AppDatabase, $ReceivingItemsTableTable,
          ReceivingItemsTableData>
    ),
    ReceivingItemsTableData,
    PrefetchHooks Function()> {
  $$ReceivingItemsTableTableTableManager(
      _$AppDatabase db, $ReceivingItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReceivingItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReceivingItemsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReceivingItemsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> receivingId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantityValue = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int> unitCostMinorUnits = const Value.absent(),
            Value<String> unitCostCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceivingItemsTableCompanion(
            id: id,
            receivingId: receivingId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            unit: unit,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String receivingId,
            required String productId,
            required int quantityValue,
            Value<int> quantityScale = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            required int unitCostMinorUnits,
            Value<String> unitCostCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceivingItemsTableCompanion.insert(
            id: id,
            receivingId: receivingId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            unit: unit,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReceivingItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReceivingItemsTableTable,
    ReceivingItemsTableData,
    $$ReceivingItemsTableTableFilterComposer,
    $$ReceivingItemsTableTableOrderingComposer,
    $$ReceivingItemsTableTableAnnotationComposer,
    $$ReceivingItemsTableTableCreateCompanionBuilder,
    $$ReceivingItemsTableTableUpdateCompanionBuilder,
    (
      ReceivingItemsTableData,
      BaseReferences<_$AppDatabase, $ReceivingItemsTableTable,
          ReceivingItemsTableData>
    ),
    ReceivingItemsTableData,
    PrefetchHooks Function()>;
typedef $$PurchasesTableTableCreateCompanionBuilder = PurchasesTableCompanion
    Function({
  required String id,
  required DateTime purchasedAt,
  Value<String?> supplierId,
  Value<String?> referenceNumber,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$PurchasesTableTableUpdateCompanionBuilder = PurchasesTableCompanion
    Function({
  Value<String> id,
  Value<DateTime> purchasedAt,
  Value<String?> supplierId,
  Value<String?> referenceNumber,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$PurchasesTableTableFilterComposer
    extends Composer<_$AppDatabase, $PurchasesTableTable> {
  $$PurchasesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$PurchasesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchasesTableTable> {
  $$PurchasesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$PurchasesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchasesTableTable> {
  $$PurchasesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get purchasedAt => $composableBuilder(
      column: $table.purchasedAt, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
      column: $table.supplierId, builder: (column) => column);

  GeneratedColumn<String> get referenceNumber => $composableBuilder(
      column: $table.referenceNumber, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$PurchasesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchasesTableTable,
    PurchasesTableData,
    $$PurchasesTableTableFilterComposer,
    $$PurchasesTableTableOrderingComposer,
    $$PurchasesTableTableAnnotationComposer,
    $$PurchasesTableTableCreateCompanionBuilder,
    $$PurchasesTableTableUpdateCompanionBuilder,
    (
      PurchasesTableData,
      BaseReferences<_$AppDatabase, $PurchasesTableTable, PurchasesTableData>
    ),
    PurchasesTableData,
    PrefetchHooks Function()> {
  $$PurchasesTableTableTableManager(
      _$AppDatabase db, $PurchasesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchasesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchasesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchasesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> purchasedAt = const Value.absent(),
            Value<String?> supplierId = const Value.absent(),
            Value<String?> referenceNumber = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesTableCompanion(
            id: id,
            purchasedAt: purchasedAt,
            supplierId: supplierId,
            referenceNumber: referenceNumber,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime purchasedAt,
            Value<String?> supplierId = const Value.absent(),
            Value<String?> referenceNumber = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesTableCompanion.insert(
            id: id,
            purchasedAt: purchasedAt,
            supplierId: supplierId,
            referenceNumber: referenceNumber,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PurchasesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchasesTableTable,
    PurchasesTableData,
    $$PurchasesTableTableFilterComposer,
    $$PurchasesTableTableOrderingComposer,
    $$PurchasesTableTableAnnotationComposer,
    $$PurchasesTableTableCreateCompanionBuilder,
    $$PurchasesTableTableUpdateCompanionBuilder,
    (
      PurchasesTableData,
      BaseReferences<_$AppDatabase, $PurchasesTableTable, PurchasesTableData>
    ),
    PurchasesTableData,
    PrefetchHooks Function()>;
typedef $$PurchaseItemsTableTableCreateCompanionBuilder
    = PurchaseItemsTableCompanion Function({
  required String id,
  required String purchaseId,
  required String productId,
  required int quantityValue,
  Value<int> quantityScale,
  Value<String?> unit,
  required int unitCostMinorUnits,
  Value<String> unitCostCurrency,
  Value<int> rowid,
});
typedef $$PurchaseItemsTableTableUpdateCompanionBuilder
    = PurchaseItemsTableCompanion Function({
  Value<String> id,
  Value<String> purchaseId,
  Value<String> productId,
  Value<int> quantityValue,
  Value<int> quantityScale,
  Value<String?> unit,
  Value<int> unitCostMinorUnits,
  Value<String> unitCostCurrency,
  Value<int> rowid,
});

class $$PurchaseItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTableTable> {
  $$PurchaseItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnFilters(column));
}

class $$PurchaseItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTableTable> {
  $$PurchaseItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnOrderings(column));
}

class $$PurchaseItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseItemsTableTable> {
  $$PurchaseItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
      column: $table.purchaseId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency, builder: (column) => column);
}

class $$PurchaseItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PurchaseItemsTableTable,
    PurchaseItemsTableData,
    $$PurchaseItemsTableTableFilterComposer,
    $$PurchaseItemsTableTableOrderingComposer,
    $$PurchaseItemsTableTableAnnotationComposer,
    $$PurchaseItemsTableTableCreateCompanionBuilder,
    $$PurchaseItemsTableTableUpdateCompanionBuilder,
    (
      PurchaseItemsTableData,
      BaseReferences<_$AppDatabase, $PurchaseItemsTableTable,
          PurchaseItemsTableData>
    ),
    PurchaseItemsTableData,
    PrefetchHooks Function()> {
  $$PurchaseItemsTableTableTableManager(
      _$AppDatabase db, $PurchaseItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseItemsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> purchaseId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantityValue = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int> unitCostMinorUnits = const Value.absent(),
            Value<String> unitCostCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchaseItemsTableCompanion(
            id: id,
            purchaseId: purchaseId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            unit: unit,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String purchaseId,
            required String productId,
            required int quantityValue,
            Value<int> quantityScale = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            required int unitCostMinorUnits,
            Value<String> unitCostCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchaseItemsTableCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            unit: unit,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$PurchaseItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $PurchaseItemsTableTable,
    PurchaseItemsTableData,
    $$PurchaseItemsTableTableFilterComposer,
    $$PurchaseItemsTableTableOrderingComposer,
    $$PurchaseItemsTableTableAnnotationComposer,
    $$PurchaseItemsTableTableCreateCompanionBuilder,
    $$PurchaseItemsTableTableUpdateCompanionBuilder,
    (
      PurchaseItemsTableData,
      BaseReferences<_$AppDatabase, $PurchaseItemsTableTable,
          PurchaseItemsTableData>
    ),
    PurchaseItemsTableData,
    PrefetchHooks Function()>;
typedef $$SalesTableTableCreateCompanionBuilder = SalesTableCompanion Function({
  required String id,
  required String invoiceNumber,
  required int discountMinorUnits,
  required int taxMinorUnits,
  required DateTime createdAt,
  required DateTime soldAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$SalesTableTableUpdateCompanionBuilder = SalesTableCompanion Function({
  Value<String> id,
  Value<String> invoiceNumber,
  Value<int> discountMinorUnits,
  Value<int> taxMinorUnits,
  Value<DateTime> createdAt,
  Value<DateTime> soldAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$SalesTableTableFilterComposer
    extends Composer<_$AppDatabase, $SalesTableTable> {
  $$SalesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get discountMinorUnits => $composableBuilder(
      column: $table.discountMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get taxMinorUnits => $composableBuilder(
      column: $table.taxMinorUnits, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get soldAt => $composableBuilder(
      column: $table.soldAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$SalesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTableTable> {
  $$SalesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get discountMinorUnits => $composableBuilder(
      column: $table.discountMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get taxMinorUnits => $composableBuilder(
      column: $table.taxMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get soldAt => $composableBuilder(
      column: $table.soldAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$SalesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTableTable> {
  $$SalesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
      column: $table.invoiceNumber, builder: (column) => column);

  GeneratedColumn<int> get discountMinorUnits => $composableBuilder(
      column: $table.discountMinorUnits, builder: (column) => column);

  GeneratedColumn<int> get taxMinorUnits => $composableBuilder(
      column: $table.taxMinorUnits, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get soldAt =>
      $composableBuilder(column: $table.soldAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$SalesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SalesTableTable,
    SalesTableData,
    $$SalesTableTableFilterComposer,
    $$SalesTableTableOrderingComposer,
    $$SalesTableTableAnnotationComposer,
    $$SalesTableTableCreateCompanionBuilder,
    $$SalesTableTableUpdateCompanionBuilder,
    (
      SalesTableData,
      BaseReferences<_$AppDatabase, $SalesTableTable, SalesTableData>
    ),
    SalesTableData,
    PrefetchHooks Function()> {
  $$SalesTableTableTableManager(_$AppDatabase db, $SalesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> invoiceNumber = const Value.absent(),
            Value<int> discountMinorUnits = const Value.absent(),
            Value<int> taxMinorUnits = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> soldAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesTableCompanion(
            id: id,
            invoiceNumber: invoiceNumber,
            discountMinorUnits: discountMinorUnits,
            taxMinorUnits: taxMinorUnits,
            createdAt: createdAt,
            soldAt: soldAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String invoiceNumber,
            required int discountMinorUnits,
            required int taxMinorUnits,
            required DateTime createdAt,
            required DateTime soldAt,
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesTableCompanion.insert(
            id: id,
            invoiceNumber: invoiceNumber,
            discountMinorUnits: discountMinorUnits,
            taxMinorUnits: taxMinorUnits,
            createdAt: createdAt,
            soldAt: soldAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SalesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SalesTableTable,
    SalesTableData,
    $$SalesTableTableFilterComposer,
    $$SalesTableTableOrderingComposer,
    $$SalesTableTableAnnotationComposer,
    $$SalesTableTableCreateCompanionBuilder,
    $$SalesTableTableUpdateCompanionBuilder,
    (
      SalesTableData,
      BaseReferences<_$AppDatabase, $SalesTableTable, SalesTableData>
    ),
    SalesTableData,
    PrefetchHooks Function()>;
typedef $$SaleItemsTableTableCreateCompanionBuilder = SaleItemsTableCompanion
    Function({
  required String id,
  required String saleId,
  required String productId,
  required int quantityValue,
  Value<int> quantityScale,
  Value<String?> productName,
  Value<String?> unit,
  required int unitPriceMinorUnits,
  Value<int?> unitCostMinorUnits,
  Value<String?> unitCostCurrency,
  Value<int> rowid,
});
typedef $$SaleItemsTableTableUpdateCompanionBuilder = SaleItemsTableCompanion
    Function({
  Value<String> id,
  Value<String> saleId,
  Value<String> productId,
  Value<int> quantityValue,
  Value<int> quantityScale,
  Value<String?> productName,
  Value<String?> unit,
  Value<int> unitPriceMinorUnits,
  Value<int?> unitCostMinorUnits,
  Value<String?> unitCostCurrency,
  Value<int> rowid,
});

class $$SaleItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTableTable> {
  $$SaleItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPriceMinorUnits => $composableBuilder(
      column: $table.unitPriceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnFilters(column));
}

class $$SaleItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTableTable> {
  $$SaleItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPriceMinorUnits => $composableBuilder(
      column: $table.unitPriceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency,
      builder: (column) => ColumnOrderings(column));
}

class $$SaleItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTableTable> {
  $$SaleItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitPriceMinorUnits => $composableBuilder(
      column: $table.unitPriceMinorUnits, builder: (column) => column);

  GeneratedColumn<int> get unitCostMinorUnits => $composableBuilder(
      column: $table.unitCostMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get unitCostCurrency => $composableBuilder(
      column: $table.unitCostCurrency, builder: (column) => column);
}

class $$SaleItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SaleItemsTableTable,
    SaleItemsTableData,
    $$SaleItemsTableTableFilterComposer,
    $$SaleItemsTableTableOrderingComposer,
    $$SaleItemsTableTableAnnotationComposer,
    $$SaleItemsTableTableCreateCompanionBuilder,
    $$SaleItemsTableTableUpdateCompanionBuilder,
    (
      SaleItemsTableData,
      BaseReferences<_$AppDatabase, $SaleItemsTableTable, SaleItemsTableData>
    ),
    SaleItemsTableData,
    PrefetchHooks Function()> {
  $$SaleItemsTableTableTableManager(
      _$AppDatabase db, $SaleItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantityValue = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            Value<int> unitPriceMinorUnits = const Value.absent(),
            Value<int?> unitCostMinorUnits = const Value.absent(),
            Value<String?> unitCostCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsTableCompanion(
            id: id,
            saleId: saleId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            productName: productName,
            unit: unit,
            unitPriceMinorUnits: unitPriceMinorUnits,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String saleId,
            required String productId,
            required int quantityValue,
            Value<int> quantityScale = const Value.absent(),
            Value<String?> productName = const Value.absent(),
            Value<String?> unit = const Value.absent(),
            required int unitPriceMinorUnits,
            Value<int?> unitCostMinorUnits = const Value.absent(),
            Value<String?> unitCostCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SaleItemsTableCompanion.insert(
            id: id,
            saleId: saleId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            productName: productName,
            unit: unit,
            unitPriceMinorUnits: unitPriceMinorUnits,
            unitCostMinorUnits: unitCostMinorUnits,
            unitCostCurrency: unitCostCurrency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SaleItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SaleItemsTableTable,
    SaleItemsTableData,
    $$SaleItemsTableTableFilterComposer,
    $$SaleItemsTableTableOrderingComposer,
    $$SaleItemsTableTableAnnotationComposer,
    $$SaleItemsTableTableCreateCompanionBuilder,
    $$SaleItemsTableTableUpdateCompanionBuilder,
    (
      SaleItemsTableData,
      BaseReferences<_$AppDatabase, $SaleItemsTableTable, SaleItemsTableData>
    ),
    SaleItemsTableData,
    PrefetchHooks Function()>;
typedef $$StockMovementsTableTableCreateCompanionBuilder
    = StockMovementsTableCompanion Function({
  required String id,
  required String productId,
  required int quantityValue,
  Value<int> quantityScale,
  required String type,
  Value<String?> referenceId,
  required DateTime occurredAt,
  Value<int> rowid,
});
typedef $$StockMovementsTableTableUpdateCompanionBuilder
    = StockMovementsTableCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<int> quantityValue,
  Value<int> quantityScale,
  Value<String> type,
  Value<String?> referenceId,
  Value<DateTime> occurredAt,
  Value<int> rowid,
});

class $$StockMovementsTableTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTableTable> {
  $$StockMovementsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnFilters(column));
}

class $$StockMovementsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTableTable> {
  $$StockMovementsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => ColumnOrderings(column));
}

class $$StockMovementsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTableTable> {
  $$StockMovementsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
      column: $table.occurredAt, builder: (column) => column);
}

class $$StockMovementsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $StockMovementsTableTable,
    StockMovementsTableData,
    $$StockMovementsTableTableFilterComposer,
    $$StockMovementsTableTableOrderingComposer,
    $$StockMovementsTableTableAnnotationComposer,
    $$StockMovementsTableTableCreateCompanionBuilder,
    $$StockMovementsTableTableUpdateCompanionBuilder,
    (
      StockMovementsTableData,
      BaseReferences<_$AppDatabase, $StockMovementsTableTable,
          StockMovementsTableData>
    ),
    StockMovementsTableData,
    PrefetchHooks Function()> {
  $$StockMovementsTableTableTableManager(
      _$AppDatabase db, $StockMovementsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantityValue = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<DateTime> occurredAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              StockMovementsTableCompanion(
            id: id,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            type: type,
            referenceId: referenceId,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required int quantityValue,
            Value<int> quantityScale = const Value.absent(),
            required String type,
            Value<String?> referenceId = const Value.absent(),
            required DateTime occurredAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              StockMovementsTableCompanion.insert(
            id: id,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            type: type,
            referenceId: referenceId,
            occurredAt: occurredAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$StockMovementsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $StockMovementsTableTable,
    StockMovementsTableData,
    $$StockMovementsTableTableFilterComposer,
    $$StockMovementsTableTableOrderingComposer,
    $$StockMovementsTableTableAnnotationComposer,
    $$StockMovementsTableTableCreateCompanionBuilder,
    $$StockMovementsTableTableUpdateCompanionBuilder,
    (
      StockMovementsTableData,
      BaseReferences<_$AppDatabase, $StockMovementsTableTable,
          StockMovementsTableData>
    ),
    StockMovementsTableData,
    PrefetchHooks Function()>;
typedef $$OrdersTableTableCreateCompanionBuilder = OrdersTableCompanion
    Function({
  required String id,
  required String saleId,
  required String source,
  required String status,
  required String paymentMethod,
  required DateTime createdAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});
typedef $$OrdersTableTableUpdateCompanionBuilder = OrdersTableCompanion
    Function({
  Value<String> id,
  Value<String> saleId,
  Value<String> source,
  Value<String> status,
  Value<String> paymentMethod,
  Value<DateTime> createdAt,
  Value<bool> isSynced,
  Value<DateTime?> syncedAt,
  Value<int> rowid,
});

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnFilters(column));
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get saleId => $composableBuilder(
      column: $table.saleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSynced => $composableBuilder(
      column: $table.isSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
      column: $table.syncedAt, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
      column: $table.paymentMethod, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$OrdersTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrdersTableData,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (
      OrdersTableData,
      BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>
    ),
    OrdersTableData,
    PrefetchHooks Function()> {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> saleId = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String> paymentMethod = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersTableCompanion(
            id: id,
            saleId: saleId,
            source: source,
            status: status,
            paymentMethod: paymentMethod,
            createdAt: createdAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String saleId,
            required String source,
            required String status,
            required String paymentMethod,
            required DateTime createdAt,
            Value<bool> isSynced = const Value.absent(),
            Value<DateTime?> syncedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersTableCompanion.insert(
            id: id,
            saleId: saleId,
            source: source,
            status: status,
            paymentMethod: paymentMethod,
            createdAt: createdAt,
            isSynced: isSynced,
            syncedAt: syncedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrdersTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTableTable,
    OrdersTableData,
    $$OrdersTableTableFilterComposer,
    $$OrdersTableTableOrderingComposer,
    $$OrdersTableTableAnnotationComposer,
    $$OrdersTableTableCreateCompanionBuilder,
    $$OrdersTableTableUpdateCompanionBuilder,
    (
      OrdersTableData,
      BaseReferences<_$AppDatabase, $OrdersTableTable, OrdersTableData>
    ),
    OrdersTableData,
    PrefetchHooks Function()>;
typedef $$OrderItemsTableTableCreateCompanionBuilder = OrderItemsTableCompanion
    Function({
  required String id,
  required String orderId,
  required String productId,
  required int quantityValue,
  Value<int> quantityScale,
  required String productName,
  required String unit,
  required int unitPriceMinorUnits,
  Value<String> unitPriceCurrency,
  Value<int> rowid,
});
typedef $$OrderItemsTableTableUpdateCompanionBuilder = OrderItemsTableCompanion
    Function({
  Value<String> id,
  Value<String> orderId,
  Value<String> productId,
  Value<int> quantityValue,
  Value<int> quantityScale,
  Value<String> productName,
  Value<String> unit,
  Value<int> unitPriceMinorUnits,
  Value<String> unitPriceCurrency,
  Value<int> rowid,
});

class $$OrderItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitPriceMinorUnits => $composableBuilder(
      column: $table.unitPriceMinorUnits,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get unitPriceCurrency => $composableBuilder(
      column: $table.unitPriceCurrency,
      builder: (column) => ColumnFilters(column));
}

class $$OrderItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderId => $composableBuilder(
      column: $table.orderId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unit => $composableBuilder(
      column: $table.unit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitPriceMinorUnits => $composableBuilder(
      column: $table.unitPriceMinorUnits,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get unitPriceCurrency => $composableBuilder(
      column: $table.unitPriceCurrency,
      builder: (column) => ColumnOrderings(column));
}

class $$OrderItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTableTable> {
  $$OrderItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderId =>
      $composableBuilder(column: $table.orderId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
      column: $table.productName, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get unitPriceMinorUnits => $composableBuilder(
      column: $table.unitPriceMinorUnits, builder: (column) => column);

  GeneratedColumn<String> get unitPriceCurrency => $composableBuilder(
      column: $table.unitPriceCurrency, builder: (column) => column);
}

class $$OrderItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTableTable,
    OrderItemsTableData,
    $$OrderItemsTableTableFilterComposer,
    $$OrderItemsTableTableOrderingComposer,
    $$OrderItemsTableTableAnnotationComposer,
    $$OrderItemsTableTableCreateCompanionBuilder,
    $$OrderItemsTableTableUpdateCompanionBuilder,
    (
      OrderItemsTableData,
      BaseReferences<_$AppDatabase, $OrderItemsTableTable, OrderItemsTableData>
    ),
    OrderItemsTableData,
    PrefetchHooks Function()> {
  $$OrderItemsTableTableTableManager(
      _$AppDatabase db, $OrderItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orderId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantityValue = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<String> productName = const Value.absent(),
            Value<String> unit = const Value.absent(),
            Value<int> unitPriceMinorUnits = const Value.absent(),
            Value<String> unitPriceCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrderItemsTableCompanion(
            id: id,
            orderId: orderId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            productName: productName,
            unit: unit,
            unitPriceMinorUnits: unitPriceMinorUnits,
            unitPriceCurrency: unitPriceCurrency,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String orderId,
            required String productId,
            required int quantityValue,
            Value<int> quantityScale = const Value.absent(),
            required String productName,
            required String unit,
            required int unitPriceMinorUnits,
            Value<String> unitPriceCurrency = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrderItemsTableCompanion.insert(
            id: id,
            orderId: orderId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            productName: productName,
            unit: unit,
            unitPriceMinorUnits: unitPriceMinorUnits,
            unitPriceCurrency: unitPriceCurrency,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$OrderItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTableTable,
    OrderItemsTableData,
    $$OrderItemsTableTableFilterComposer,
    $$OrderItemsTableTableOrderingComposer,
    $$OrderItemsTableTableAnnotationComposer,
    $$OrderItemsTableTableCreateCompanionBuilder,
    $$OrderItemsTableTableUpdateCompanionBuilder,
    (
      OrderItemsTableData,
      BaseReferences<_$AppDatabase, $OrderItemsTableTable, OrderItemsTableData>
    ),
    OrderItemsTableData,
    PrefetchHooks Function()>;
typedef $$RecipesTableTableCreateCompanionBuilder = RecipesTableCompanion
    Function({
  required String id,
  required String name,
  required int expectedOutputValue,
  Value<int> expectedOutputScale,
  Value<String?> outputProductId,
  Value<int> rowid,
});
typedef $$RecipesTableTableUpdateCompanionBuilder = RecipesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<int> expectedOutputValue,
  Value<int> expectedOutputScale,
  Value<String?> outputProductId,
  Value<int> rowid,
});

class $$RecipesTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedOutputValue => $composableBuilder(
      column: $table.expectedOutputValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get expectedOutputScale => $composableBuilder(
      column: $table.expectedOutputScale,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get outputProductId => $composableBuilder(
      column: $table.outputProductId,
      builder: (column) => ColumnFilters(column));
}

class $$RecipesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedOutputValue => $composableBuilder(
      column: $table.expectedOutputValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get expectedOutputScale => $composableBuilder(
      column: $table.expectedOutputScale,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get outputProductId => $composableBuilder(
      column: $table.outputProductId,
      builder: (column) => ColumnOrderings(column));
}

class $$RecipesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTableTable> {
  $$RecipesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get expectedOutputValue => $composableBuilder(
      column: $table.expectedOutputValue, builder: (column) => column);

  GeneratedColumn<int> get expectedOutputScale => $composableBuilder(
      column: $table.expectedOutputScale, builder: (column) => column);

  GeneratedColumn<String> get outputProductId => $composableBuilder(
      column: $table.outputProductId, builder: (column) => column);
}

class $$RecipesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipesTableTable,
    RecipesTableData,
    $$RecipesTableTableFilterComposer,
    $$RecipesTableTableOrderingComposer,
    $$RecipesTableTableAnnotationComposer,
    $$RecipesTableTableCreateCompanionBuilder,
    $$RecipesTableTableUpdateCompanionBuilder,
    (
      RecipesTableData,
      BaseReferences<_$AppDatabase, $RecipesTableTable, RecipesTableData>
    ),
    RecipesTableData,
    PrefetchHooks Function()> {
  $$RecipesTableTableTableManager(_$AppDatabase db, $RecipesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<int> expectedOutputValue = const Value.absent(),
            Value<int> expectedOutputScale = const Value.absent(),
            Value<String?> outputProductId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesTableCompanion(
            id: id,
            name: name,
            expectedOutputValue: expectedOutputValue,
            expectedOutputScale: expectedOutputScale,
            outputProductId: outputProductId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required int expectedOutputValue,
            Value<int> expectedOutputScale = const Value.absent(),
            Value<String?> outputProductId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipesTableCompanion.insert(
            id: id,
            name: name,
            expectedOutputValue: expectedOutputValue,
            expectedOutputScale: expectedOutputScale,
            outputProductId: outputProductId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipesTableTable,
    RecipesTableData,
    $$RecipesTableTableFilterComposer,
    $$RecipesTableTableOrderingComposer,
    $$RecipesTableTableAnnotationComposer,
    $$RecipesTableTableCreateCompanionBuilder,
    $$RecipesTableTableUpdateCompanionBuilder,
    (
      RecipesTableData,
      BaseReferences<_$AppDatabase, $RecipesTableTable, RecipesTableData>
    ),
    RecipesTableData,
    PrefetchHooks Function()>;
typedef $$RecipeItemsTableTableCreateCompanionBuilder
    = RecipeItemsTableCompanion Function({
  required String id,
  required String recipeId,
  required String productId,
  required int quantityValue,
  Value<int> quantityScale,
  Value<int> rowid,
});
typedef $$RecipeItemsTableTableUpdateCompanionBuilder
    = RecipeItemsTableCompanion Function({
  Value<String> id,
  Value<String> recipeId,
  Value<String> productId,
  Value<int> quantityValue,
  Value<int> quantityScale,
  Value<int> rowid,
});

class $$RecipeItemsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeItemsTableTable> {
  $$RecipeItemsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => ColumnFilters(column));
}

class $$RecipeItemsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeItemsTableTable> {
  $$RecipeItemsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipeId => $composableBuilder(
      column: $table.recipeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale,
      builder: (column) => ColumnOrderings(column));
}

class $$RecipeItemsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeItemsTableTable> {
  $$RecipeItemsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantityValue => $composableBuilder(
      column: $table.quantityValue, builder: (column) => column);

  GeneratedColumn<int> get quantityScale => $composableBuilder(
      column: $table.quantityScale, builder: (column) => column);
}

class $$RecipeItemsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $RecipeItemsTableTable,
    RecipeItemsTableData,
    $$RecipeItemsTableTableFilterComposer,
    $$RecipeItemsTableTableOrderingComposer,
    $$RecipeItemsTableTableAnnotationComposer,
    $$RecipeItemsTableTableCreateCompanionBuilder,
    $$RecipeItemsTableTableUpdateCompanionBuilder,
    (
      RecipeItemsTableData,
      BaseReferences<_$AppDatabase, $RecipeItemsTableTable,
          RecipeItemsTableData>
    ),
    RecipeItemsTableData,
    PrefetchHooks Function()> {
  $$RecipeItemsTableTableTableManager(
      _$AppDatabase db, $RecipeItemsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeItemsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeItemsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeItemsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> recipeId = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<int> quantityValue = const Value.absent(),
            Value<int> quantityScale = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeItemsTableCompanion(
            id: id,
            recipeId: recipeId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String recipeId,
            required String productId,
            required int quantityValue,
            Value<int> quantityScale = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              RecipeItemsTableCompanion.insert(
            id: id,
            recipeId: recipeId,
            productId: productId,
            quantityValue: quantityValue,
            quantityScale: quantityScale,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$RecipeItemsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $RecipeItemsTableTable,
    RecipeItemsTableData,
    $$RecipeItemsTableTableFilterComposer,
    $$RecipeItemsTableTableOrderingComposer,
    $$RecipeItemsTableTableAnnotationComposer,
    $$RecipeItemsTableTableCreateCompanionBuilder,
    $$RecipeItemsTableTableUpdateCompanionBuilder,
    (
      RecipeItemsTableData,
      BaseReferences<_$AppDatabase, $RecipeItemsTableTable,
          RecipeItemsTableData>
    ),
    RecipeItemsTableData,
    PrefetchHooks Function()>;
typedef $$ProductPackagingsTableTableCreateCompanionBuilder
    = ProductPackagingsTableCompanion Function({
  required String id,
  required String productId,
  required String fromUnit,
  required String toUnit,
  required int multiplierValue,
  required int divisorValue,
  Value<int> rowid,
});
typedef $$ProductPackagingsTableTableUpdateCompanionBuilder
    = ProductPackagingsTableCompanion Function({
  Value<String> id,
  Value<String> productId,
  Value<String> fromUnit,
  Value<String> toUnit,
  Value<int> multiplierValue,
  Value<int> divisorValue,
  Value<int> rowid,
});

class $$ProductPackagingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductPackagingsTableTable> {
  $$ProductPackagingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fromUnit => $composableBuilder(
      column: $table.fromUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get toUnit => $composableBuilder(
      column: $table.toUnit, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get multiplierValue => $composableBuilder(
      column: $table.multiplierValue,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get divisorValue => $composableBuilder(
      column: $table.divisorValue, builder: (column) => ColumnFilters(column));
}

class $$ProductPackagingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductPackagingsTableTable> {
  $$ProductPackagingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get productId => $composableBuilder(
      column: $table.productId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fromUnit => $composableBuilder(
      column: $table.fromUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get toUnit => $composableBuilder(
      column: $table.toUnit, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get multiplierValue => $composableBuilder(
      column: $table.multiplierValue,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get divisorValue => $composableBuilder(
      column: $table.divisorValue,
      builder: (column) => ColumnOrderings(column));
}

class $$ProductPackagingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductPackagingsTableTable> {
  $$ProductPackagingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get fromUnit =>
      $composableBuilder(column: $table.fromUnit, builder: (column) => column);

  GeneratedColumn<String> get toUnit =>
      $composableBuilder(column: $table.toUnit, builder: (column) => column);

  GeneratedColumn<int> get multiplierValue => $composableBuilder(
      column: $table.multiplierValue, builder: (column) => column);

  GeneratedColumn<int> get divisorValue => $composableBuilder(
      column: $table.divisorValue, builder: (column) => column);
}

class $$ProductPackagingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProductPackagingsTableTable,
    ProductPackagingsTableData,
    $$ProductPackagingsTableTableFilterComposer,
    $$ProductPackagingsTableTableOrderingComposer,
    $$ProductPackagingsTableTableAnnotationComposer,
    $$ProductPackagingsTableTableCreateCompanionBuilder,
    $$ProductPackagingsTableTableUpdateCompanionBuilder,
    (
      ProductPackagingsTableData,
      BaseReferences<_$AppDatabase, $ProductPackagingsTableTable,
          ProductPackagingsTableData>
    ),
    ProductPackagingsTableData,
    PrefetchHooks Function()> {
  $$ProductPackagingsTableTableTableManager(
      _$AppDatabase db, $ProductPackagingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductPackagingsTableTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductPackagingsTableTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductPackagingsTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> productId = const Value.absent(),
            Value<String> fromUnit = const Value.absent(),
            Value<String> toUnit = const Value.absent(),
            Value<int> multiplierValue = const Value.absent(),
            Value<int> divisorValue = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductPackagingsTableCompanion(
            id: id,
            productId: productId,
            fromUnit: fromUnit,
            toUnit: toUnit,
            multiplierValue: multiplierValue,
            divisorValue: divisorValue,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String productId,
            required String fromUnit,
            required String toUnit,
            required int multiplierValue,
            required int divisorValue,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProductPackagingsTableCompanion.insert(
            id: id,
            productId: productId,
            fromUnit: fromUnit,
            toUnit: toUnit,
            multiplierValue: multiplierValue,
            divisorValue: divisorValue,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProductPackagingsTableTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $ProductPackagingsTableTable,
        ProductPackagingsTableData,
        $$ProductPackagingsTableTableFilterComposer,
        $$ProductPackagingsTableTableOrderingComposer,
        $$ProductPackagingsTableTableAnnotationComposer,
        $$ProductPackagingsTableTableCreateCompanionBuilder,
        $$ProductPackagingsTableTableUpdateCompanionBuilder,
        (
          ProductPackagingsTableData,
          BaseReferences<_$AppDatabase, $ProductPackagingsTableTable,
              ProductPackagingsTableData>
        ),
        ProductPackagingsTableData,
        PrefetchHooks Function()>;
typedef $$SyncQueueTableTableCreateCompanionBuilder = SyncQueueTableCompanion
    Function({
  required String id,
  required String endpoint,
  Value<String> sourceTable,
  Value<String?> referenceId,
  required String payloadJson,
  required String status,
  Value<int> retryCount,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$SyncQueueTableTableUpdateCompanionBuilder = SyncQueueTableCompanion
    Function({
  Value<String> id,
  Value<String> endpoint,
  Value<String> sourceTable,
  Value<String?> referenceId,
  Value<String> payloadJson,
  Value<String> status,
  Value<int> retryCount,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$SyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceTable => $composableBuilder(
      column: $table.sourceTable, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get endpoint => $composableBuilder(
      column: $table.endpoint, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceTable => $composableBuilder(
      column: $table.sourceTable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTableTable> {
  $$SyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get endpoint =>
      $composableBuilder(column: $table.endpoint, builder: (column) => column);

  GeneratedColumn<String> get sourceTable => $composableBuilder(
      column: $table.sourceTable, builder: (column) => column);

  GeneratedColumn<String> get referenceId => $composableBuilder(
      column: $table.referenceId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
      column: $table.payloadJson, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
      column: $table.retryCount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SyncQueueTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()> {
  $$SyncQueueTableTableTableManager(
      _$AppDatabase db, $SyncQueueTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> endpoint = const Value.absent(),
            Value<String> sourceTable = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<int> retryCount = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion(
            id: id,
            endpoint: endpoint,
            sourceTable: sourceTable,
            referenceId: referenceId,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String endpoint,
            Value<String> sourceTable = const Value.absent(),
            Value<String?> referenceId = const Value.absent(),
            required String payloadJson,
            required String status,
            Value<int> retryCount = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SyncQueueTableCompanion.insert(
            id: id,
            endpoint: endpoint,
            sourceTable: sourceTable,
            referenceId: referenceId,
            payloadJson: payloadJson,
            status: status,
            retryCount: retryCount,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SyncQueueTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SyncQueueTableTable,
    SyncQueueTableData,
    $$SyncQueueTableTableFilterComposer,
    $$SyncQueueTableTableOrderingComposer,
    $$SyncQueueTableTableAnnotationComposer,
    $$SyncQueueTableTableCreateCompanionBuilder,
    $$SyncQueueTableTableUpdateCompanionBuilder,
    (
      SyncQueueTableData,
      BaseReferences<_$AppDatabase, $SyncQueueTableTable, SyncQueueTableData>
    ),
    SyncQueueTableData,
    PrefetchHooks Function()>;
typedef $$UomsTableTableCreateCompanionBuilder = UomsTableCompanion Function({
  required String id,
  required String name,
  required String symbol,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$UomsTableTableUpdateCompanionBuilder = UomsTableCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> symbol,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$UomsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UomsTableTable> {
  $$UomsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$UomsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UomsTableTable> {
  $$UomsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$UomsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UomsTableTable> {
  $$UomsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UomsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UomsTableTable,
    UomsTableData,
    $$UomsTableTableFilterComposer,
    $$UomsTableTableOrderingComposer,
    $$UomsTableTableAnnotationComposer,
    $$UomsTableTableCreateCompanionBuilder,
    $$UomsTableTableUpdateCompanionBuilder,
    (
      UomsTableData,
      BaseReferences<_$AppDatabase, $UomsTableTable, UomsTableData>
    ),
    UomsTableData,
    PrefetchHooks Function()> {
  $$UomsTableTableTableManager(_$AppDatabase db, $UomsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UomsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UomsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UomsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              UomsTableCompanion(
            id: id,
            name: name,
            symbol: symbol,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String symbol,
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              UomsTableCompanion.insert(
            id: id,
            name: name,
            symbol: symbol,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UomsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UomsTableTable,
    UomsTableData,
    $$UomsTableTableFilterComposer,
    $$UomsTableTableOrderingComposer,
    $$UomsTableTableAnnotationComposer,
    $$UomsTableTableCreateCompanionBuilder,
    $$UomsTableTableUpdateCompanionBuilder,
    (
      UomsTableData,
      BaseReferences<_$AppDatabase, $UomsTableTable, UomsTableData>
    ),
    UomsTableData,
    PrefetchHooks Function()>;
typedef $$CategoriesTableTableCreateCompanionBuilder = CategoriesTableCompanion
    Function({
  required String id,
  required String name,
  Value<bool> isActive,
  required DateTime createdAt,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$CategoriesTableTableUpdateCompanionBuilder = CategoriesTableCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<bool> isActive,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isActive => $composableBuilder(
      column: $table.isActive, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CategoriesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()> {
  $$CategoriesTableTableTableManager(
      _$AppDatabase db, $CategoriesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<bool> isActive = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<bool> isActive = const Value.absent(),
            required DateTime createdAt,
            required DateTime updatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoriesTableCompanion.insert(
            id: id,
            name: name,
            isActive: isActive,
            createdAt: createdAt,
            updatedAt: updatedAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoriesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CategoriesTableTable,
    CategoriesTableData,
    $$CategoriesTableTableFilterComposer,
    $$CategoriesTableTableOrderingComposer,
    $$CategoriesTableTableAnnotationComposer,
    $$CategoriesTableTableCreateCompanionBuilder,
    $$CategoriesTableTableUpdateCompanionBuilder,
    (
      CategoriesTableData,
      BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoriesTableData>
    ),
    CategoriesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$CustomersTableTableTableManager get customersTable =>
      $$CustomersTableTableTableManager(_db, _db.customersTable);
  $$CostLayersTableTableTableManager get costLayersTable =>
      $$CostLayersTableTableTableManager(_db, _db.costLayersTable);
  $$ReceivingsTableTableTableManager get receivingsTable =>
      $$ReceivingsTableTableTableManager(_db, _db.receivingsTable);
  $$ReceivingItemsTableTableTableManager get receivingItemsTable =>
      $$ReceivingItemsTableTableTableManager(_db, _db.receivingItemsTable);
  $$PurchasesTableTableTableManager get purchasesTable =>
      $$PurchasesTableTableTableManager(_db, _db.purchasesTable);
  $$PurchaseItemsTableTableTableManager get purchaseItemsTable =>
      $$PurchaseItemsTableTableTableManager(_db, _db.purchaseItemsTable);
  $$SalesTableTableTableManager get salesTable =>
      $$SalesTableTableTableManager(_db, _db.salesTable);
  $$SaleItemsTableTableTableManager get saleItemsTable =>
      $$SaleItemsTableTableTableManager(_db, _db.saleItemsTable);
  $$StockMovementsTableTableTableManager get stockMovementsTable =>
      $$StockMovementsTableTableTableManager(_db, _db.stockMovementsTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$OrderItemsTableTableTableManager get orderItemsTable =>
      $$OrderItemsTableTableTableManager(_db, _db.orderItemsTable);
  $$RecipesTableTableTableManager get recipesTable =>
      $$RecipesTableTableTableManager(_db, _db.recipesTable);
  $$RecipeItemsTableTableTableManager get recipeItemsTable =>
      $$RecipeItemsTableTableTableManager(_db, _db.recipeItemsTable);
  $$ProductPackagingsTableTableTableManager get productPackagingsTable =>
      $$ProductPackagingsTableTableTableManager(
          _db, _db.productPackagingsTable);
  $$SyncQueueTableTableTableManager get syncQueueTable =>
      $$SyncQueueTableTableTableManager(_db, _db.syncQueueTable);
  $$UomsTableTableTableManager get uomsTable =>
      $$UomsTableTableTableManager(_db, _db.uomsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
}
