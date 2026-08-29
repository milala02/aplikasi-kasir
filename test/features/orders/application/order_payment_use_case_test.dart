import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/order_payment_use_case.dart';
import 'package:aplikasi_kasir/features/orders/domain/order.dart';
import 'package:aplikasi_kasir/features/orders/infrastructure/in_memory_order_repository.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('OrderPaymentUseCase - pembayaran tidak menyentuh inventory', () {
    late InMemoryOrderRepository orderRepo;
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late OrderPaymentUseCase useCase;

    setUp(() async {
      orderRepo = InMemoryOrderRepository();
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      useCase = OrderPaymentUseCase(orderRepository: orderRepo);

      await costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'prod_100',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );
    });

    Future<Order> seedOrder({
      OrderStatus status = OrderStatus.pendingPayment,
    }) async {
      final order = Order(
        id: 'ord_1',
        saleId: 'sale_1',
        source: OrderSource.online,
        status: status,
        paymentMethod: OrderPaymentMethod.qris,
        items: [
          SaleItem(
            productId: 'prod_100',
            productName: 'Lada',
            unit: Unit.kilogram,
            quantity: Quantity(value: 2, scale: 0),
            unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime(2026, 8, 20),
      );
      await orderRepo.save(order);
      return order;
    }

    Future<void> assertInventoryUntouched() async {
      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(10));
      expect(await inventoryRepo.getMovements('prod_100'), isEmpty);
    }

    test('confirm: pendingPayment -> paid, inventory tidak berubah', () async {
      final order = await seedOrder();
      final result = await useCase.confirm(order);

      expect(result, isA<Success<Order>>());
      final paid = (result as Success<Order>).value;
      expect(paid.status, OrderStatus.paid);
      expect(orderRepo.getById('ord_1')!.status, OrderStatus.paid);
      await assertInventoryUntouched();
    });

    test('markFailed: pendingPayment -> paymentFailed, inventory tidak berubah',
        () async {
      final order = await seedOrder();
      final result = await useCase.markFailed(order);

      final failed = (result as Success<Order>).value;
      expect(failed.status, OrderStatus.paymentFailed);
      expect(orderRepo.getById('ord_1')!.status, OrderStatus.paymentFailed);
      await assertInventoryUntouched();
    });

    test('retry setelah paymentFailed -> paid', () async {
      final order = await seedOrder();
      final failed = (await useCase.markFailed(order) as Success<Order>).value;
      final retry = await useCase.confirm(failed);

      expect((retry as Success<Order>).value.status, OrderStatus.paid);
      await assertInventoryUntouched();
    });

    test('markExpired: pendingPayment -> expired terminal, inventory tidak berubah',
        () async {
      final order = await seedOrder();
      final result = await useCase.markExpired(order);
      final expired = (result as Success<Order>).value;

      expect(expired.status, OrderStatus.expired);
      expect(orderRepo.getById('ord_1')!.status, OrderStatus.expired);
      await assertInventoryUntouched();

      final retry = await useCase.confirm(expired);
      expect(retry, isA<Failure>());
      await assertInventoryUntouched();
    });

    test('transisi invalid ditolak', () async {
      final order = await seedOrder();
      final paid = (await useCase.confirm(order) as Success<Order>).value;
      final result = await useCase.confirm(paid); // paid -> paid

      expect(result, isA<Failure>());
      expect(
          (result as Failure).error.toString(), contains('INVALID_TRANSITION'));
    });
  });
}
