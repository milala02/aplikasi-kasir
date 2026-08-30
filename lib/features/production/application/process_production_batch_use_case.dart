import '../../../core/errors/domain_error.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/result/result.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../inventory/domain/inventory_repository.dart';
import '../../inventory/domain/stock_movement.dart';
import '../../recipes/domain/recipe.dart';
import '../domain/production_batch.dart';

class ProcessProductionBatchUseCase {
  final CostLayerRepository costLayerRepository;
  final InventoryRepository inventoryRepository;

  ProcessProductionBatchUseCase({
    required this.costLayerRepository,
    required this.inventoryRepository,
  });

  Future<Result<ProductionBatch>> execute({
    required String batchId,
    required String batchNumber,
    required Recipe recipe,
    required DateTime producedAt,
    Money? additionalProductionCost,
    Quantity? actualOutputQuantity,
  }) async {
    try {
      final allocations = <MaterialCostAllocation>[];

      // 1. Cek Ketersediaan Stok & Alokasi FIFO
      for (final item in recipe.items) {
        final availableLayers =
            await costLayerRepository.getAvailableByProductId(item.productId);

        // FIFO deterministik: urutkan berdasarkan acquiredAt, lalu id
        // (repository tidak menjamin urutan layer yang dikembalikan).
        availableLayers.sort((a, b) {
          final acquired = a.acquiredAt.compareTo(b.acquiredAt);
          if (acquired != 0) return acquired;
          return a.id.compareTo(b.id);
        });

        // Hitung total sisa stok di semua layer pada skala terbesar bersama
        // (tanpa pembulatan per layer / overcount).
        var maxScale = item.quantityRequired.scale;
        for (final layer in availableLayers) {
          if (layer.remainingQuantity.scale > maxScale) {
            maxScale = layer.remainingQuantity.scale;
          }
        }
        var totalAvailable = 0;
        for (final layer in availableLayers) {
          totalAvailable += _scaleUp(layer.remainingQuantity, maxScale);
        }
        final required = _scaleUp(item.quantityRequired, maxScale);

        if (totalAvailable < required) {
          return Failure(
            DomainError(
              code: 'INSUFFICIENT_STOCK',
              message:
                  'Stok tidak mencukupi untuk produk ${item.productId}. Required: $required, Available: $totalAvailable (scale $maxScale)',
            ),
          );
        }

        // Konsumsi Layer FIFO
        var needed = item.quantityRequired;
        for (final layer in availableLayers) {
          if (needed.isZero) break;

          final available = layer.remainingQuantity;
          final consumeQty = _minQuantity(needed, available);

          // Update layer
          final updatedLayer = layer.consume(consumeQty);
          await costLayerRepository.update(updatedLayer);

          // Simpan audit trail alokasi
          allocations.add(
            MaterialCostAllocation(
              costLayerId: layer.id,
              productId: item.productId,
              quantityConsumed: consumeQty,
              unitCost: layer.unitCost,
            ),
          );

          needed = needed.subtract(consumeQty);
        }
      }

      // 2. Catat Pergerakan Stok Keluar (Outbound) untuk Bahan
      for (final item in recipe.items) {
        final movement = StockMovement(
          id: 'mov_prod_${batchId}_${item.productId}',
          productId: item.productId,
          quantity: item.quantityRequired,
          type: StockMovementType.sale, // Outbound consumption
          referenceId: batchId,
          occurredAt: producedAt,
        );
        await inventoryRepository.recordMovement(movement);
      }

      // 3. Buat Production Batch Result
      final batch = ProductionBatch(
        id: batchId,
        recipeId: recipe.id,
        batchNumber: batchNumber,
        producedAt: producedAt,
        allocations: allocations,
        additionalProductionCost: additionalProductionCost,
        actualOutputQuantity:
            actualOutputQuantity ?? recipe.expectedOutputQuantity,
      );

      return Success(batch);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'PRODUCTION_ERROR',
          message: 'Gagal memproses batch produksi: ${e.toString()}',
        ),
      );
    }
  }

  /// Naikkan skala quantity ke targetScale (wajib targetScale >= scale).
  static int _scaleUp(Quantity quantity, int targetScale) {
    if (quantity.scale == targetScale) return quantity.value;
    if (targetScale < quantity.scale) {
      throw ArgumentError(
          'targetScale ($targetScale) must be >= quantity scale '
          '(${quantity.scale}).');
    }
    var factor = 1;
    for (var i = 0; i < targetScale - quantity.scale; i++) {
      factor *= 10;
    }
    return quantity.value * factor;
  }

  static Quantity _minQuantity(Quantity q1, Quantity q2) {
    final scale = q1.scale > q2.scale ? q1.scale : q2.scale;
    final v1 = _scaleUp(q1, scale);
    final v2 = _scaleUp(q2, scale);
    return v1 <= v2 ? q1 : q2;
  }
}
