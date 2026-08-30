import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product_packaging.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/drift_product_packaging_repository.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_item.dart';
import 'package:aplikasi_kasir/features/purchasing/infrastructure/drift_purchase_repository.dart';
import 'package:aplikasi_kasir/features/receiving/infrastructure/drift_receiving_repository.dart';

void main() {
  group('DriftProductPackagingRepository', () {
    test('save -> getByProductId round-trip lengkap', () async {
      final dir = await Directory.systemTemp.createTemp('drift_packaging');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftProductPackagingRepository(db);
      await repository.init();

      final packaging = ProductPackaging(
        id: 'pack_001',
        productId: 'prod_100',
        fromUnit: Unit.box,
        toUnit: Unit.pcs,
        multiplierValue: 24,
        divisorValue: 1,
      );
      await repository.save(packaging);

      final fetched = repository.getByProductId('prod_100');
      expect(fetched, hasLength(1));
      expect(fetched.single.fromUnit, Unit.box);
      expect(fetched.single.toUnit, Unit.pcs);
      expect(fetched.single.multiplierValue, 24);
      expect(fetched.single.divisorValue, 1);
      expect(fetched.single.conversion.convert(Quantity(value: 2)),
          Quantity(value: 48));
    });

    test(
        'migration v10 -> v11: kolom unit PO/receiving + tabel packaging; '
        'baris legacy terbaca dengan fallback pcs', () async {
      final dir = await Directory.systemTemp.createTemp('drift_v11_mig');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Simulasi DB v10: purchase_items & receiving_items tanpa kolom unit.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE IF EXISTS product_packagings_table');
      await initialDb.customStatement('DROP TABLE IF EXISTS purchase_items_table');
      await initialDb.customStatement('''
        CREATE TABLE purchase_items_table (
          id TEXT NOT NULL PRIMARY KEY,
          purchase_id TEXT NOT NULL,
          product_id TEXT NOT NULL,
          quantity_value INTEGER NOT NULL,
          quantity_scale INTEGER NOT NULL,
          unit_cost_minor_units INTEGER NOT NULL,
          unit_cost_currency TEXT NOT NULL
        )
      ''');
      await initialDb.customStatement('DROP TABLE IF EXISTS receiving_items_table');
      await initialDb.customStatement('''
        CREATE TABLE receiving_items_table (
          id TEXT NOT NULL PRIMARY KEY,
          receiving_id TEXT NOT NULL,
          product_id TEXT NOT NULL,
          quantity_value INTEGER NOT NULL,
          quantity_scale INTEGER NOT NULL,
          unit_cost_minor_units INTEGER NOT NULL,
          unit_cost_currency TEXT NOT NULL
        )
      ''');
      final t = DateTime(2026, 8, 1).millisecondsSinceEpoch ~/ 1000;
      await initialDb.customStatement(
        'INSERT INTO purchases_table '
        '(id, purchased_at, supplier_id, reference_number) '
        "VALUES ('po_old', $t, NULL, NULL)",
      );
      await initialDb.customStatement(
        'INSERT INTO purchase_items_table '
        "(id, purchase_id, product_id, quantity_value, quantity_scale, "
        "unit_cost_minor_units, unit_cost_currency) "
        "VALUES ('pi_old', 'po_old', 'prod_100', 5, 0, 1000000, 'IDR')",
      );
      await initialDb.customStatement(
        'INSERT INTO receivings_table '
        '(id, purchase_id, received_at) '
        "VALUES ('recv_old', 'po_old', $t)",
      );
      await initialDb.customStatement(
        'INSERT INTO receiving_items_table '
        "(id, receiving_id, product_id, quantity_value, quantity_scale, "
        "unit_cost_minor_units, unit_cost_currency) "
        "VALUES ('ri_old', 'recv_old', 'prod_100', 5, 0, 1000000, 'IDR')",
      );
      await initialDb.customStatement('PRAGMA user_version = 10');
      await initialDb.close();

      // Buka ulang: migrasi v10 -> v11.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
      });

      // Baris legacy terbaca dengan fallback unit pcs (tanpa crash).
      final purchaseRepo = DriftPurchaseRepository(db);
      final legacyPurchase = await purchaseRepo.getById('po_old');
      expect(legacyPurchase, isNotNull);
      expect(legacyPurchase!.items.single.unit, Unit.pcs);

      final receivingRepo = DriftReceivingRepository(db);
      final legacyReceiving = await receivingRepo.getById('recv_old');
      expect(legacyReceiving, isNotNull);
      expect(legacyReceiving!.items.single.unit, Unit.pcs);

      // Penulisan baru dengan unit dan packaging berfungsi pasca-migrasi.
      final packagingRepo = DriftProductPackagingRepository(db);
      await packagingRepo.init();
      await packagingRepo.save(
        ProductPackaging(
          id: 'pack_001',
          productId: 'prod_100',
          fromUnit: Unit.box,
          toUnit: Unit.pcs,
          multiplierValue: 24,
          divisorValue: 1,
        ),
      );
      expect(packagingRepo.getByProductId('prod_100'), hasLength(1));

      await purchaseRepo.save(
        Purchase(
          id: 'po_new',
          purchasedAt: DateTime(2026, 8, 20),
          items: [
            PurchaseItem(
              id: 'pi_new',
              productId: 'prod_100',
              quantity: Quantity(value: 2, scale: 0),
              unit: Unit.box,
              unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
            ),
          ],
        ),
      );
      final newPurchase = await purchaseRepo.getById('po_new');
      expect(newPurchase!.items.single.unit, Unit.box);
    });
  });
}
