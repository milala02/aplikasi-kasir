import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/application/product_use_cases.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/domain/product_repository.dart';

void main() {
  group('ProductUseCases', () {
    test('creates and retrieves a product', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);
      final product = createProduct();

      useCases.create(product);

      expect(useCases.getById(product.id), equals(product));
      expect(useCases.getBySku(product.sku), equals(product));
      expect(useCases.getAll(), contains(product));
      expect(useCases.getActive(), contains(product));
    });

    test('rejects duplicate product id', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      useCases.create(createProduct());

      expect(
        () => useCases.create(
          createProduct(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects duplicate SKU', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      useCases.create(createProduct());

      final duplicateSku = createProduct().copyWith(
        id: 'product-002',
      );

      expect(
        () => useCases.create(duplicateSku),
        throwsArgumentError,
      );
    });

    test('updates product prices', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      useCases.create(createProduct());

      useCases.updatePrices(
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

    test('activates and deactivates a product', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      useCases.create(createProduct());

      useCases.deactivate('product-001');
      expect(useCases.getById('product-001')?.active, isFalse);

      useCases.activate('product-001');
      expect(useCases.getById('product-001')?.active, isTrue);
    });

    test('deletes an existing product', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      useCases.create(createProduct());
      useCases.delete('product-001');

      expect(useCases.getById('product-001'), isNull);
    });

    test('rejects operations for missing products', () {
      final repository = _FakeProductRepository();
      final useCases = ProductUseCases(repository: repository);

      expect(
        () => useCases.updatePrices(
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

      expect(
        () => useCases.activate('missing'),
        throwsArgumentError,
      );

      expect(
        () => useCases.deactivate('missing'),
        throwsArgumentError,
      );

      expect(
        () => useCases.delete('missing'),
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
  void save(Product product) {
    _products[product.id] = product;
  }

  @override
  void update(Product product) {
    _products[product.id] = product;
  }

  @override
  void deleteById(String id) {
    _products.remove(id);
  }
}
