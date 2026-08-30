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
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

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
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

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
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

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
  TextColumn get unit => text().nullable()();
  IntColumn get unitCostMinorUnits => integer()();
  TextColumn get unitCostCurrency =>
      text().withDefault(const Constant('IDR'))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- KONVERSI PACKAGING PER PRODUK ---
class ProductPackagingsTable extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text()();
  TextColumn get fromUnit => text()();
  TextColumn get toUnit => text()();
  IntColumn get multiplierValue => integer()();
  IntColumn get divisorValue => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- ANTRIAN SINKRONISASI OFFLINE-FIRST ---
class SyncQueueTable extends Table {
  TextColumn get id => text()();
  TextColumn get endpoint => text()();
  TextColumn get sourceTable => text().withDefault(const Constant(''))();
  TextColumn get referenceId => text().nullable()();
  TextColumn get payloadJson => text()();
  TextColumn get status => text()(); // PENDING / SYNCED / FAILED
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- MASTER DATA PULL (FASE 9) ---
// Tabel UoM hasil pull backend (id = UUID backend, nama = kunci Unit).
class UomsTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get symbol => text()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// Tabel kategori hasil pull backend (belum ditautkan ke produk lokal).
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

// 6. Tabel Purchases (Pesanan Pembelian / PO)
class PurchasesTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get purchasedAt => dateTime()();
  TextColumn get supplierId => text().nullable()();
  TextColumn get referenceNumber => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

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
  TextColumn get unit => text().nullable()();
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
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SaleItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(0))();
  TextColumn get productName => text().nullable()();
  TextColumn get unit => text().nullable()();
  IntColumn get unitPriceMinorUnits => integer()();
  IntColumn get unitCostMinorUnits => integer().nullable()();
  TextColumn get unitCostCurrency => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// --- TABEL ORDER (LIFECYCLE) ---
class OrdersTable extends Table {
  TextColumn get id => text()();
  TextColumn get saleId => text()();
  TextColumn get source => text()(); // OrderSource.name
  TextColumn get status => text()(); // OrderStatus.name
  TextColumn get paymentMethod => text()(); // OrderPaymentMethod.name
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class OrderItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(0))();
  TextColumn get productName => text()();
  TextColumn get unit => text()();
  IntColumn get unitPriceMinorUnits => integer()();
  TextColumn get unitPriceCurrency =>
      text().withDefault(const Constant('IDR'))();

  @override
  Set<Column> get primaryKey => {id};
}

// --- TABEL RESEP (KOMPOSISI PRODUKSI, TANPA HARGA) ---
class RecipesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get expectedOutputValue => integer()();
  IntColumn get expectedOutputScale => integer().withDefault(const Constant(0))();
  TextColumn get outputProductId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class RecipeItemsTable extends Table {
  TextColumn get id => text()();
  TextColumn get recipeId => text()();
  TextColumn get productId => text()();
  IntColumn get quantityValue => integer()();
  IntColumn get quantityScale => integer().withDefault(const Constant(0))();

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
  StockMovementsTable,
  OrdersTable,
  OrderItemsTable,
  RecipesTable,
  RecipeItemsTable,
  ProductPackagingsTable,
  SyncQueueTable,
  UomsTable,
  CategoriesTable
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        beforeOpen: (details) async {
          // Infrastruktur DB: WAL untuk durabilitas konkurensi,
          // foreign_keys untuk integritas referensi (per koneksi).
          await customStatement('PRAGMA journal_mode=WAL;');
          await customStatement('PRAGMA foreign_keys=ON;');
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
          if (from < 6) {
            // Kolom HPP per sale item (nullable agar data lama tetap terbaca).
            await m.addColumn(
                saleItemsTable, saleItemsTable.unitCostMinorUnits);
            await m.addColumn(saleItemsTable, saleItemsTable.unitCostCurrency);
          }
          if (from < 7) {
            // Kolom detail item agar tidak terdegradasi saat reload
            // (nama produk, unit, skala quantity).
            await m.addColumn(saleItemsTable, saleItemsTable.quantityScale);
            await m.addColumn(saleItemsTable, saleItemsTable.productName);
            await m.addColumn(saleItemsTable, saleItemsTable.unit);
          }
          if (from < 8) {
            // Tabel order lifecycle (submit/payment/fulfillment).
            await m.createTable(ordersTable);
            await m.createTable(orderItemsTable);
          }
          if (from < 9) {
            // Tabel resep produksi (komposisi + output, tanpa harga).
            await m.createTable(recipesTable);
            await m.createTable(recipeItemsTable);
          }
          if (from >= 9 && from < 10) {
            // Produk hasil produksi (nullable: resep lama tetap terbaca,
            // tetapi tidak dapat dieksekusi produksi).
            // Hanya untuk DB v9: DB < 9 dibuat tabel resepnya di from < 9
            // dengan skema terbaru (sudah termasuk kolom ini).
            await m.addColumn(recipesTable, recipesTable.outputProductId);
          }
          if (from < 11) {
            // Tabel konversi packaging per produk.
            await m.createTable(productPackagingsTable);
          }
          if (from >= 10 && from < 11) {
            // Unit input (UoM) pada baris PO & penerimaan untuk audit trail.
            // Hanya untuk DB v10: DB < 10 membuat tabel purchase/receiving
            // items di from < 5/from < 4 dengan skema terbaru.
            await m.addColumn(purchaseItemsTable, purchaseItemsTable.unit);
            await m.addColumn(receivingItemsTable, receivingItemsTable.unit);
          }
          if (from < 12) {
            // Antrian sinkronisasi offline-first.
            await m.createTable(syncQueueTable);
          }
          if (from >= 11 && from < 12) {
            // Kolom CDC (Change Data Capture) pada header transaksi dan
            // master data. Hanya untuk DB v11: DB < 11 membuat tabel-tabel
            // ini dengan skema terbaru pada titik createTable masing-masing.
            await m.addColumn(productsTable, productsTable.isSynced);
            await m.addColumn(productsTable, productsTable.syncedAt);
            await m.addColumn(customersTable, customersTable.isSynced);
            await m.addColumn(customersTable, customersTable.syncedAt);
            await m.addColumn(receivingsTable, receivingsTable.isSynced);
            await m.addColumn(receivingsTable, receivingsTable.syncedAt);
            await m.addColumn(purchasesTable, purchasesTable.isSynced);
            await m.addColumn(purchasesTable, purchasesTable.syncedAt);
            await m.addColumn(salesTable, salesTable.isSynced);
            await m.addColumn(salesTable, salesTable.syncedAt);
            await m.addColumn(ordersTable, ordersTable.isSynced);
            await m.addColumn(ordersTable, ordersTable.syncedAt);
          }
          if (from >= 12 && from < 13) {
            // Tabel sumber CDC untuk entri antrian (mapping ke markSynced).
            // Hanya untuk DB v12: DB < 12 membuat sync_queue di from < 12
            // dengan skema terbaru.
            await m.addColumn(syncQueueTable, syncQueueTable.sourceTable);
          }
          if (from >= 12 && from < 14) {
            // Id lokal baris sumber untuk penanda CDC (payload baru memuat
            // UUID hasil mapping, bukan id lokal). Hanya untuk DB v12/v13:
            // DB < 12 membuat sync_queue di from < 12 dengan skema terbaru
            // (sudah termasuk kolom ini).
            await m.addColumn(syncQueueTable, syncQueueTable.referenceId);
          }
          if (from < 15) {
            // Master data pull (Fase 9): UoM & kategori dari backend.
            await m.createTable(uomsTable);
            await m.createTable(categoriesTable);
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
