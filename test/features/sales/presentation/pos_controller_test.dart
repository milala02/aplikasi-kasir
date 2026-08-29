import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/customers/infrastructure/in_memory_customer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/fulfill_order_use_case.dart';
import 'package:aplikasi_kasir/features/orders/application/order_payment_use_case.dart';
import 'package:aplikasi_kasir/features/orders/application/process_stock_out_use_case.dart';
import 'package:aplikasi_kasir/features/orders/application/submit_order_use_case.dart';
import 'package:aplikasi_kasir/features/orders/domain/order.dart';
import 'package:aplikasi_kasir/features/orders/infrastructure/in_memory_order_repository.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/sales/application/process_sale_use_case.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';
import 'package:aplikasi_kasir/features/sales/presentation/pos_controller.dart';

void main() {
  group('POSController Presentation Test', () {
    late InMemoryProductRepository productRepo;
    late InMemoryCustomerRepository customerRepo;
    late InMemorySaleRepository saleRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryOrderRepository orderRepo;
    late POSController controller;

    setUp(() async {
      productRepo = InMemoryProductRepository();
      customerRepo = InMemoryCustomerRepository();
      saleRepo = InMemorySaleRepository();
      inventoryRepo = InMemoryInventoryRepository();
      costLayerRepo = InMemoryCostLayerRepository();
      orderRepo = InMemoryOrderRepository();

      final processSaleUseCase =
          ProcessSaleUseCase(saleRepository: saleRepo);
      final submitOrderUseCase = SubmitOrderUseCase(
        processSaleUseCase: processSaleUseCase,
        saleRepository: saleRepo,
        orderRepository: orderRepo,
      );
      final orderPaymentUseCase =
          OrderPaymentUseCase(orderRepository: orderRepo);
      final processStockOutUseCase = ProcessStockOutUseCase(
        costLayerService: CostLayerService(repository: costLayerRepo),
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
        saleRepository: saleRepo,
      );
      final fulfillOrderUseCase = FulfillOrderUseCase(
        orderRepository: orderRepo,
        saleRepository: saleRepo,
        processStockOutUseCase: processStockOutUseCase,
      );

      controller = POSController(
        productRepository: productRepo,
        customerRepository: customerRepo,
        submitOrderUseCase: submitOrderUseCase,
        orderPaymentUseCase: orderPaymentUseCase,
        fulfillOrderUseCase: fulfillOrderUseCase,
        saleRepository: saleRepo,
      );

      // Seed product
      productRepo.save(
        const Product(
          id: 'prod_001',
          sku: 'SKU001',
          name: 'Beras Ramos 5kg',
          baseUnit: Unit.pcs,
          purchasePrice: Money(minorUnits: 6000000, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 7500000, currency: 'IDR'),
        ),
      );

      // Seed cost layer FIFO agar stock-out dapat mengonsumsi stok.
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_prod_001',
          productId: 'prod_001',
          originalQuantity: Quantity(value: 100, scale: 0),
          remainingQuantity: Quantity(value: 100, scale: 0),
          unitCost: const Money(minorUnits: 6000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );
    });

    test('Harus memuat produk aktif dan menambah item ke keranjang', () {
      controller.init();
      expect(controller.products.length, equals(1));

      final product = controller.products.first;
      controller.addToCart(product);

      expect(controller.cart.items.length, equals(1));
      expect(controller.cart.subtotal?.minorUnits, equals(7500000));
    });

    test('checkout tunai: order langsung PAID, sale tercatat, cart kosong, '
        'stok BELUM berkurang', () async {
      controller.init();
      controller.addToCart(controller.products.first);

      final success = await controller.checkout(
        invoiceNumber: 'INV-TEST-001',
        paymentMethod: OrderPaymentMethod.cash,
      );

      expect(success, isTrue);
      expect(controller.cart.items.isEmpty, isTrue);
      expect(saleRepo.getAll().length, equals(1));

      final order = controller.lastOrder;
      expect(order, isNotNull);
      expect(order!.status, OrderStatus.paid);

      // Payment/submit tidak menyentuh stok.
      final layer = await costLayerRepo.getById('layer_prod_001');
      expect(layer!.remainingQuantity.value, equals(100));
      expect(await inventoryRepo.getMovements('prod_001'), isEmpty);
    });

    test('checkout QRIS: order PENDING_PAYMENT, konfirmasi -> PAID', () async {
      controller.init();
      controller.addToCart(controller.products.first);

      await controller.checkout(
        invoiceNumber: 'INV-TEST-002',
        paymentMethod: OrderPaymentMethod.qris,
      );

      expect(controller.lastOrder!.status, OrderStatus.pendingPayment);

      final ok = await controller.confirmPaymentForLastOrder();
      expect(ok, isTrue);
      expect(controller.lastOrder!.status, OrderStatus.paid);
    });

    test('handover onsite: stock-out FIFO + HPP terkunci', () async {
      controller.init();
      controller.addToCart(controller.products.first);

      await controller.checkout(
        invoiceNumber: 'INV-TEST-003',
        paymentMethod: OrderPaymentMethod.cash,
      );

      final ok = await controller.completeHandover();
      expect(ok, isTrue);
      expect(controller.lastOrder!.status, OrderStatus.completed);

      final layer = await costLayerRepo.getById('layer_prod_001');
      expect(layer!.remainingQuantity.value, equals(99));

      final sale = saleRepo.getById(controller.lastOrder!.saleId);
      expect(sale!.items.single.unitCost,
          const Money(minorUnits: 6000000, currency: 'IDR'));
      expect(await inventoryRepo.getMovements('prod_001'), hasLength(1));
    });
  });
}
