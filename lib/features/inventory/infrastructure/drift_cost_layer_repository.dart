import '../../../core/database/app_database.dart';
import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class DriftCostLayerRepository implements CostLayerRepository {
  final AppDatabase db;
  DriftCostLayerRepository(this.db);

  @override
  CostLayer? getById(String id) => null;

  @override
  List<CostLayer> getByProductId(String productId) => [];

  @override
  List<CostLayer> getAvailableByProductId(String productId) => [];

  @override
  void save(CostLayer layer) {
    db.into(db.costLayersTable).insert(
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
  void update(CostLayer layer) {}
}
