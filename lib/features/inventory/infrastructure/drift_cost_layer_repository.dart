import '../../../../core/database/transaction_database.dart';
import '../../../../core/money/money.dart';
import '../../../../core/quantity/quantity.dart';
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
  List<CostLayer> getAll() {
    // Pada implementasi penuh, ini harusnya asynchronous. 
    // Untuk kecocokan dengan arsitektur saat ini (synchronous abstraction), kita kembalikan list kosong sebagai placeholder, 
    // atau menggunakan .getSync() jika didukung.
    return []; 
  }

  @override
  List<CostLayer> getAvailableByProductId(String productId) {
    return [];
  }
}
