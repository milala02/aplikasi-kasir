import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/domain/product_repository.dart';

void main() {
  group('ProductRepository', () {
    test('defines the required product repository contract', () {
      expect(ProductRepository, isNotNull);
    });

    test('repository contract exposes product operations', () async {
      final repository = _FakeProductRepository();

      final product = Product(
        id: 'product-001',
        sku: 'SKU-001',
        name: 'Beras Premium',
        baseUnit: Unit.kilogram,
        purchasePrice: const Money(
          minorUnits: 12000,
          currency: 'IDR',
        ),
        sellingPrice: const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );

      await repository.save(product);

      expect(repository.getById('product-001'), equals(product));
      expect(repository.getBySku('SKU-001'), equals(product));
      expect(repository.getAll(), contains(product));
      expect(repository.getActive(), contains(product));
    });

    test('repository can update and delete a product', () async {
      final repository = _FakeProductRepository();

      final product = Product(
        id: 'product-002',
        sku: 'SKU-002',
        name: 'Minyak Goreng',
        baseUnit: Unit.liter,
        purchasePrice: const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
        sellingPrice: const Money(
          minorUnits: 18000,
          currency: 'IDR',
        ),
      );

      await repository.save(product);

      final updated = product.copyWith(
        sellingPrice: const Money(
          minorUnits: 20000,
          currency: 'IDR',
        ),
      );

      await repository.update(updated);

      expect(
        repository.getById('product-002')?.sellingPrice,
        const Money(
          minorUnits: 20000,
          currency: 'IDR',
        ),
      );

      await repository.deleteById('product-002');

      expect(repository.getById('product-002'), isNull);
    });
  });
}

class _FakeProductRepository implements ProductRepository {
  final Map<String, Product> _products = {};

  @override
  Product? getById(String id) => _products[id];

  @override
  Product? getBySku(String sku) {
    for (final product in _products.values) {
      if (product.sku == sku) {
        return product;
      }
    }
    return null;
  }

  @override
  List<Product> getAll() => List.unmodifiable(_products.values);

  @override
  List<Product> getActive() {
    return List.unmodifiable(
      _products.values.where((product) => product.active),
    );
  }

  @override
  Future<void> save(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> update(Product product) async {
    _products[product.id] = product;
  }

  @override
  Future<void> deleteById(String id) async {
    _products.remove(id);
  }
}
