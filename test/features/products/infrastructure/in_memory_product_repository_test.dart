import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';

void main() {
  group('InMemoryProductRepository', () {
    test('saves and retrieves products', () {
      final repository = InMemoryProductRepository();
      final product = createProduct();

      repository.save(product);

      expect(repository.getById(product.id), equals(product));
      expect(repository.getBySku(product.sku), equals(product));
    });

    test('returns active products only', () {
      final repository = InMemoryProductRepository();
      final active = createProduct();
      final inactive = active.copyWith(
        id: 'product-002',
        sku: 'SKU-002',
        active: false,
      );

      repository.save(active);
      repository.save(inactive);

      expect(repository.getAll(), hasLength(2));
      expect(repository.getActive(), [active]);
    });

    test('rejects duplicate id', () {
      final repository = InMemoryProductRepository();
      final product = createProduct();

      repository.save(product);

      expect(
        () => repository.save(product),
        throwsArgumentError,
      );
    });

    test('rejects duplicate sku', () {
      final repository = InMemoryProductRepository();
      final product = createProduct();
      final duplicateSku = product.copyWith(
        id: 'product-002',
      );

      repository.save(product);

      expect(
        () => repository.save(duplicateSku),
        throwsArgumentError,
      );
    });

    test('updates an existing product', () {
      final repository = InMemoryProductRepository();
      final product = createProduct();

      repository.save(product);

      final updated = product.copyWith(
        sellingPrice: const Money(
          minorUnits: 16000,
          currency: 'IDR',
        ),
      );

      repository.update(updated);

      expect(repository.getById(product.id), equals(updated));
    });

    test('deletes a product', () {
      final repository = InMemoryProductRepository();
      final product = createProduct();

      repository.save(product);
      repository.deleteById(product.id);

      expect(repository.getById(product.id), isNull);
    });
  });
}

Product createProduct() {
  return const Product(
    id: 'product-001',
    sku: 'SKU-001',
    name: 'Beras Premium',
    baseUnit: Unit.kilogram,
    purchasePrice: Money(
      minorUnits: 12000,
      currency: 'IDR',
    ),
    sellingPrice: Money(
      minorUnits: 15000,
      currency: 'IDR',
    ),
  );
}
