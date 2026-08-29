import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../../inventory/domain/cost_layer.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../inventory/domain/inventory_repository.dart';
import '../../inventory/domain/stock_movement.dart';
import '../domain/production_batch.dart';

/// Mencatat hasil produksi sebagai stok nyata yang dapat dijual via FIFO:
/// - StockMovement inbound (tipe production) untuk produk output.
/// - CostLayer output dengan HPP per unit batch (unitCost = batch.unitCost).
///
/// `productId` output ditentukan oleh caller (UI produksi) saat runtime —
/// fondasi ini tidak membutuhkan data komposisi Recipe bisnis.
///
/// Idempoten terhadap pemanggilan ganda: movement id unik per batch
/// ditolak repository, sehingga layer tidak pernah dibuat dua kali.
class RecordProductionOutputUseCase {
  final CostLayerRepository costLayerRepository;
  final InventoryRepository inventoryRepository;

  RecordProductionOutputUseCase({
    required this.costLayerRepository,
    required this.inventoryRepository,
  });

  Future<Result<void>> execute({
    required ProductionBatch batch,
    required String productId,
  }) async {
    if (productId.isEmpty) {
      return const Failure(
        DomainError(
          code: 'PRODUCTION_OUTPUT_ERROR',
          message: 'Product ID output tidak boleh kosong.',
        ),
      );
    }

    try {
      // 1. StockMovement inbound untuk hasil produksi.
      final movement = StockMovement(
        id: 'mov_prod_out_${batch.id}',
        productId: productId,
        quantity: batch.actualOutputQuantity,
        type: StockMovementType.production,
        referenceId: batch.id,
        occurredAt: batch.producedAt,
      );
      await inventoryRepository.recordMovement(movement);

      final currentLedger = await inventoryRepository.getLedger(productId);
      if (currentLedger != null) {
        final updatedLedger = currentLedger.addMovement(movement);
        await inventoryRepository.saveLedger(updatedLedger);
      }

      // 2. CostLayer output: HPP per unit dari batch (termasuk biaya tambahan).
      final layer = CostLayer(
        id: 'layer_prod_out_${batch.id}',
        productId: productId,
        originalQuantity: batch.actualOutputQuantity,
        remainingQuantity: batch.actualOutputQuantity,
        unitCost: batch.unitCost,
        acquiredAt: batch.producedAt,
      );
      await costLayerRepository.save(layer);

      return const Success(null);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'PRODUCTION_OUTPUT_ERROR',
          message: 'Gagal mencatat hasil produksi: ${e.toString()}',
        ),
      );
    }
  }
}
