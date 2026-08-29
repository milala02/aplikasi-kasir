import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/fulfill_order_use_case.dart';
import 'package:aplikasi_kasir/features/orders/application/order_payment_use_case.dart';
import 'package:aplikasi_kasir/features/orders/application/process_stock_out_use_case.dart';
import 'package:aplikasi_kasir/features/orders/domain/order.dart';
import 'package:aplikasi_kasir/features/orders/infrastructure/in_memory_order_repository.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('FulfillOrderUseCase - stock-out saat handover/pickup', () {
    late InMemoryOrderRepository orderRepo;
    late InMemorySaleRepository saleRepo;
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late OrderPaymentUseCase paymentUseCase;
    late FulfillOrderUseCase fulfillUseCase;

    setUp(() async {
      orderRepo = InMemoryOrderRepository();
      saleRepo = InMemorySaleRepository();
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      paymentUseCase = OrderPaymentUseCase(orderRepository: orderRepo);
      final stockOutUseCase = ProcessStockOutUseCase(
        costLayerService: CostLayerService(repository: costLayerRepo),
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
        saleRepository: saleRepo,
      );
      fulfillUseCase = FulfillOrderUseCase(
        orderRepository: orderRepo,
        saleRepository: saleRepo,
        processStockOutUseCase: stockOutUseCase,
      );

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

    SaleItem item({int quantity = 2}) => SaleItem(
          productId: 'prod_100',
          productName: 'Lada',
          unit: Unit.kilogram,
          quantity: Quantity(value: quantity, scale: 0),
          unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
        );

    var seedCounter = 0;

    Future<Order> seedOrder({
      OrderSource source = OrderSource.onsite,
      OrderStatus status = OrderStatus.pendingPayment,
      OrderPaymentMethod paymentMethod = OrderPaymentMethod.qris,
      int quantity = 2,
    }) async {
      seedCounter++;
      final saleId = 'sale_$seedCounter';
      final orderId = 'ord_$seedCounter';

      final sale = Sale(
        id: saleId,
        invoiceNumber: 'INV-$seedCounter',
        items: [item(quantity: quantity)],
        createdAt: DateTime(2026, 8, 20),
      );
      await saleRepo.save(sale);

      final order = Order(
        id: orderId,
        saleId: saleId,
        source: source,
        status: status,
        paymentMethod: paymentMethod,
        items: [item(quantity: quantity)],
        createdAt: DateTime(2026, 8, 20),
      );
      await orderRepo.save(order);
      return order;
    }

    test(
        'onsite: checkout tidak menyentuh stok; handover = stock-out + '
        'completed + HPP + movement', () async {
      final order = await seedOrder();

      // Pending payment: stok utuh.
      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(10));

      // Bayar -> preparing.
      final paid = await paymentUseCase.confirm(order);
      final preparing = (paid as Success<Order>).value
          .transitionTo(OrderStatus.preparing);
      await orderRepo.update(preparing);

      // Handover: stock-out.
      final result = await fulfillUseCase.handover(preparing);

      expect(result, isA<Success<Order>>());
      expect((result as Success<Order>).value.status, OrderStatus.completed);

      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(8)); // 10 - 2

      expect(
        saleRepo.getById('sale_1')!.items.single.unitCost,
        const Money(minorUnits: 1000000, currency: 'IDR'),
      );
      expect(await inventoryRepo.getMovements('prod_100'), hasLength(1));
    });

    test('onsite: handover boleh langsung dari PAID (tanpa preparing)',
        () async {
      final order = await seedOrder();

      final paid = await paymentUseCase.confirm(order);
      final paidOrder = (paid as Success<Order>).value;

      final result = await fulfillUseCase.handover(paidOrder);

      expect(result, isA<Success<Order>>());
      expect((result as Success<Order>).value.status, OrderStatus.completed);

      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(8));
      expect(await inventoryRepo.getMovements('prod_100'), hasLength(1));
    });

    test('online: pickup = stock-out + pickedUp, lalu completeDelivery',
        () async {
      final order = await seedOrder(source: OrderSource.online);

      final paid = await paymentUseCase.confirm(order);
      final preparing = (paid as Success<Order>).value
          .transitionTo(OrderStatus.preparing);
      await orderRepo.update(preparing);
      final ready = preparing.transitionTo(OrderStatus.readyForPickup);
      await orderRepo.update(ready);

      // Sebelum pickup: stok utuh.
      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(10));

      final pickupResult = await fulfillUseCase.pickup(ready);
      expect(pickupResult, isA<Success<Order>>());
      final pickedUp = (pickupResult as Success<Order>).value;
      expect(pickedUp.status, OrderStatus.pickedUp);

      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(8));
      expect(await inventoryRepo.getMovements('prod_100'), hasLength(1));

      final delivered = await fulfillUseCase.completeDelivery(pickedUp);
      expect((delivered as Success<Order>).value.status, OrderStatus.completed);
      // Tidak ada konsumsi tambahan.
      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(8));
      expect(await inventoryRepo.getMovements('prod_100'), hasLength(1));
    });

    test('duplicate handover ditolak -> tidak double-consume', () async {
      final order = await seedOrder();
      final paid = await paymentUseCase.confirm(order);
      final preparing = (paid as Success<Order>).value
          .transitionTo(OrderStatus.preparing);
      await orderRepo.update(preparing);

      await fulfillUseCase.handover(preparing);

      final second = await fulfillUseCase.handover(preparing);
      expect(second, isA<Failure>());
      expect(
          (second as Failure).error.toString(), contains('INVALID_TRANSITION'));

      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(8));
      expect(await inventoryRepo.getMovements('prod_100'), hasLength(1));
    });

    test('stok kurang saat handover -> Failure, order tetap preparing, '
        'tanpa partial', () async {
      final order = await seedOrder(quantity: 15); // stok hanya 10

      final paid = await paymentUseCase.confirm(order);
      final preparing = (paid as Success<Order>).value
          .transitionTo(OrderStatus.preparing);
      await orderRepo.update(preparing);

      final result = await fulfillUseCase.handover(preparing);

      expect(result, isA<Failure>());
      expect(
          (result as Failure).error.toString(), contains('INSUFFICIENT_STOCK'));

      expect(orderRepo.getById(order.id)!.status, OrderStatus.preparing);
      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(10));
      expect(await inventoryRepo.getMovements('prod_100'), isEmpty);
    });

    test('channel salah ditolak', () async {
      final onlineOrder = await seedOrder(source: OrderSource.online);
      final onsiteOrder = await seedOrder(source: OrderSource.onsite);

      final handoverOnline = await fulfillUseCase.handover(onlineOrder);
      expect(handoverOnline, isA<Failure>());

      final pickupOnsite = await fulfillUseCase.pickup(onsiteOrder);
      expect(pickupOnsite, isA<Failure>());

      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(10));
    });

    test('payment gagal/expired tidak menyentuh stok dan tidak bisa handover',
        () async {
      final order = await seedOrder();
      final failed = await paymentUseCase.markFailed(order);

      final handoverResult =
          await fulfillUseCase.handover((failed as Success<Order>).value);
      expect(handoverResult, isA<Failure>());

      final expired = await paymentUseCase.markExpired(order);
      expect((expired as Success<Order>).value.status, OrderStatus.expired);

      expect((await costLayerRepo.getById('layer_001'))!.remainingQuantity.value,
          equals(10));
      expect(await inventoryRepo.getMovements('prod_100'), isEmpty);
    });
  });
}
