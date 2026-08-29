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
  RecipeItemsTable
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? _openConnection());

  @override
  int get schemaVersion => 10;

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
