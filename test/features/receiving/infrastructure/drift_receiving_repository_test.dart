import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/receiving/domain/receiving.dart';
import 'package:aplikasi_kasir/features/receiving/infrastructure/drift_receiving_repository.dart';

void main() {
  group('DriftReceivingRepository', () {
    test('save + getById roundtrip menjaga item receiving tetap utuh',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_receiving');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftReceivingRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final receiving = Receiving(
        id: 'rec_001',
        purchaseId: 'po_001',
        receivedAt: DateTime(2026, 8, 20, 10, 30),
        items: [
          ReceivingItem(
            id: 'item_001',
            productId: 'prod_100',
            quantityReceived: Quantity(value: 5, scale: 0),
            unitCost: Money(minorUnits: 1500000, currency: 'IDR'),
          ),
          ReceivingItem(
            id: 'item_002',
            productId: 'prod_200',
            quantityReceived: Quantity(value: 500, scale: 3),
            unitCost: Money(minorUnits: 250000, currency: 'IDR'),
          ),
        ],
      );

      await repository.save(receiving);

      final fetched = await repository.getById('rec_001');
      expect(fetched, isNotNull);
      expect(fetched!.id, 'rec_001');
      expect(fetched.purchaseId, 'po_001');
      expect(fetched.receivedAt, DateTime(2026, 8, 20, 10, 30));
      expect(fetched.items, hasLength(2));

      final firstItem = fetched.items.firstWhere((i) => i.id == 'item_001');
      expect(firstItem.productId, 'prod_100');
      expect(firstItem.quantityReceived, Quantity(value: 5, scale: 0));
      expect(firstItem.unitCost,
          const Money(minorUnits: 1500000, currency: 'IDR'));

      final secondItem = fetched.items.firstWhere((i) => i.id == 'item_002');
      expect(secondItem.quantityReceived, Quantity(value: 500, scale: 3));
      expect(secondItem.unitCost,
          const Money(minorUnits: 250000, currency: 'IDR'));
    });

    test('getByPurchaseId hanya mengembalikan receiving dari PO terkait',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_receiving');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftReceivingRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      await repository.save(createReceiving(
        id: 'rec_001',
        purchaseId: 'po_001',
        productId: 'prod_100',
      ));
      await repository.save(createReceiving(
        id: 'rec_002',
        purchaseId: 'po_001',
        productId: 'prod_200',
      ));
      await repository.save(createReceiving(
        id: 'rec_003',
        purchaseId: 'po_002',
        productId: 'prod_300',
      ));

      final forPo1 = await repository.getByPurchaseId('po_001');
      expect(forPo1.map((r) => r.id), ['rec_001', 'rec_002']);

      final forPo2 = await repository.getByPurchaseId('po_002');
      expect(forPo2.map((r) => r.id), ['rec_003']);
    });

    test('getAll mengembalikan semua receiving beserta item-nya', () async {
      final dir = await Directory.systemTemp.createTemp('drift_receiving');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftReceivingRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      await repository.save(createReceiving(id: 'rec_001'));
      await repository.save(createReceiving(id: 'rec_002'));

      final all = await repository.getAll();
      expect(all, hasLength(2));
      expect(all.first.items, hasLength(1));
      expect(all.first.items.single.quantityReceived, Quantity(value: 5));
    });

    test('data receiving tetap ada setelah restart (reopen database)',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_receiving');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      final firstDb = AppDatabase(NativeDatabase(file));
      final firstRepository = DriftReceivingRepository(firstDb);
      await firstRepository.save(createReceiving(
        id: 'rec_001',
        purchaseId: 'po_001',
        productId: 'prod_100',
      ));
      await firstDb.close();

      // Simulasi restart: buka ulang file database yang sama.
      final secondDb = AppDatabase(NativeDatabase(file));
      final secondRepository = DriftReceivingRepository(secondDb);
      addTearDown(() async {
        await secondDb.close();
      });

      final fetched = await secondRepository.getById('rec_001');
      expect(fetched, isNotNull);
      expect(fetched!.purchaseId, 'po_001');
      expect(fetched.items.single.productId, 'prod_100');

      final all = await secondRepository.getAll();
      expect(all, hasLength(1));
      expect(await secondRepository.getByPurchaseId('po_001'), hasLength(1));
    });
  });
}

Receiving createReceiving({
  required String id,
  String purchaseId = 'po_001',
  String productId = 'prod_100',
}) {
  return Receiving(
    id: id,
    purchaseId: purchaseId,
    receivedAt: DateTime(2026, 8, 20),
    items: [
      ReceivingItem(
        id: 'item_$id',
        productId: productId,
        quantityReceived: Quantity(value: 5, scale: 0),
        unitCost: Money(minorUnits: 1500000, currency: 'IDR'),
      ),
    ],
  );
}
