import '../../../core/database/app_database.dart';
import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class DriftCostLayerRepository implements CostLayerRepository {
  final AppDatabase db;
  final Map<String, CostLayer> _cache = {};

  DriftCostLayerRepository(this.db);

  @override
  CostLayer? getById(String id) => _cache[id];

  @override
  List<CostLayer> getByProductId(String productId) =>
      _cache.values.where((l) => l.productId == productId).toList();

  @override
  List<CostLayer> getAvailableByProductId(String productId) => _cache.values
      .where((l) => l.productId == productId && l.isAvailable)
      .toList();

  @override
  void save(CostLayer layer) {
    if (_cache.containsKey(layer.id)) {
      throw StateError('Cost layer with id "${layer.id}" already exists.');
    }
    _cache[layer.id] = layer;
    db.into(db.costLayersTable).insertOnConflictUpdate(
      CostLayersTableCompanion.insert(
        id: layer.id,
        productId: layer.productId,
        originalQuantityValue: layer.originalQuantity.value.toInt(),
        originalQuantityScale: layer.originalQuantity.scale,
        remainingQuantityValue: layer.remainingQuantity.value.toInt(),
        remainingQuantityScale: layer.remainingQuantity.scale,
        unitCostMinorUnits: layer.unitCost.minorUnits,
        acquiredAt: layer.acquiredAt,
      ),
    );
  }

  @override
  void update(CostLayer layer) {
    if (!_cache.containsKey(layer.id)) {
      throw StateError('Cost layer with id "${layer.id}" does not exist.');
    }
    _cache[layer.id] = layer;
    db.into(db.costLayersTable).insertOnConflictUpdate(
      CostLayersTableCompanion.insert(
        id: layer.id,
        productId: layer.productId,
        originalQuantityValue: layer.originalQuantity.value.toInt(),
        originalQuantityScale: layer.originalQuantity.scale,
        remainingQuantityValue: layer.remainingQuantity.value.toInt(),
        remainingQuantityScale: layer.remainingQuantity.scale,
        unitCostMinorUnits: layer.unitCost.minorUnits,
        acquiredAt: layer.acquiredAt,
      ),
    );
  }
}
