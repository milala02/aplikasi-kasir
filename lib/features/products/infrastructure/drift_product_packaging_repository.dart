import '../../../core/database/app_database.dart';
import '../../../core/unit/unit.dart';
import '../domain/product_packaging.dart';
import '../domain/product_packaging_repository.dart';

class DriftProductPackagingRepository
    implements ProductPackagingRepository {
  final AppDatabase db;
  final Map<String, ProductPackaging> _cache = {};

  DriftProductPackagingRepository(this.db);

  Future<void> init() async {
    final rows = await db.select(db.productPackagingsTable).get();
    _cache.clear();
    for (final row in rows) {
      final packaging = ProductPackaging(
        id: row.id,
        productId: row.productId,
        fromUnit: _parseUnit(row.fromUnit),
        toUnit: _parseUnit(row.toUnit),
        multiplierValue: row.multiplierValue,
        divisorValue: row.divisorValue,
      );
      _cache[packaging.id] = packaging;
    }
  }

  @override
  List<ProductPackaging> getByProductId(String productId) {
    return List.unmodifiable(
      _cache.values.where((p) => p.productId == productId),
    );
  }

  @override
  List<ProductPackaging> getAll() => List.unmodifiable(_cache.values);

  @override
  Future<void> save(ProductPackaging packaging) async {
    if (_cache.containsKey(packaging.id)) {
      throw ArgumentError('Packaging ID already exists.');
    }

    await db.into(db.productPackagingsTable).insert(
          ProductPackagingsTableCompanion.insert(
            id: packaging.id,
            productId: packaging.productId,
            fromUnit: packaging.fromUnit.name,
            toUnit: packaging.toUnit.name,
            multiplierValue: packaging.multiplierValue,
            divisorValue: packaging.divisorValue,
          ),
        );

    _cache[packaging.id] = packaging;
  }

  static Unit _parseUnit(String name) {
    return Unit.values.firstWhere(
      (u) => u.name == name,
      orElse: () =>
          throw StateError('Unknown unit: $name'),
    );
  }
}
