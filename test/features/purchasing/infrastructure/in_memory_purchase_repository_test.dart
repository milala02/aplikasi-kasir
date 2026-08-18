import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_item.dart';
import 'package:aplikasi_kasir/features/purchasing/infrastructure/in_memory_purchase_repository.dart';

void main() {
  group('InMemoryPurchaseRepository', () {
    test('saves and retrieves a purchase by id', () {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase();

      repository.save(purchase);

      expect(repository.getById(purchase.id), purchase);
    });

    test('returns null when purchase does not exist', () {
      final repository = InMemoryPurchaseRepository();

      expect(repository.getById('missing'), isNull);
    });

    test('finds purchase by reference number', () {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase(
        referenceNumber: 'INV-001',
      );

      repository.save(purchase);

      expect(
        repository.getByReferenceNumber('INV-001'),
        purchase,
      );
    });

    test('returns null when reference number does not exist', () {
      final repository = InMemoryPurchaseRepository();

      repository.save(
        createPurchase(referenceNumber: 'INV-001'),
      );

      expect(
        repository.getByReferenceNumber('INV-999'),
        isNull,
      );
    });

    test('returns null when purchase has no reference number', () {
      final repository = InMemoryPurchaseRepository();

      repository.save(
        createPurchase(),
      );

      expect(
        repository.getByReferenceNumber('INV-001'),
        isNull,
      );
    });

    test('returns all purchases', () {
      final repository = InMemoryPurchaseRepository();
      final first = createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-001',
      );
      final second = createPurchase(
        id: 'purchase-002',
        referenceNumber: 'INV-002',
      );

      repository.save(first);
      repository.save(second);

      expect(
        repository.getAll(),
        [first, second],
      );
    });

    test('returns empty list when repository is empty', () {
      final repository = InMemoryPurchaseRepository();

      expect(repository.getAll(), isEmpty);
    });

    test('rejects duplicate purchase id on save', () {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase(
        id: 'purchase-001',
      );

      repository.save(purchase);

      expect(
        () => repository.save(purchase),
        throwsStateError,
      );
    });

    test('updates an existing purchase', () {
      final repository = InMemoryPurchaseRepository();
      final original = createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-001',
      );

      repository.save(original);

      final updated = createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-002',
      );

      repository.update(updated);

      expect(repository.getById('purchase-001'), updated);
      expect(
        repository.getByReferenceNumber('INV-002'),
        updated,
      );
      expect(
        repository.getByReferenceNumber('INV-001'),
        isNull,
      );
    });

    test('rejects updating a missing purchase', () {
      final repository = InMemoryPurchaseRepository();

      expect(
        () => repository.update(
          createPurchase(id: 'missing'),
        ),
        throwsStateError,
      );
    });

    test('deletes an existing purchase', () {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase(
        id: 'purchase-001',
      );

      repository.save(purchase);
      repository.deleteById(purchase.id);

      expect(repository.getById(purchase.id), isNull);
      expect(repository.getAll(), isEmpty);
    });

    test('rejects deleting a missing purchase', () {
      final repository = InMemoryPurchaseRepository();

      expect(
        () => repository.deleteById('missing'),
        throwsStateError,
      );
    });
  });
}

Purchase createPurchase({
  String id = 'purchase-001',
  String? referenceNumber = 'INV-001',
}) {
  return Purchase(
    id: id,
    purchasedAt: DateTime(2026, 8, 18, 10, 30),
    supplierId: 'supplier-001',
    referenceNumber: referenceNumber,
    items: [
      PurchaseItem(
        id: 'item-001',
        productId: 'pepper',
        quantity: Quantity(value: 1),
        unitCost: const Money(
          minorUnits: 160000,
          currency: 'IDR',
        ),
      ),
    ],
  );
}
