import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart_item.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';

void main() {
  group('CartItem', () {
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

    test('uses product selling price by default', () {
      final item = CartItem(
        product: createProduct(),
        quantity: Quantity(value: 2),
      );

      expect(
        item.unitPrice,
        const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );
    });

    test('calculates subtotal', () {
      final item = CartItem(
        product: createProduct(),
        quantity: Quantity(value: 3),
      );

      expect(
        item.subtotal,
        const Money(
          minorUnits: 45000,
          currency: 'IDR',
        ),
      );
    });

    test('supports an explicit unit price', () {
      final item = CartItem(
        product: createProduct(),
        quantity: Quantity(value: 2),
        unitPrice: const Money(
          minorUnits: 14000,
          currency: 'IDR',
        ),
      );

      expect(
        item.subtotal,
        const Money(
          minorUnits: 28000,
          currency: 'IDR',
        ),
      );
    });

    test('rejects zero quantity', () {
      expect(
        () => CartItem(
          product: createProduct(),
          quantity: Quantity.zero(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects negative unit price', () {
      expect(
        () => CartItem(
          product: createProduct(),
          quantity: Quantity(value: 1),
          unitPrice: const Money(
            minorUnits: -100,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
