import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/domain/product_service.dart';

void main() {
  group('ProductService', () {
    const service = ProductService();

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

    test('updates product prices', () {
      final updated = service.updatePrices(
        product: product,
        purchasePrice: const Money(
          minorUnits: 13000,
          currency: 'IDR',
        ),
        sellingPrice: const Money(
          minorUnits: 17000,
          currency: 'IDR',
        ),
      );

      expect(updated.id, product.id);
      expect(updated.sku, product.sku);
      expect(updated.name, product.name);
      expect(updated.baseUnit, product.baseUnit);
      expect(
        updated.purchasePrice,
        const Money(
          minorUnits: 13000,
          currency: 'IDR',
        ),
      );
      expect(
        updated.sellingPrice,
        const Money(
          minorUnits: 17000,
          currency: 'IDR',
        ),
      );
    });

    test('activates inactive product', () {
      final inactive = product.copyWith(active: false);
      final active = service.activate(inactive);

      expect(inactive.active, isFalse);
      expect(active.active, isTrue);
    });

    test('deactivates active product', () {
      final inactive = service.deactivate(product);

      expect(product.active, isTrue);
      expect(inactive.active, isFalse);
    });

    test('preserves original product when updating', () {
      final updated = service.updatePrices(
        product: product,
        purchasePrice: const Money(
          minorUnits: 13000,
          currency: 'IDR',
        ),
        sellingPrice: const Money(
          minorUnits: 17000,
          currency: 'IDR',
        ),
      );

      expect(product.purchasePrice.minorUnits, 12000);
      expect(product.sellingPrice.minorUnits, 15000);
      expect(updated, isNot(same(product)));
    });
  });
}
