import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_item.dart';
import 'package:aplikasi_kasir/features/purchasing/infrastructure/drift_purchase_repository.dart';

void main() {
  group('DriftPurchaseRepository', () {
    test('save + getById roundtrip menjaga item purchase tetap utuh', () async {
      final dir = await Directory.systemTemp.createTemp('drift_purchase');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftPurchaseRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final purchase = Purchase(
        id: 'purchase-001',
        purchasedAt: DateTime(2026, 8, 18, 10, 30),
        supplierId: 'supplier-001',
        referenceNumber: 'INV-001',
        items: [
          PurchaseItem(
            id: 'item-001',
            productId: 'pepper',
            quantity: Quantity(value: 1),
            unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
          ),
          PurchaseItem(
            id: 'item-002',
            productId: 'garlic',
            quantity: Quantity(value: 500, scale: 3),
            unitCost: const Money(minorUnits: 40000, currency: 'IDR'),
          ),
        ],
      );

      await repository.save(purchase);

      final fetched = await repository.getById('purchase-001');
      expect(fetched, isNotNull);
      expect(fetched!.id, 'purchase-001');
      expect(fetched.purchasedAt, DateTime(2026, 8, 18, 10, 30));
      expect(fetched.supplierId, 'supplier-001');
      expect(fetched.referenceNumber, 'INV-001');
      expect(fetched.items, hasLength(2));

      final firstItem = fetched.items.firstWhere((i) => i.id == 'item-001');
      expect(firstItem.productId, 'pepper');
      expect(firstItem.quantity, Quantity(value: 1));
      expect(
          firstItem.unitCost, const Money(minorUnits: 160000, currency: 'IDR'));

      final secondItem = fetched.items.firstWhere((i) => i.id == 'item-002');
      expect(secondItem.quantity, Quantity(value: 500, scale: 3));
      expect(
          secondItem.unitCost, const Money(minorUnits: 40000, currency: 'IDR'));
    });

    test('getByReferenceNumber menemukan purchase berdasarkan referensi',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_purchase');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftPurchaseRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      await repository
          .save(createPurchase(id: 'purchase-001', referenceNumber: 'INV-001'));
      await repository
          .save(createPurchase(id: 'purchase-002', referenceNumber: null));

      final found = await repository.getByReferenceNumber('INV-001');
      expect(found, isNotNull);
      expect(found!.id, 'purchase-001');

      expect(await repository.getByReferenceNumber('INV-999'), isNull);
    });

    test('getAll mengembalikan semua purchase beserta item-nya', () async {
      final dir = await Directory.systemTemp.createTemp('drift_purchase');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftPurchaseRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      await repository.save(createPurchase(id: 'purchase-001'));
      await repository.save(createPurchase(id: 'purchase-002'));

      final all = await repository.getAll();
      expect(all, hasLength(2));
      expect(all.first.items, hasLength(1));
      expect(all.first.items.single.quantity, Quantity(value: 1));
    });

    test('update mengganti data purchase beserta item-nya', () async {
      final dir = await Directory.systemTemp.createTemp('drift_purchase');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftPurchaseRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      await repository.save(createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-001',
      ));

      await repository.update(Purchase(
        id: 'purchase-001',
        purchasedAt: DateTime(2026, 8, 19),
        supplierId: 'supplier-002',
        referenceNumber: 'INV-002',
        items: [
          PurchaseItem(
            id: 'item-new',
            productId: 'onion',
            quantity: Quantity(value: 2),
            unitCost: const Money(minorUnits: 30000, currency: 'IDR'),
          ),
        ],
      ));

      final updated = await repository.getById('purchase-001');
      expect(updated!.referenceNumber, 'INV-002');
      expect(updated.supplierId, 'supplier-002');
      expect(updated.items, hasLength(1));
      expect(updated.items.single.id, 'item-new');
      expect(await repository.getByReferenceNumber('INV-001'), isNull);
    });

    test('deleteById menghapus purchase beserta item-nya', () async {
      final dir = await Directory.systemTemp.createTemp('drift_purchase');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftPurchaseRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      await repository.save(createPurchase(id: 'purchase-001'));

      await repository.deleteById('purchase-001');

      expect(await repository.getById('purchase-001'), isNull);
      expect(await repository.getAll(), isEmpty);
      expect(
        () async => repository.deleteById('purchase-001'),
        throwsStateError,
      );
    });

    test('data purchase tetap ada setelah restart (reopen database)', () async {
      final dir = await Directory.systemTemp.createTemp('drift_purchase');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      final firstDb = AppDatabase(NativeDatabase(file));
      final firstRepository = DriftPurchaseRepository(firstDb);
      await firstRepository.save(createPurchase(
        id: 'purchase-001',
        referenceNumber: 'INV-001',
      ));
      await firstDb.close();

      // Simulasi restart: buka ulang file database yang sama.
      final secondDb = AppDatabase(NativeDatabase(file));
      final secondRepository = DriftPurchaseRepository(secondDb);
      addTearDown(() async {
        await secondDb.close();
      });

      final fetched = await secondRepository.getById('purchase-001');
      expect(fetched, isNotNull);
      expect(fetched!.referenceNumber, 'INV-001');
      expect(fetched.items.single.productId, 'pepper');

      expect(await secondRepository.getAll(), hasLength(1));
      final byReference = await secondRepository.getByReferenceNumber('INV-001');
      expect(byReference, isNotNull);
      expect(byReference!.id, 'purchase-001');
    });
  });
}

Purchase createPurchase({
  required String id,
  String? referenceNumber = 'INV-001',
}) {
  return Purchase(
    id: id,
    purchasedAt: DateTime(2026, 8, 18, 10, 30),
    supplierId: 'supplier-001',
    referenceNumber: referenceNumber,
    items: [
      PurchaseItem(
        id: 'item-$id',
        productId: 'pepper',
        quantity: Quantity(value: 1),
        unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
      ),
    ],
  );
}
