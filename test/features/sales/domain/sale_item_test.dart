import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('SaleItem', () {
    test('creates a valid sale item', () {
      final item = SaleItem(
        productId: 'product-001',
        productName: 'Beras Premium',
        unit: Unit.kilogram,
        quantity: Quantity(value: 2),
        unitPrice: Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );

      expect(item.productId, 'product-001');
      expect(item.productName, 'Beras Premium');
      expect(item.unit, Unit.kilogram);
      expect(item.quantity, Quantity(value: 2));
    });

    test('calculates subtotal from quantity and unit price', () {
      final item = SaleItem(
        productId: 'product-002',
        productName: 'Minyak Goreng',
        unit: Unit.liter,
        quantity: Quantity(value: 3),
        unitPrice: Money(
          minorUnits: 18000,
          currency: 'IDR',
        ),
      );

      expect(
        item.subtotal,
        const Money(
          minorUnits: 54000,
          currency: 'IDR',
        ),
      );
    });

    test('supports scaled quantity', () {
      final item = SaleItem(
        productId: 'product-003',
        productName: 'Gula',
        unit: Unit.kilogram,
        quantity: Quantity(
          value: 500,
          scale: 3,
        ),
        unitPrice: Money(
          minorUnits: 16000,
          currency: 'IDR',
        ),
      );

      expect(
        item.subtotal,
        const Money(
          minorUnits: 8000000,
          currency: 'IDR',
        ),
      );
    });

    test('rejects empty product id', () {
      expect(
        () => SaleItem(
          productId: '',
          productName: 'Beras',
          unit: Unit.kilogram,
          quantity: Quantity(value: 1),
          unitPrice: const Money(
            minorUnits: 10000,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects empty product name', () {
      expect(
        () => SaleItem(
          productId: 'product-001',
          productName: '',
          unit: Unit.kilogram,
          quantity: Quantity(value: 1),
          unitPrice: const Money(
            minorUnits: 10000,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects zero quantity', () {
      expect(
        () => SaleItem(
          productId: 'product-001',
          productName: 'Beras',
          unit: Unit.kilogram,
          quantity: Quantity.zero(),
          unitPrice: const Money(
            minorUnits: 10000,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects negative unit price', () {
      expect(
        () => SaleItem(
          productId: 'product-001',
          productName: 'Beras',
          unit: Unit.kilogram,
          quantity: Quantity(value: 1),
          unitPrice: const Money(
            minorUnits: -10000,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('items with identical values are equal', () {
      final first = SaleItem(
        productId: 'product-001',
        productName: 'Beras',
        unit: Unit.kilogram,
        quantity: Quantity(value: 2),
        unitPrice: Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );

      final second = SaleItem(
        productId: 'product-001',
        productName: 'Beras',
        unit: Unit.kilogram,
        quantity: Quantity(value: 2),
        unitPrice: Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );

      expect(first, equals(second));
    });
  });
}
