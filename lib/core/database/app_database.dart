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
  TextColumn get purchasePriceCurrency =>
      text().withDefault(const Constant('IDR'))();
  IntColumn get sellingPriceMinorUnits => integer()();
  TextColumn get sellingPriceCurrency =>
      text().withDefault(const Constant('IDR'))();
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
  TextColumn get unitCostCurrency =>
      text().withDefault(const Constant('IDR'))();
  TextColumn get purchaseId => text().nullable()();
  DateTimeColumn get acquiredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Tabel Receivings (Penerimaan Barang)
class ReceivingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text()();
  DateTimeColumn get receivedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Tabel ReceivingItems (Item Penerimaan Barang)
class ReceivingItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get receivingId => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(0))();
  IntColumn get unitCostMinorUnits => integer()();
  TextColumn get unitCostCurrency =>
      text().withDefault(const Constant('IDR'))();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Tabel Purchases (Pesanan Pembelian / PO)
class PurchasesTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get purchasedAt => dateTime()();
  TextColumn get supplierId => text().nullable()();
  TextColumn get referenceNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// 7. Tabel PurchaseItems (Item Pesanan Pembelian)
class PurchaseItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(0))();
  IntColumn get unitCostMinorUnits => integer()();
  TextColumn get unitCostCurrency =>
      text().withDefault(const Constant('IDR'))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- TABEL PENJUALAN ---
class SalesTable extends Table {
  TextColumn get id => text()();
  TextColumn get invoiceNumber => text().unique()();
  IntColumn get discountMinorUnits => integer()();
  IntColumn get taxMinorUnits => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get soldAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class SaleItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get unitPriceMinorUnits => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- TABEL INVENTARIS / PERGERAKAN STOK ---
class StockMovementsTable extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(0))();
  TextColumn get type => text()(); // 'in', 'out', 'adjustment'
  TextColumn get referenceId => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  ProductsTable,
  CustomersTable,
  CostLayersTable,
  ReceivingsTable,
  ReceivingItemsTable,
  PurchasesTable,
  PurchaseItemsTable,
  SalesTable,
  SaleItemsTable,
  StockMovementsTable
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(
                stockMovementsTable, stockMovementsTable.quantityScale);
          }
          if (from < 3) {
            await m.addColumn(costLayersTable, costLayersTable.purchaseId);
          }
          if (from < 4) {
            await m.createTable(receivingsTable);
            await m.createTable(receivingItemsTable);
          }
          if (from < 5) {
            await m.createTable(purchasesTable);
            await m.createTable(purchaseItemsTable);
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'aplikasi_kasir.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
