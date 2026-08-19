import 'package:drift/drift.dart';

import '../../../../core/database/transaction_database.dart';
import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class DriftCostLayerRepository implements CostLayerRepository {
  final TransactionDatabase db;

  DriftCostLayerRepository(this.db);

  @override
  void save(CostLayer costLayer) {
    db.into(db.costLayersTable).insert(
      CostLayersTableCompanion.insert(
        id: costLayer.id,
        productId: costLayer.productId,
        originalQuantity: costLayer.originalQuantity.value,
        remainingQuantity: costLayer.remainingQuantity.value,
        unitCost: costLayer.unitCost.minorUnits,
        acquiredAt: costLayer.acquiredAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  void update(CostLayer costLayer) {
    // Pada SQLite (Drift), operasi insertOrReplace merangkap sebagai update.
    save(costLayer);
  }

  @override
  CostLayer? getById(String id) {
    // Placeholder sinkron (Integrasi database penuh nantinya butuh return tipe Future)
    return null; 
  }

  @override
  List<CostLayer> getByProductId(String productId) {
    return [];
  }

  @override
  List<CostLayer> getAvailableByProductId(String productId) {
    return [];
  }
  
  // Disediakan tanpa anotasi @override jika dipanggil secara spesifik oleh UI
  List<CostLayer> getAll() {
    return [];
  }
}
