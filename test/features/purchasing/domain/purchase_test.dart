import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_item.dart';

void main() {
  group('Purchase', () {
    test('calculates total cost from all items', () {
      final purchase = Purchase(
        id: 'purchase-001',
        purchasedAt: DateTime(2026, 8, 18),
        supplierId: 'supplier-001',
        referenceNumber: 'INV-001',
        items: [
          createItem(
            id: 'item-001',
            productId: 'pepper',
            quantity: Quantity(value: 1),
            unitCost: const Money(
              minorUnits: 160000,
              currency: 'IDR',
            ),
          ),
          createItem(
            id: 'item-002',
            productId: 'onion',
            quantity: Quantity(value: 2),
            unitCost: const Money(
              minorUnits: 30000,
              currency: 'IDR',
            ),
          ),
        ],
      );

      expect(
        purchase.totalCost,
        const Money(
          minorUnits: 220000,
          currency: 'IDR',
        ),
      );
    });

    test('keeps purchase metadata', () {
      final purchasedAt = DateTime(2026, 8, 18, 10, 30);

      final purchase = Purchase(
        id: 'purchase-001',
        purchasedAt: purchasedAt,
        supplierId: 'supplier-001',
        referenceNumber: 'INV-001',
        items: [createItem()],
      );

      expect(purchase.id, 'purchase-001');
      expect(purchase.purchasedAt, purchasedAt);
      expect(purchase.supplierId, 'supplier-001');
      expect(purchase.referenceNumber, 'INV-001');
      expect(purchase.items.length, 1);
    });

    test('supports purchase without optional supplier metadata', () {
      final purchase = Purchase(
        id: 'purchase-002',
        purchasedAt: DateTime(2026, 8, 18),
        items: [createItem()],
      );

      expect(purchase.supplierId, isNull);
      expect(purchase.referenceNumber, isNull);
    });

    test('rejects empty purchase id through assertion', () {
      expect(
        () => Purchase(
          id: '',
          purchasedAt: DateTime(2026, 8, 18),
          items: [createItem()],
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects purchase without items through assertion', () {
      expect(
        () => Purchase(
          id: 'purchase-003',
          purchasedAt: DateTime(2026, 8, 18),
          items: const [],
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}

PurchaseItem createItem({
  String id = 'item-001',
  String productId = 'pepper',
  Quantity? quantity,
  Money? unitCost,
}) {
  return PurchaseItem(
    id: id,
    productId: productId,
    quantity: quantity ?? Quantity(value: 1),
    unitCost: unitCost ??
        const Money(
          minorUnits: 160000,
          currency: 'IDR',
        ),
  );
}
