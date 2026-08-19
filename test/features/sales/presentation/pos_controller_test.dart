import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/customers/infrastructure/in_memory_customer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
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
    late ProcessSaleUseCase processSaleUseCase;
    late POSController controller;

    setUp(() {
      productRepo = InMemoryProductRepository();
      customerRepo = InMemoryCustomerRepository();
      saleRepo = InMemorySaleRepository();
      inventoryRepo = InMemoryInventoryRepository();
      processSaleUseCase = ProcessSaleUseCase(
        saleRepository: saleRepo,
        inventoryRepository: inventoryRepo,
      );

      controller = POSController(
        productRepository: productRepo,
        customerRepository: customerRepo,
        processSaleUseCase: processSaleUseCase,
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
    });

    test('Harus memuat produk aktif dan menambah item ke keranjang', () {
      controller.init();
      expect(controller.products.length, equals(1));

      final product = controller.products.first;
      controller.addToCart(product);

      expect(controller.cart.items.length, equals(1));
      expect(controller.cart.subtotal?.minorUnits, equals(7500000));
    });

    test('Harus memproses checkout transaksi dan mengosongkan keranjang', () {
      controller.init();
      controller.addToCart(controller.products.first);

      final success = controller.checkout(invoiceNumber: 'INV-TEST-001');
      expect(success, isTrue);
      expect(controller.cart.items.isEmpty, isTrue);
      expect(saleRepo.getAll().length, equals(1));
    });
  });
}
