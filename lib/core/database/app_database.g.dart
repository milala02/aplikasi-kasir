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
        active
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
  const ProductsTableData(
      {required this.id,
      required this.sku,
      required this.name,
      required this.baseUnit,
      required this.purchasePriceMinorUnits,
      required this.purchasePriceCurrency,
      required this.sellingPriceMinorUnits,
      required this.sellingPriceCurrency,
      required this.active});
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
          bool? active}) =>
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
          ..write('active: $active')
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
      active);
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
          other.active == this.active);
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, phoneNumber, address, notes, createdAt];
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
  const CustomersTableData(
      {required this.id,
      required this.name,
      required this.phoneNumber,
      this.address,
      this.notes,
      required this.createdAt});
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
    };
  }

  CustomersTableData copyWith(
          {String? id,
          String? name,
          String? phoneNumber,
          Value<String?> address = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          DateTime? createdAt}) =>
      CustomersTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        address: address.present ? address.value : this.address,
        notes: notes.present ? notes.value : this.notes,
        createdAt: createdAt ?? this.createdAt,
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
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phoneNumber, address, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomersTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.address == this.address &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CustomersTableCompanion extends UpdateCompanion<CustomersTableData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> phoneNumber;
  final Value<String?> address;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CustomersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersTableCompanion.insert({
    required String id,
    required String name,
    required String phoneNumber,
    this.address = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
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
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (address != null) 'address': address,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
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
      Value<int>? rowid}) {
    return CustomersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      notes: notes ?? this.notes,
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
  @override
  List<GeneratedColumn> get $columns => [id, purchaseId, receivedAt];
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
  const ReceivingsTableData(
      {required this.id, required this.purchaseId, required this.receivedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['received_at'] = Variable<DateTime>(receivedAt);
    return map;
  }

  ReceivingsTableCompanion toCompanion(bool nullToAbsent) {
    return ReceivingsTableCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      receivedAt: Value(receivedAt),
    );
  }

  factory ReceivingsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReceivingsTableData(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      receivedAt: serializer.fromJson<DateTime>(json['receivedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'receivedAt': serializer.toJson<DateTime>(receivedAt),
    };
  }

  ReceivingsTableData copyWith(
          {String? id, String? purchaseId, DateTime? receivedAt}) =>
      ReceivingsTableData(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        receivedAt: receivedAt ?? this.receivedAt,
      );
  ReceivingsTableData copyWithCompanion(ReceivingsTableCompanion data) {
    return ReceivingsTableData(
      id: data.id.present ? data.id.value : this.id,
      purchaseId:
          data.purchaseId.present ? data.purchaseId.value : this.purchaseId,
      receivedAt:
          data.receivedAt.present ? data.receivedAt.value : this.receivedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReceivingsTableData(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('receivedAt: $receivedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseId, receivedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceivingsTableData &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.receivedAt == this.receivedAt);
}

class ReceivingsTableCompanion extends UpdateCompanion<ReceivingsTableData> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<DateTime> receivedAt;
  final Value<int> rowid;
  const ReceivingsTableCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.receivedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReceivingsTableCompanion.insert({
    required String id,
    required String purchaseId,
    required DateTime receivedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchaseId = Value(purchaseId),
        receivedAt = Value(receivedAt);
  static Insertable<ReceivingsTableData> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<DateTime>? receivedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (receivedAt != null) 'received_at': receivedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReceivingsTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? purchaseId,
      Value<DateTime>? receivedAt,
      Value<int>? rowid}) {
    return ReceivingsTableCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      receivedAt: receivedAt ?? this.receivedAt,
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
  final int unitCostMinorUnits;
  final String unitCostCurrency;
  const ReceivingItemsTableData(
      {required this.id,
      required this.receivingId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
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
          int? unitCostMinorUnits,
          String? unitCostCurrency}) =>
      ReceivingItemsTableData(
        id: id ?? this.id,
        receivingId: receivingId ?? this.receivingId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
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
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, receivingId, productId, quantityValue,
      quantityScale, unitCostMinorUnits, unitCostCurrency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReceivingItemsTableData &&
          other.id == this.id &&
          other.receivingId == this.receivingId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
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
  final Value<int> unitCostMinorUnits;
  final Value<String> unitCostCurrency;
  final Value<int> rowid;
  const ReceivingItemsTableCompanion({
    this.id = const Value.absent(),
    this.receivingId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
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
      Value<int>? unitCostMinorUnits,
      Value<String>? unitCostCurrency,
      Value<int>? rowid}) {
    return ReceivingItemsTableCompanion(
      id: id ?? this.id,
      receivingId: receivingId ?? this.receivingId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, purchasedAt, supplierId, referenceNumber];
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
  const PurchasesTableData(
      {required this.id,
      required this.purchasedAt,
      this.supplierId,
      this.referenceNumber});
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
    };
  }

  PurchasesTableData copyWith(
          {String? id,
          DateTime? purchasedAt,
          Value<String?> supplierId = const Value.absent(),
          Value<String?> referenceNumber = const Value.absent()}) =>
      PurchasesTableData(
        id: id ?? this.id,
        purchasedAt: purchasedAt ?? this.purchasedAt,
        supplierId: supplierId.present ? supplierId.value : this.supplierId,
        referenceNumber: referenceNumber.present
            ? referenceNumber.value
            : this.referenceNumber,
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
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchasesTableData(')
          ..write('id: $id, ')
          ..write('purchasedAt: $purchasedAt, ')
          ..write('supplierId: $supplierId, ')
          ..write('referenceNumber: $referenceNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchasedAt, supplierId, referenceNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchasesTableData &&
          other.id == this.id &&
          other.purchasedAt == this.purchasedAt &&
          other.supplierId == this.supplierId &&
          other.referenceNumber == this.referenceNumber);
}

class PurchasesTableCompanion extends UpdateCompanion<PurchasesTableData> {
  final Value<String> id;
  final Value<DateTime> purchasedAt;
  final Value<String?> supplierId;
  final Value<String?> referenceNumber;
  final Value<int> rowid;
  const PurchasesTableCompanion({
    this.id = const Value.absent(),
    this.purchasedAt = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchasesTableCompanion.insert({
    required String id,
    required DateTime purchasedAt,
    this.supplierId = const Value.absent(),
    this.referenceNumber = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        purchasedAt = Value(purchasedAt);
  static Insertable<PurchasesTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? purchasedAt,
    Expression<String>? supplierId,
    Expression<String>? referenceNumber,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (supplierId != null) 'supplier_id': supplierId,
      if (referenceNumber != null) 'reference_number': referenceNumber,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchasesTableCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? purchasedAt,
      Value<String?>? supplierId,
      Value<String?>? referenceNumber,
      Value<int>? rowid}) {
    return PurchasesTableCompanion(
      id: id ?? this.id,
      purchasedAt: purchasedAt ?? this.purchasedAt,
      supplierId: supplierId ?? this.supplierId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
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
  final int unitCostMinorUnits;
  final String unitCostCurrency;
  const PurchaseItemsTableData(
      {required this.id,
      required this.purchaseId,
      required this.productId,
      required this.quantityValue,
      required this.quantityScale,
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
          int? unitCostMinorUnits,
          String? unitCostCurrency}) =>
      PurchaseItemsTableData(
        id: id ?? this.id,
        purchaseId: purchaseId ?? this.purchaseId,
        productId: productId ?? this.productId,
        quantityValue: quantityValue ?? this.quantityValue,
        quantityScale: quantityScale ?? this.quantityScale,
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
          ..write('unitCostMinorUnits: $unitCostMinorUnits, ')
          ..write('unitCostCurrency: $unitCostCurrency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, purchaseId, productId, quantityValue,
      quantityScale, unitCostMinorUnits, unitCostCurrency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseItemsTableData &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.productId == this.productId &&
          other.quantityValue == this.quantityValue &&
          other.quantityScale == this.quantityScale &&
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
  final Value<int> unitCostMinorUnits;
  final Value<String> unitCostCurrency;
  final Value<int> rowid;
  const PurchaseItemsTableCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantityValue = const Value.absent(),
    this.quantityScale = const Value.absent(),
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
      Value<int>? unitCostMinorUnits,
      Value<String>? unitCostCurrency,
      Value<int>? rowid}) {
    return PurchaseItemsTableCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      productId: productId ?? this.productId,
      quantityValue: quantityValue ?? this.quantityValue,
      quantityScale: quantityScale ?? this.quantityScale,
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, invoiceNumber, discountMinorUnits, taxMinorUnits, createdAt, soldAt];
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
  const SalesTableData(
      {required this.id,
      required this.invoiceNumber,
      required this.discountMinorUnits,
      required this.taxMinorUnits,
      required this.createdAt,
      required this.soldAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    map['discount_minor_units'] = Variable<int>(discountMinorUnits);
    map['tax_minor_units'] = Variable<int>(taxMinorUnits);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sold_at'] = Variable<DateTime>(soldAt);
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
    };
  }

  SalesTableData copyWith(
          {String? id,
          String? invoiceNumber,
          int? discountMinorUnits,
          int? taxMinorUnits,
          DateTime? createdAt,
          DateTime? soldAt}) =>
      SalesTableData(
        id: id ?? this.id,
        invoiceNumber: invoiceNumber ?? this.invoiceNumber,
        discountMinorUnits: discountMinorUnits ?? this.discountMinorUnits,
        taxMinorUnits: taxMinorUnits ?? this.taxMinorUnits,
        createdAt: createdAt ?? this.createdAt,
        soldAt: soldAt ?? this.soldAt,
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
          ..write('soldAt: $soldAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, invoiceNumber, discountMinorUnits, taxMinorUnits, createdAt, soldAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesTableData &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.discountMinorUnits == this.discountMinorUnits &&
          other.taxMinorUnits == this.taxMinorUnits &&
          other.createdAt == this.createdAt &&
          other.soldAt == this.soldAt);
}

class SalesTableCompanion extends UpdateCompanion<SalesTableData> {
  final Value<String> id;
  final Value<String> invoiceNumber;
  final Value<int> discountMinorUnits;
  final Value<int> taxMinorUnits;
  final Value<DateTime> createdAt;
  final Value<DateTime> soldAt;
  final Value<int> rowid;
  const SalesTableCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.discountMinorUnits = const Value.absent(),
    this.taxMinorUnits = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.soldAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesTableCompanion.insert({
    required String id,
    required String invoiceNumber,
    required int discountMinorUnits,
    required int taxMinorUnits,
    required DateTime createdAt,
    required DateTime soldAt,
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
      Value<int>? rowid}) {
    return SalesTableCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      discountMinorUnits: discountMinorUnits ?? this.discountMinorUnits,
      taxMinorUnits: taxMinorUnits ?? this.taxMinorUnits,
      createdAt: createdAt ?? this.createdAt,
      soldAt: soldAt ?? this.soldAt,
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
        stockMovementsTable
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
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersTableCompanion(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            address: address,
            notes: notes,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String phoneNumber,
            Value<String?> address = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              CustomersTableCompanion.insert(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            address: address,
            notes: notes,
            createdAt: createdAt,
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
  Value<int> rowid,
});
typedef $$ReceivingsTableTableUpdateCompanionBuilder = ReceivingsTableCompanion
    Function({
  Value<String> id,
  Value<String> purchaseId,
  Value<DateTime> receivedAt,
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
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceivingsTableCompanion(
            id: id,
            purchaseId: purchaseId,
            receivedAt: receivedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String purchaseId,
            required DateTime receivedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              ReceivingsTableCompanion.insert(
            id: id,
            purchaseId: purchaseId,
            receivedAt: receivedAt,
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
  Value<int> rowid,
});
typedef $$PurchasesTableTableUpdateCompanionBuilder = PurchasesTableCompanion
    Function({
  Value<String> id,
  Value<DateTime> purchasedAt,
  Value<String?> supplierId,
  Value<String?> referenceNumber,
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
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesTableCompanion(
            id: id,
            purchasedAt: purchasedAt,
            supplierId: supplierId,
            referenceNumber: referenceNumber,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime purchasedAt,
            Value<String?> supplierId = const Value.absent(),
            Value<String?> referenceNumber = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              PurchasesTableCompanion.insert(
            id: id,
            purchasedAt: purchasedAt,
            supplierId: supplierId,
            referenceNumber: referenceNumber,
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
  Value<int> rowid,
});
typedef $$SalesTableTableUpdateCompanionBuilder = SalesTableCompanion Function({
  Value<String> id,
  Value<String> invoiceNumber,
  Value<int> discountMinorUnits,
  Value<int> taxMinorUnits,
  Value<DateTime> createdAt,
  Value<DateTime> soldAt,
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
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesTableCompanion(
            id: id,
            invoiceNumber: invoiceNumber,
            discountMinorUnits: discountMinorUnits,
            taxMinorUnits: taxMinorUnits,
            createdAt: createdAt,
            soldAt: soldAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String invoiceNumber,
            required int discountMinorUnits,
            required int taxMinorUnits,
            required DateTime createdAt,
            required DateTime soldAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              SalesTableCompanion.insert(
            id: id,
            invoiceNumber: invoiceNumber,
            discountMinorUnits: discountMinorUnits,
            taxMinorUnits: taxMinorUnits,
            createdAt: createdAt,
            soldAt: soldAt,
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
}
