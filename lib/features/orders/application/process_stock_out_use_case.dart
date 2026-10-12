import '../../../core/errors/domain_error.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/result/result.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../inventory/domain/cost_layer_service.dart';
import '../../inventory/domain/inventory_repository.dart';
import '../../inventory/domain/stock_movement.dart';
import '../../sales/domain/sale.dart';
import '../../sales/domain/sale_item.dart';
import '../../sales/domain/sale_repository.dart';

/// Eksekusi stock-out: konsumsi CostLayer FIFO + StockMovement + kunci HPP
/// pada SaleItem. FIFO tetap via CostLayerService (single source of truth).
///
/// Pattern: pre-validasi seluruh item tanpa efek samping, baru mutasi.
/// Idempotensi dijamin oleh state machine Order di layer fulfillment —
/// use case ini TIDAK boleh dipanggil dua kali untuk order yang sama.
class ProcessStockOutUseCase {
  final CostLayerService costLayerService;
  final CostLayerRepository costLayerRepository;
  final InventoryRepository inventoryRepository;
  final SaleRepository saleRepository;

  ProcessStockOutUseCase({
    required this.costLayerService,
    required this.costLayerRepository,
    required this.inventoryRepository,
    required this.saleRepository,
  });

  /// Cek ketersediaan stok dan saldo ledger untuk seluruh item,
  /// tanpa efek samping.
  Future<Result<void>> checkAvailability(Sale sale) async {
    try {
      for (final item in sale.items) {
        // Bandingkan pada skala terbesar bersama agar tidak ada pembulatan
        // per layer (false-negative) maupun overcount (bug scale terbalik).
        final (maxScale, available) = await _availableQuantity(item);
        final required = _scaleUp(item.quantity, maxScale);
        if (available < required) {
          return Failure(
            DomainError(
              code: 'INSUFFICIENT_STOCK',
              message:
                  'Stok tidak mencukupi untuk produk ${item.productId}. Required: $required, Available: $available (scale $maxScale)',
            ),
          );
        }

        final ledger = await inventoryRepository.getLedger(item.productId);
        if (ledger != null) {
          final balance = ledger.calculateBalance();
          final ledgerScale = balance.scale > maxScale ? balance.scale : maxScale;
          if (_scaleUp(balance, ledgerScale) <
              _scaleUp(item.quantity, ledgerScale)) {
            return Failure(
              DomainError(
                code: 'INSUFFICIENT_STOCK',
                message:
                    'Saldo ledger tidak mencukupi untuk produk ${item.productId}.',
              ),
            );
          }
        }
      }
      return const Success(null);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'STOCK_OUT_ERROR',
          message: 'Gagal memeriksa stok: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<Sale>> execute(Sale sale) async {
    final availability = await checkAvailability(sale);
    if (availability is Failure) {
      return Failure(availability.error);
    }

    // 1. Konsumsi cost layer FIFO dan hitung HPP unit.
    final enrichedItems = <SaleItem>[];
    try {
      for (final item in sale.items) {
        final consumption = await costLayerService.consume(
          productId: item.productId,
          quantity: item.quantity,
        );
        enrichedItems.add(
          item.withUnitCost(_unitCost(item.quantity, consumption.totalCost)),
        );
      }
    } on StateError {
      return Failure(
        DomainError(
          code: 'INSUFFICIENT_STOCK',
          message: 'Tidak ada cost layer aktif saat memproses stock-out.',
        ),
      );
    } on ArgumentError catch (e) {
      return Failure(
        DomainError(
          code: 'INSUFFICIENT_STOCK',
          message: 'Konsumsi stok gagal: ${e.message}',
        ),
      );
    }

    // 2. Catat pergerakan stok dan ledger.
    try {
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
    } catch (e) {
      return Failure(
        DomainError(
          code: 'STOCK_OUT_ERROR',
          message: 'Gagal mencatat pergerakan stok: ${e.toString()}',
        ),
      );
    }

    // 3. Kunci HPP FIFO pada Sale.
    final enrichedSale = Sale(
      id: sale.id,
      invoiceNumber: sale.invoiceNumber,
      items: enrichedItems,
      discount: sale.discount,
      tax: sale.tax,
      createdAt: sale.createdAt,
      soldAt: sale.soldAt,
    );
    try {
      await saleRepository.update(enrichedSale);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'STOCK_OUT_ERROR',
          message: 'Gagal menyimpan HPP transaksi: ${e.toString()}',
        ),
      );
    }

    return Success(enrichedSale);
  }

  /// Total sisa stok di seluruh cost layer aktif, dinyatakan pada skala
  /// terbesar bersama (maxScale, totalAtMaxScale) — presisi eksak tanpa
  /// pembulatan per layer.
  Future<(int, int)> _availableQuantity(SaleItem item) async {
    final layers =
        await costLayerRepository.getAvailableByProductId(item.productId);
    var maxScale = item.quantity.scale;
    for (final layer in layers) {
      if (layer.remainingQuantity.scale > maxScale) {
        maxScale = layer.remainingQuantity.scale;
      }
    }
    var totalAvailable = 0;
    for (final layer in layers) {
      totalAvailable += _scaleUp(layer.remainingQuantity, maxScale);
    }
    return (maxScale, totalAvailable);
  }

  /// Naikkan skala quantity ke targetScale (wajib targetScale >= scale).
  static int _scaleUp(Quantity quantity, int targetScale) {
    if (quantity.scale == targetScale) return quantity.value;
    if (targetScale < quantity.scale) {
      throw ArgumentError(
          'targetScale ($targetScale) must be >= quantity scale '
          '(${quantity.scale}).');
    }
    // Guard against overflow: max safe multiplication before int overflow
    final diff = targetScale - quantity.scale;
    if (diff > 9) {
      throw ArgumentError('Scale difference too large ($diff), would overflow int');
    }
    var factor = 1;
    for (var i = 0; i < diff; i++) {
      factor *= 10;
    }
    // Check multiplication overflow
    if (quantity.value > (1 << 62) ~/ factor) {
      throw ArgumentError('Quantity value too large for target scale');
    }
    return quantity.value * factor;
  }

  /// HPP per unit dari total biaya konsumsi FIFO untuk quantity yang terjual.
  static Money _unitCost(Quantity quantity, Money totalCost) {
    final minorUnits = (totalCost.minorUnits * _scaleFactor(quantity.scale)) ~/
        quantity.value;
    return Money(minorUnits: minorUnits, currency: totalCost.currency);
  }

  static int _scaleFactor(int scale) {
    var result = 1;
    for (var i = 0; i < scale; i++) {
      result *= 10;
    }
    return result;
  }
}
