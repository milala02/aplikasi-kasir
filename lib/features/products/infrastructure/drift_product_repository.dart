import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/unit/unit.dart';
import '../domain/product.dart';
import '../domain/product_repository.dart';

class DriftProductRepository implements ProductRepository {
  final AppDatabase db;
  final Map<String, Product> _cache = {};

  DriftProductRepository(this.db);

  Future<void> init() async {
    final rows = await db.select(db.productsTable).get();
    for (final row in rows) {
      final product = _toDomain(row);
      _cache[product.id] = product;
    }
  }

  @override
  Product? getById(String id) => _cache[id];

  @override
  Product? getBySku(String sku) {
    try {
      return _cache.values.firstWhere((p) => p.sku == sku);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Product> getAll() => _cache.values.toList();

  @override
  List<Product> getActive() => _cache.values.where((p) => p.active).toList();

  @override
  Future<void> save(Product product) async {
    if (_cache.containsKey(product.id)) {
      throw ArgumentError('Product ID already exists.');
    }

    await db.into(db.productsTable).insert(
          ProductsTableCompanion.insert(
            id: product.id,
            sku: product.sku,
            name: product.name,
            baseUnit: product.baseUnit.name,
            purchasePriceMinorUnits: product.purchasePrice.minorUnits,
            purchasePriceCurrency: Value(product.purchasePrice.currency),
            sellingPriceMinorUnits: product.sellingPrice.minorUnits,
            sellingPriceCurrency: Value(product.sellingPrice.currency),
            active: Value(product.active),
          ),
          mode: InsertMode.insertOrReplace,
        );

    _cache[product.id] = product;
  }

  @override
  Future<void> update(Product product) async {
    if (!_cache.containsKey(product.id)) {
      throw ArgumentError('Product not found.');
    }

    // Pertahankan flag CDC saat update (sync layer mengelolanya terpisah).
    final existingRow = await (db.select(db.productsTable)
          ..where((t) => t.id.equals(product.id)))
        .getSingle();

    await db.update(db.productsTable).replace(
          ProductsTableData(
            id: product.id,
            sku: product.sku,
            name: product.name,
            baseUnit: product.baseUnit.name,
            purchasePriceMinorUnits: product.purchasePrice.minorUnits,
            purchasePriceCurrency: product.purchasePrice.currency,
            sellingPriceMinorUnits: product.sellingPrice.minorUnits,
            sellingPriceCurrency: product.sellingPrice.currency,
            active: product.active,
            isSynced: existingRow.isSynced,
            syncedAt: existingRow.syncedAt,
          ),
        );

    _cache[product.id] = product;
  }

  @override
  Future<void> deleteById(String id) async {
    await (db.delete(db.productsTable)..where((tbl) => tbl.id.equals(id)))
        .go();

    _cache.remove(id);
  }

  Product _toDomain(ProductsTableData data) {
    return Product(
      id: data.id,
      sku: data.sku,
      name: data.name,
      baseUnit: Unit.values.firstWhere((u) => u.name == data.baseUnit, orElse: () => Unit.pcs),
      purchasePrice: Money(minorUnits: data.purchasePriceMinorUnits, currency: data.purchasePriceCurrency),
      sellingPrice: Money(minorUnits: data.sellingPriceMinorUnits, currency: data.sellingPriceCurrency),
      active: data.active,
    );
  }
}
