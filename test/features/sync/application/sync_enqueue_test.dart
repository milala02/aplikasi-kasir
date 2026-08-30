import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/submit_order_use_case.dart';
import 'package:aplikasi_kasir/features/orders/domain/order.dart';
import 'package:aplikasi_kasir/features/orders/infrastructure/in_memory_order_repository.dart';
import 'package:aplikasi_kasir/features/products/application/product_use_cases.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/receiving/application/receive_goods_use_case.dart';
import 'package:aplikasi_kasir/features/receiving/domain/receiving.dart';
import 'package:aplikasi_kasir/features/receiving/infrastructure/in_memory_receiving_repository.dart';
import 'package:aplikasi_kasir/features/sales/application/process_sale_use_case.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';
import 'package:aplikasi_kasir/features/sync/application/sync_enqueue_service.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_uuid.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_sync_queue_repository.dart';

void main() {
  group('Sync enqueue setelah commit sukses', () {
    late InMemorySyncQueueRepository queueRepo;
    late SyncEnqueueService enqueueService;

    setUp(() {
      queueRepo = InMemorySyncQueueRepository();
      enqueueService = SyncEnqueueService(repository: queueRepo);
    });

    test('sale -> entri PENDING sourceTable=sale dengan payload lengkap',
        () async {
      final saleRepo = InMemorySaleRepository();
      final useCase = ProcessSaleUseCase(
        saleRepository: saleRepo,
        syncEnqueueService: enqueueService,
      );

      final sale = Sale(
        id: 'sale_1',
        invoiceNumber: 'INV-001',
        items: [
          SaleItem(
            productId: 'prod_100',
            productName: 'Beras',
            unit: Unit.kilogram,
            quantity: Quantity(value: 2, scale: 0),
            unitPrice: const Money(minorUnits: 1500000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime(2026, 8, 20),
      );

      final result = await useCase.execute(sale);
      expect(result, isA<Success<Sale>>());

      final pending = await queueRepo.getPending();
      expect(pending, hasLength(1));
      expect(pending.single.sourceTable, 'sale');
      expect(pending.single.status, SyncQueueStatus.pending);
      expect(pending.single.endpoint, '/api/v1/sync/push');

      final payload = jsonDecode(pending.single.payloadJson);
      expect(payload['id'], 'sale_1');
      expect(payload['invoice_number'], 'INV-001');
      expect((payload['items'] as List).single['product_id'], 'prod_100');
    });

    test(
        'order submit -> entri PENDING sourceTable=order, payload sesuai '
        'domain.SyncPushPayload (orders wrapper + camelCase + uuid)', () async {
      final saleRepo = InMemorySaleRepository();
      final orderRepo = InMemoryOrderRepository();
      final useCase = SubmitOrderUseCase(
        processSaleUseCase: ProcessSaleUseCase(saleRepository: saleRepo),
        saleRepository: saleRepo,
        orderRepository: orderRepo,
        syncEnqueueService: enqueueService,
      );

      final result = await useCase.submit(
        orderId: 'ord_1',
        saleId: 'sale_1',
        invoiceNumber: 'INV-001',
        source: OrderSource.online,
        paymentMethod: OrderPaymentMethod.qris,
        items: [
          SaleItem(
            productId: 'prod_100',
            productName: 'Beras',
            unit: Unit.kilogram,
            quantity: Quantity(value: 2, scale: 0),
            unitPrice: const Money(minorUnits: 1500000, currency: 'IDR'),
          ),
        ],
        submittedAt: DateTime(2026, 8, 20),
      );
      expect(result, isA<Success<Order>>());

      final pending = await queueRepo.getPending();
      expect(pending.single.sourceTable, 'order');
      expect(pending.single.referenceId, 'ord_1');

      final payload = jsonDecode(pending.single.payloadJson);
      // Strict: hanya kunci `orders` di level atas.
      expect((payload as Map<String, dynamic>).keys.toSet(), {'orders'});
      final orders = payload['orders'] as List;
      expect(orders, hasLength(1));

      final order = orders.single as Map<String, dynamic>;
      expect(order.keys.toSet(), {
        'id',
        'orderNumber',
        'channel',
        'totalAmountMinorUnits',
        'createdAt',
        'items',
      });
      expect(order['id'], SyncUuid.entity('ord_1'));
      expect(order['orderNumber'], 'INV-001');
      expect(order['channel'], 'online');
      expect(order['totalAmountMinorUnits'], 3000000);
      expect(order['createdAt'], '2026-08-20T00:00:00.000Z');

      final item = (order['items'] as List).single as Map<String, dynamic>;
      expect(item.keys.toSet(), {
        'productId',
        'enteredQuantity',
        'enteredUomId',
        'normalizedStockQty',
        'stockUomId',
        'priceMinorUnits',
        'subtotalMinorUnits',
      });
      expect(item['productId'], SyncUuid.entity('prod_100'));
      expect(item['enteredQuantity'], 2);
      expect(item['enteredUomId'], SyncUuid.uom('kilogram'));
      expect(item['normalizedStockQty'], 2);
      expect(item['stockUomId'], SyncUuid.uom('kilogram'));
      expect(item['priceMinorUnits'], 1500000);
      expect(item['subtotalMinorUnits'], 3000000);
    });

    test('receiving -> entri PENDING sourceTable=receiving', () async {
      final receivingRepo = InMemoryReceivingRepository();
      final useCase = ReceiveGoodsUseCase(
        receivingRepository: receivingRepo,
        inventoryRepository: InMemoryInventoryRepository(),
        costLayerRepository: InMemoryCostLayerRepository(),
        syncEnqueueService: enqueueService,
      );

      final result = await useCase.execute(
        Receiving(
          id: 'recv_1',
          purchaseId: 'po_1',
          receivedAt: DateTime(2026, 8, 20),
          items: [
            ReceivingItem(
              id: 'ri_1',
              productId: 'prod_100',
              quantityReceived: Quantity(value: 5, scale: 0),
              unit: Unit.kilogram,
              unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
            ),
          ],
        ),
      );
      expect(result, isA<Success>());

      final pending = await queueRepo.getPending();
      expect(pending.single.sourceTable, 'receiving');
      final payload = jsonDecode(pending.single.payloadJson);
      expect(payload['id'], 'recv_1');
      expect(payload['purchase_id'], 'po_1');
      expect((payload['items'] as List).single['unit'], 'kilogram');
    });

    test('product create -> entri PENDING sourceTable=product', () async {
      final productRepo = InMemoryProductRepository();
      final useCases = ProductUseCases(
        repository: productRepo,
        syncEnqueueService: enqueueService,
      );

      await useCases.create(
        const Product(
          id: 'prod_100',
          sku: 'BM-001',
          name: 'Bawang Merah',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 1000000, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 1500000, currency: 'IDR'),
        ),
      );

      final pending = await queueRepo.getPending();
      expect(pending.single.sourceTable, 'product');
      final payload = jsonDecode(pending.single.payloadJson);
      expect(payload['id'], 'prod_100');
      expect(payload['name'], 'Bawang Merah');
      expect(payload['base_unit'], 'kilogram');
    });
  });
}
