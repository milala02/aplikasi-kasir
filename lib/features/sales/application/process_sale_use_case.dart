import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../../inventory/domain/inventory_repository.dart';
import '../../inventory/domain/stock_movement.dart';
import '../domain/sale.dart';
import '../domain/sale_repository.dart';

class ProcessSaleUseCase {
  final SaleRepository saleRepository;
  final InventoryRepository inventoryRepository;

  ProcessSaleUseCase({
    required this.saleRepository,
    required this.inventoryRepository,
  });

  Future<Result<void>> execute(Sale sale) async {
    try {
      // 1. Simpan transaksi penjualan
      saleRepository.save(sale);

      // 2. Potong stok fisik di Inventory untuk setiap item terjelas
      for (final item in sale.items) {
        final movement = StockMovement(
          id: 'mov_sale_${sale.id}_${item.productId}',
          productId: item.productId,
          quantity: item.quantity,
          type: StockMovementType.sale,
          referenceId: sale.id,
          occurredAt: sale.soldAt,
        );

        await inventoryRepository.recordMovement(movement);

        final currentLedger =
            await inventoryRepository.getLedger(item.productId);
        if (currentLedger != null) {
          final updatedLedger = currentLedger.addMovement(movement);
          await inventoryRepository.saveLedger(updatedLedger);
        }
      }

      return const Success(null);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'PROCESS_SALE_ERROR',
          message: 'Gagal memproses transaksi penjualan: ${e.toString()}',
        ),
      );
    }
  }
}
