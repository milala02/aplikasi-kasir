import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../../sales/domain/sale.dart';
import '../../sales/domain/sale_repository.dart';
import '../domain/order.dart';
import '../domain/order_repository.dart';
import 'process_stock_out_use_case.dart';

/// Fulfillment: event stock-out (handover onsite / pickup online).
///
/// Urutan aman:
/// 1. Baca order TERKINI dari repository (guard idempotensi — object lama
///    dari caller tidak bisa melewati validasi state final).
/// 2. Validasi status & channel.
/// 3. Pre-check stok tanpa efek samping.
/// 4. Transisi status order (guard durable) — setelah ini tidak ada retry,
///    sehingga FIFO tidak pernah dikonsumsi dua kali.
/// 5. Stock-out: konsumsi FIFO + movement + kunci HPP.
class FulfillOrderUseCase {
  final OrderRepository orderRepository;
  final SaleRepository saleRepository;
  final ProcessStockOutUseCase processStockOutUseCase;

  FulfillOrderUseCase({
    required this.orderRepository,
    required this.saleRepository,
    required this.processStockOutUseCase,
  });

  /// Onsite: penyerahan barang = stock-out + COMPLETED.
  /// Boleh langsung dari PAID (kasir menyerahkan tanpa menandai preparing).
  Future<Result<Order>> handover(Order order) async {
    final current = orderRepository.getById(order.id);
    if (current == null) {
      return const Failure(
        DomainError(
          code: 'ORDER_NOT_FOUND',
          message: 'Order tidak ditemukan.',
        ),
      );
    }
    if (current.source != OrderSource.onsite) {
      return const Failure(
        DomainError(
          code: 'INVALID_TRANSITION',
          message: 'Handover hanya berlaku untuk order onsite.',
        ),
      );
    }

    Order transitioned;
    try {
      if (current.status == OrderStatus.paid) {
        transitioned = current
            .transitionTo(OrderStatus.preparing)
            .transitionTo(OrderStatus.completed);
      } else {
        transitioned = current.transitionTo(OrderStatus.completed);
      }
    } on ArgumentError catch (e) {
      return Failure(
        DomainError(code: 'INVALID_TRANSITION', message: e.message ?? '$e'),
      );
    }

    return _stockOut(current, transitioned);
  }

  /// Online: ojek pickup = stock-out + PICKED_UP.
  Future<Result<Order>> pickup(Order order) async {
    final current = orderRepository.getById(order.id);
    if (current == null) {
      return const Failure(
        DomainError(
          code: 'ORDER_NOT_FOUND',
          message: 'Order tidak ditemukan.',
        ),
      );
    }
    if (current.source != OrderSource.online) {
      return const Failure(
        DomainError(
          code: 'INVALID_TRANSITION',
          message: 'Pickup hanya berlaku untuk order online.',
        ),
      );
    }

    Order transitioned;
    try {
      transitioned = current.transitionTo(OrderStatus.pickedUp);
    } on ArgumentError catch (e) {
      return Failure(
        DomainError(code: 'INVALID_TRANSITION', message: e.message ?? '$e'),
      );
    }

    return _stockOut(current, transitioned);
  }

  /// Online: barang sampai ke konsumen. Tanpa efek stok.
  Future<Result<Order>> completeDelivery(Order order) async {
    final current = orderRepository.getById(order.id);
    if (current == null) {
      return const Failure(
        DomainError(
          code: 'ORDER_NOT_FOUND',
          message: 'Order tidak ditemukan.',
        ),
      );
    }

    try {
      final updated = current.transitionTo(OrderStatus.completed);
      await orderRepository.update(updated);
      return Success(updated);
    } on ArgumentError catch (e) {
      return Failure(
        DomainError(code: 'INVALID_TRANSITION', message: e.message ?? '$e'),
      );
    } catch (e) {
      return Failure(
        DomainError(
          code: 'FULFILLMENT_ERROR',
          message: 'Gagal menyelesaikan pengiriman: ${e.toString()}',
        ),
      );
    }
  }

  Future<Result<Order>> _stockOut(Order current, Order transitioned) async {
    final sale = saleRepository.getById(current.saleId);
    if (sale == null) {
      return Failure(
        DomainError(
          code: 'SALE_NOT_FOUND',
          message: 'Sale ${current.saleId} tidak ditemukan untuk order '
              '${current.id}.',
        ),
      );
    }

    // Pre-check stok tanpa efek samping.
    final availability = await processStockOutUseCase.checkAvailability(sale);
    if (availability is Failure) {
      return Failure(availability.error);
    }

    // Transisi status order lebih dulu (durable guard: tidak ada retry
    // setelah ini, sehingga FIFO tidak mungkin dikonsumsi dua kali).
    try {
      await orderRepository.update(transitioned);
    } catch (e) {
      return Failure(
        DomainError(
          code: 'FULFILLMENT_ERROR',
          message: 'Gagal memperbarui status order: ${e.toString()}',
        ),
      );
    }

    // Stock-out: konsumsi FIFO + movement + kunci HPP.
    final stockOutResult = await processStockOutUseCase.execute(sale);
    if (stockOutResult is Failure<Sale>) {
      return Failure(stockOutResult.error);
    }

    return Success(transitioned);
  }
}
