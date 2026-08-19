import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// 1. Tabel Products
class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text()();
  TextColumn get name => text()();
  TextColumn get baseUnit => text()();
  IntColumn get purchasePriceMinorUnits => integer()();
  TextColumn get purchasePriceCurrency => text().withDefault(const Constant('IDR'))();
  IntColumn get sellingPriceMinorUnits => integer()();
  TextColumn get sellingPriceCurrency => text().withDefault(const Constant('IDR'))();
  BoolColumn get active => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Tabel Customers
class CustomersTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Tabel CostLayers (Inventory FIFO)
class CostLayersTable extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  IntColumn get originalQuantityValue => integer()();
  IntColumn get originalQuantityScale => integer()();
  IntColumn get remainingQuantityValue => integer()();
  IntColumn get remainingQuantityScale => integer()();
  IntColumn get unitCostMinorUnits => integer()();
  TextColumn get unitCostCurrency => text().withDefault(const Constant('IDR'))();
  DateTimeColumn get acquiredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [ProductsTable, CustomersTable, CostLayersTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'aplikasi_kasir.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
