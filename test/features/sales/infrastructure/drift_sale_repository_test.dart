import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/drift_sale_repository.dart';

void main() {
  group('DriftSaleRepository', () {
    test('round-trip sale item lengkap (nama, unit, skala, HPP) tersimpan',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_sale');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftSaleRepository(db);
      await repository.init();

      final sale = Sale(
        id: 'sale_001',
        invoiceNumber: 'INV-001',
        items: [
          SaleItem(
            productId: 'pepper',
            productName: 'Lada Hitam',
            unit: Unit.kilogram,
            quantity: Quantity(value: 2, scale: 1),
            unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
            unitCost: const Money(minorUnits: 1600000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime(2026, 8, 18),
      );

      await repository.save(sale);

      // Baca ulang dari instance repository baru (fresh cache).
      final reloaded = DriftSaleRepository(db);
      await reloaded.init();

      final fetched = reloaded.getById('sale_001');
      expect(fetched, isNotNull);
      expect(fetched!.items, hasLength(1));

      final item = fetched.items.single;
      expect(item.productName, 'Lada Hitam');
      expect(item.unit, Unit.kilogram);
      expect(item.quantity, Quantity(value: 2, scale: 1));
      expect(
        item.unitCost,
        const Money(minorUnits: 1600000, currency: 'IDR'),
      );
    });

    test('update menulis ulang ke SQLite (bukan hanya cache)', () async {
      final dir = await Directory.systemTemp.createTemp('drift_sale_upd');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftSaleRepository(db);
      await repository.init();

      await repository.save(
        Sale(
          id: 'sale_001',
          invoiceNumber: 'INV-001',
          items: [
            SaleItem(
              productId: 'pepper',
              productName: 'Lada Hitam',
              unit: Unit.kilogram,
              quantity: Quantity(value: 2, scale: 0),
              unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
            ),
          ],
          createdAt: DateTime(2026, 8, 18),
        ),
      );

      await repository.update(
        Sale(
          id: 'sale_001',
          invoiceNumber: 'INV-001',
          items: [
            SaleItem(
              productId: 'pepper',
              productName: 'Lada Hitam',
              unit: Unit.kilogram,
              quantity: Quantity(value: 5, scale: 0),
              unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
              unitCost: const Money(minorUnits: 1500000, currency: 'IDR'),
            ),
          ],
          discount: const Money(minorUnits: 500, currency: 'IDR'),
          tax: const Money(minorUnits: 0, currency: 'IDR'),
          createdAt: DateTime(2026, 8, 18),
        ),
      );

      final reloaded = DriftSaleRepository(db);
      await reloaded.init();

      final fetched = reloaded.getById('sale_001');
      expect(fetched, isNotNull);
      expect(fetched!.discount.minorUnits, 500);
      expect(fetched.items.single.quantity.value, 5);
      expect(
        fetched.items.single.unitCost,
        const Money(minorUnits: 1500000, currency: 'IDR'),
      );
    });

    test('data lama tanpa kolom baru tetap terbaca dengan fallback aman',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_sale_legacy');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      // Simulasi baris legacy: insert langsung tanpa kolom nama/unit/skala/HPP.
      await db.into(db.salesTable).insert(
            SalesTableCompanion.insert(
              id: 'sale_legacy',
              invoiceNumber: 'INV-LEGACY',
              discountMinorUnits: 0,
              taxMinorUnits: 0,
              createdAt: DateTime(2026, 8, 1),
              soldAt: DateTime(2026, 8, 1),
            ),
          );
      await db.into(db.saleItemsTable).insert(
            SaleItemsTableCompanion.insert(
              id: 'sale_legacy_pepper',
              saleId: 'sale_legacy',
              productId: 'pepper',
              quantityValue: 2,
              unitPriceMinorUnits: 3000000,
            ),
          );

      final repository = DriftSaleRepository(db);
      await repository.init();

      final fetched = repository.getById('sale_legacy');
      expect(fetched, isNotNull);

      final item = fetched!.items.single;
      expect(item.unitCost, isNull);
      expect(item.productName, 'pepper'); // Fallback ke productId.
      expect(item.unit, Unit.pcs); // Fallback unit.
      expect(item.quantity, Quantity(value: 2, scale: 0)); // Skala default 0.
    });
  });
}
