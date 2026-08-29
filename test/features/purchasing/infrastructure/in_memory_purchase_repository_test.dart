import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_item.dart';
import 'package:aplikasi_kasir/features/purchasing/infrastructure/in_memory_purchase_repository.dart';

void main() {
  group('InMemoryPurchaseRepository', () {
    test('saves and retrieves a purchase by id', () async {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase();

      await repository.save(purchase);

      expect(await repository.getById(purchase.id), purchase);
    });

    test('returns null when purchase does not exist', () async {
      final repository = InMemoryPurchaseRepository();

      expect(await repository.getById('missing'), isNull);
    });

    test('finds purchase by reference number', () async {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase(
        referenceNumber: 'INV-001',
      );

      await repository.save(purchase);

      expect(
        await repository.getByReferenceNumber('INV-001'),
        purchase,
      );
    });

    test('returns null when reference number does not exist', () async {
      final repository = InMemoryPurchaseRepository();

      await repository.save(
        createPurchase(referenceNumber: 'INV-001'),
      );

      expect(
        await repository.getByReferenceNumber('INV-999'),
        isNull,
      );
    });

    test('returns null when purchase has no reference number', () async {
      final repository = InMemoryPurchaseRepository();

      await repository.save(
        createPurchase(referenceNumber: null),
      );

      expect(
        await repository.getByReferenceNumber('INV-001'),
        isNull,
      );
    });

    test('returns all purchases', () async {
      final repository = InMemoryPurchaseRepository();
      final first = createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-001',
      );
      final second = createPurchase(
        id: 'purchase-002',
        referenceNumber: 'INV-002',
      );

      await repository.save(first);
      await repository.save(second);

      expect(
        await repository.getAll(),
        [first, second],
      );
    });

    test('returns empty list when repository is empty', () async {
      final repository = InMemoryPurchaseRepository();

      expect(await repository.getAll(), isEmpty);
    });

    test('rejects duplicate purchase id on save', () async {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase(
        id: 'purchase-001',
      );

      await repository.save(purchase);

      expect(
        () async => repository.save(purchase),
        throwsStateError,
      );
    });

    test('updates an existing purchase', () async {
      final repository = InMemoryPurchaseRepository();
      final original = createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-001',
      );

      await repository.save(original);

      final updated = createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-002',
      );

      await repository.update(updated);

      expect(await repository.getById('purchase-001'), updated);
      expect(
        await repository.getByReferenceNumber('INV-002'),
        updated,
      );
      expect(
        await repository.getByReferenceNumber('INV-001'),
        isNull,
      );
    });

    test('rejects updating a missing purchase', () async {
      final repository = InMemoryPurchaseRepository();

      expect(
        () async => repository.update(
          createPurchase(id: 'missing'),
        ),
        throwsStateError,
      );
    });

    test('deletes an existing purchase', () async {
      final repository = InMemoryPurchaseRepository();
      final purchase = createPurchase(
        id: 'purchase-001',
      );

      await repository.save(purchase);
      await repository.deleteById(purchase.id);

      expect(await repository.getById(purchase.id), isNull);
      expect(await repository.getAll(), isEmpty);
    });

    test('rejects deleting a missing purchase', () async {
      final repository = InMemoryPurchaseRepository();

      expect(
        () async => repository.deleteById('missing'),
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
