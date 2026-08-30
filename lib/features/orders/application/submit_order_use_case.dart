import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../../sales/application/process_sale_use_case.dart';
import '../../sales/domain/sale.dart';
import '../../sales/domain/sale_item.dart';
import '../../sales/domain/sale_repository.dart';
import '../../sync/application/sync_enqueue_service.dart';
import '../domain/order.dart';
import '../domain/order_repository.dart';

/// Submit order: mencatat Sale (financial record) + Order PENDING_PAYMENT.
/// Tidak menyentuh stok/cost layer sama sekali.
class SubmitOrderUseCase {
  final ProcessSaleUseCase processSaleUseCase;
  final SaleRepository saleRepository;
  final OrderRepository orderRepository;
  final SyncEnqueueService? syncEnqueueService;

  SubmitOrderUseCase({
    required this.processSaleUseCase,
    required this.saleRepository,
    required this.orderRepository,
    this.syncEnqueueService,
  });

  Future<Result<Order>> submit({
    required String orderId,
    required String saleId,
    required String invoiceNumber,
    required OrderSource source,
    required OrderPaymentMethod paymentMethod,
    required List<SaleItem> items,
    required DateTime submittedAt,
  }) async {
    final sale = Sale(
      id: saleId,
      invoiceNumber: invoiceNumber,
      items: items,
      createdAt: submittedAt,
    );

    final saleResult = await processSaleUseCase.execute(sale);
    if (saleResult is Failure<Sale>) {
      return Failure(saleResult.error);
    }

    final order = Order(
      id: orderId,
      saleId: sale.id,
      source: source,
      status: OrderStatus.pendingPayment,
      paymentMethod: paymentMethod,
      items: items,
      createdAt: submittedAt,
    );

    try {
      await orderRepository.save(order);
    } catch (e) {
      // Kompensasi: hapus sale agar tidak ada transaksi tanpa order.
      try {
        await saleRepository.deleteById(sale.id);
      } catch (_) {
        // Best-effort.
      }
      return Failure(
        DomainError(
          code: 'SUBMIT_ORDER_ERROR',
          message: 'Gagal menyimpan order: ${e.toString()}',
        ),
      );
    }

    await syncEnqueueService?.enqueue(
      referenceId: order.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'order',
      payload: SyncEnqueueService.orderPayload(
        order,
        invoiceNumber: invoiceNumber,
      ),
      wrapInOrders: true,
    );

    return Success(order);
  }
}
