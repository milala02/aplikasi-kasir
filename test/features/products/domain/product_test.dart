import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';

void main() {
  group('Product', () {
    test('creates an active product by default', () {
      const product = Product(
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

      expect(product.id, 'product-001');
      expect(product.sku, 'SKU-001');
      expect(product.name, 'Beras Premium');
      expect(product.baseUnit, Unit.kilogram);
      expect(product.active, isTrue);
    });

    test('stores purchase and selling prices', () {
      const product = Product(
        id: 'product-002',
        sku: 'SKU-002',
        name: 'Minyak Goreng',
        baseUnit: Unit.liter,
        purchasePrice: Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 18000,
          currency: 'IDR',
        ),
      );

      expect(
        product.purchasePrice,
        const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );

      expect(
        product.sellingPrice,
        const Money(
          minorUnits: 18000,
          currency: 'IDR',
        ),
      );
    });

    test('copyWith creates an updated product', () {
      const product = Product(
        id: 'product-003',
        sku: 'SKU-003',
        name: 'Gula',
        baseUnit: Unit.kilogram,
        purchasePrice: Money(
          minorUnits: 14000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 17000,
          currency: 'IDR',
        ),
      );

      final updated = product.copyWith(
        sellingPrice: const Money(
          minorUnits: 17500,
          currency: 'IDR',
        ),
      );

      expect(updated.id, product.id);
      expect(updated.name, product.name);
      expect(
        updated.sellingPrice,
        const Money(
          minorUnits: 17500,
          currency: 'IDR',
        ),
      );
    });

    test('can deactivate a product', () {
      const product = Product(
        id: 'product-004',
        sku: 'SKU-004',
        name: 'Kopi',
        baseUnit: Unit.pack,
        purchasePrice: Money(
          minorUnits: 8000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 10000,
          currency: 'IDR',
        ),
      );

      final inactive = product.copyWith(active: false);

      expect(product.active, isTrue);
      expect(inactive.active, isFalse);
    });

    test('products with the same id are equal', () {
      const first = Product(
        id: 'product-005',
        sku: 'SKU-005',
        name: 'Teh',
        baseUnit: Unit.box,
        purchasePrice: Money(
          minorUnits: 5000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 7000,
          currency: 'IDR',
        ),
      );

      const second = Product(
        id: 'product-005',
        sku: 'SKU-999',
        name: 'Teh Premium',
        baseUnit: Unit.box,
        purchasePrice: Money(
          minorUnits: 6000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 9000,
          currency: 'IDR',
        ),
      );

      expect(first, equals(second));
    });

    test('products with different ids are not equal', () {
      const first = Product(
        id: 'product-006',
        sku: 'SKU-006',
        name: 'Teh',
        baseUnit: Unit.box,
        purchasePrice: Money(
          minorUnits: 5000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 7000,
          currency: 'IDR',
        ),
      );

      const second = Product(
        id: 'product-007',
        sku: 'SKU-007',
        name: 'Teh',
        baseUnit: Unit.box,
        purchasePrice: Money(
          minorUnits: 5000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: 7000,
          currency: 'IDR',
        ),
      );

      expect(first, isNot(equals(second)));
    });
  });
}
