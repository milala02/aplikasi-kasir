import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/application/product_use_cases.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/domain/product_repository.dart';

void main() {
  group('ProductUseCases', () {
    test('creates and retrieves a product', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);
      final product = createProduct();

      await useCases.create(product);

      expect(useCases.getById(product.id), equals(product));
      expect(useCases.getBySku(product.sku), equals(product));
      expect(useCases.getAll(), contains(product));
      expect(useCases.getActive(), contains(product));
    });

    test('rejects duplicate product id', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      await useCases.create(createProduct());

      await expectLater(
        useCases.create(
          createProduct(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects duplicate SKU', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      await useCases.create(createProduct());

      final duplicateSku = createProduct().copyWith(
        id: 'product-002',
      );

      await expectLater(
        useCases.create(duplicateSku),
        throwsArgumentError,
      );
    });

    test('updates product prices', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      await useCases.create(createProduct());

      await useCases.updatePrices(
        productId: 'product-001',
        purchasePrice: const Money(
          minorUnits: 13000,
          currency: 'IDR',
        ),
        sellingPrice: const Money(
          minorUnits: 16000,
          currency: 'IDR',
        ),
      );

      final updated = useCases.getById('product-001');

      expect(
        updated?.purchasePrice,
        const Money(
          minorUnits: 13000,
          currency: 'IDR',
        ),
      );

      expect(
        updated?.sellingPrice,
        const Money(
          minorUnits: 16000,
          currency: 'IDR',
        ),
      );
    });

    test('activates and deactivates a product', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      await useCases.create(createProduct());

      await useCases.deactivate('product-001');
      expect(useCases.getById('product-001')?.active, isFalse);

      await useCases.activate('product-001');
      expect(useCases.getById('product-001')?.active, isTrue);
    });

    test('deletes an existing product', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      await useCases.create(createProduct());
      await useCases.delete('product-001');

      expect(useCases.getById('product-001'), isNull);
    });

    test('rejects operations for missing products', () async {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      await expectLater(
        useCases.updatePrices(
          productId: 'missing',
          purchasePrice: const Money(
            minorUnits: 10000,
            currency: 'IDR',
          ),
          sellingPrice: const Money(
            minorUnits: 12000,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );

      await expectLater(
        useCases.activate('missing'),
        throwsArgumentError,
      );

      await expectLater(
        useCases.deactivate('missing'),
        throwsArgumentError,
      );

      await expectLater(
        useCases.delete('missing'),
        throwsArgumentError,
      );
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
