import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../../sync/application/sync_enqueue_service.dart';
import '../domain/sale.dart';
import '../domain/sale_repository.dart';

/// Mencatat transaksi penjualan (financial record) TANPA menyentuh stok.
///
/// Konsumsi CostLayer FIFO dan StockMovement terjadi saat stock-out
/// (lihat `ProcessStockOutUseCase`), bukan saat checkout.
class ProcessSaleUseCase {
  final SaleRepository saleRepository;
  final SyncEnqueueService? syncEnqueueService;

  ProcessSaleUseCase({
    required this.saleRepository,
    this.syncEnqueueService,
  });

  Future<Result<Sale>> execute(Sale sale) async {
    final existing = saleRepository.getByInvoiceNumber(sale.invoiceNumber);
    if (existing != null) {
      return Failure(
        DomainError(
          code: 'DUPLICATE_INVOICE',
          message: 'Nomor invoice ${sale.invoiceNumber} sudah digunakan.',
        ),
      );
    }

    try {
      await saleRepository.save(sale);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'PROCESS_SALE_ERROR',
          message: 'Gagal menyimpan transaksi penjualan: ${e.toString()}',
        ),
      );
    }

    await syncEnqueueService?.enqueue(
      referenceId: sale.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'sale',
      payload: SyncEnqueueService.salePayload(sale),
    );

    return Success(sale);
  }
}
