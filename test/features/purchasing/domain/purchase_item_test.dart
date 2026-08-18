import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_item.dart';

void main() {
  group('PurchaseItem', () {
    const unitCost = Money(
      minorUnits: 160000,
      currency: 'IDR',
    );

    test('calculates total cost for whole quantity', () {
      final item = PurchaseItem(
        id: 'item-001',
        productId: 'pepper',
        quantity: Quantity(value: 1),
        unitCost: unitCost,
      );

      expect(
        item.totalCost,
        const Money(
          minorUnits: 160000,
          currency: 'IDR',
        ),
      );
    });

    test('calculates total cost for 500 grams', () {
      final item = PurchaseItem(
        id: 'item-002',
        productId: 'pepper',
        quantity: Quantity(
          value: 500,
          scale: 3,
        ),
        unitCost: unitCost,
      );

      expect(
        item.totalCost,
        const Money(
          minorUnits: 80000,
          currency: 'IDR',
        ),
      );
    });

    test('calculates total cost for 250 grams', () {
      final item = PurchaseItem(
        id: 'item-003',
        productId: 'pepper',
        quantity: Quantity(
          value: 250,
          scale: 3,
        ),
        unitCost: unitCost,
      );

      expect(
        item.totalCost,
        const Money(
          minorUnits: 40000,
          currency: 'IDR',
        ),
      );
    });

    test('calculates total cost without floating point arithmetic', () {
      final item = PurchaseItem(
        id: 'item-004',
        productId: 'pepper',
        quantity: Quantity(
          value: 333,
          scale: 3,
        ),
        unitCost: unitCost,
      );

      expect(
        item.totalCost,
        const Money(
          minorUnits: 53280,
          currency: 'IDR',
        ),
      );
    });

    test('zero quantity has zero total cost', () {
      final item = PurchaseItem(
        id: 'item-005',
        productId: 'pepper',
        quantity: Quantity.zero(),
        unitCost: unitCost,
      );

      expect(
        item.totalCost,
        const Money(
          minorUnits: 0,
          currency: 'IDR',
        ),
      );
    });
  });

group('PurchaseItem validation', () {
    test('rejects an empty item id', () {
      expect(
        () => PurchaseItem(
          id: '',
          productId: 'pepper',
          quantity: Quantity(value: 1),
          unitCost: const Money(
            minorUnits: 160000,
            currency: 'IDR',
          ),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects an empty product id', () {
      expect(
        () => PurchaseItem(
          id: 'item-001',
          productId: '',
          quantity: Quantity(value: 1),
          unitCost: const Money(
            minorUnits: 160000,
            currency: 'IDR',
          ),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects zero quantity', () {
      expect(
        () => PurchaseItem(
          id: 'item-001',
          productId: 'pepper',
          quantity: Quantity.zero(),
          unitCost: const Money(
            minorUnits: 160000,
            currency: 'IDR',
          ),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects negative unit cost', () {
      expect(
        () => PurchaseItem(
          id: 'item-001',
          productId: 'pepper',
          quantity: Quantity(value: 1),
          unitCost: const Money(
            minorUnits: -1,
            currency: 'IDR',
          ),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
