import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../../inventory/domain/cost_layer.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../inventory/domain/inventory_repository.dart';
import '../../inventory/domain/stock_ledger.dart';
import '../../inventory/domain/stock_movement.dart';
import '../domain/receiving.dart';
import '../domain/receiving_repository.dart';

class ReceiveGoodsUseCase {
  final ReceivingRepository receivingRepository;
  final InventoryRepository inventoryRepository;
  final CostLayerRepository costLayerRepository;

  ReceiveGoodsUseCase({
    required this.receivingRepository,
    required this.inventoryRepository,
    required this.costLayerRepository,
  });

  Result<void> execute(Receiving receiving) {
    try {
      // 1. Simpan penerimaan barang
      receivingRepository.save(receiving);

      for (final item in receiving.items) {
        // 2. Catat Pergerakan Stok
        final movement = StockMovement(
          id: 'mov_${receiving.id}_${item.productId}',
          productId: item.productId,
          quantity: item.quantityReceived,
          type: StockMovementType.purchase,
          referenceId: receiving.id,
          occurredAt: receiving.receivedAt,
        );
        inventoryRepository.recordMovement(movement);

        // Update atau buat StockLedger dengan pergerakan baru (addMovement)
        final currentLedger = inventoryRepository.getLedger(item.productId);
        final updatedLedger = (currentLedger == null)
            ? StockLedger(
                productId: item.productId,
                movements: [movement],
              )
            : currentLedger.addMovement(movement);
            
        inventoryRepository.saveLedger(updatedLedger);

        // 3. Catat Cost Layer baru (FIFO HPP)
        final costLayer = CostLayer(
          id: 'layer_${receiving.id}_${item.productId}',
          productId: item.productId,
          originalQuantity: item.quantityReceived,
          remainingQuantity: item.quantityReceived,
          unitCost: item.unitCost,
          acquiredAt: receiving.receivedAt,
          purchaseId: receiving.purchaseId,
        );
        costLayerRepository.save(costLayer);
      }

      return const Success(null);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'RECEIVING_ERROR',
          message: 'Gagal memproses penerimaan barang: ${e.toString()}',
        ),
      );
    }
  }
}
