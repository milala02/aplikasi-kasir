import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/orders/domain/order.dart';
import 'package:aplikasi_kasir/features/orders/infrastructure/drift_order_repository.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('DriftOrderRepository', () {
    SaleItem item({String productId = 'prod_100', int quantity = 2}) {
      return SaleItem(
        productId: productId,
        productName: 'Lada Hitam',
        unit: Unit.kilogram,
        quantity: Quantity(value: quantity, scale: 1),
        unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
      );
    }

    Order buildOrder({
      String id = 'ord_1',
      OrderStatus status = OrderStatus.pendingPayment,
    }) {
      return Order(
        id: id,
        saleId: 'sale_1',
        source: OrderSource.online,
        status: status,
        paymentMethod: OrderPaymentMethod.qris,
        items: [item()],
        createdAt: DateTime(2026, 8, 20, 10, 30),
      );
    }

    test('save -> getById round-trip lengkap tanpa degradasi', () async {
      final dir = await Directory.systemTemp.createTemp('drift_order');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftOrderRepository(db);
      await repository.init();

      await repository.save(buildOrder());

      final fetched = repository.getById('ord_1');
      expect(fetched, isNotNull);
      expect(fetched!.saleId, 'sale_1');
      expect(fetched.source, OrderSource.online);
      expect(fetched.status, OrderStatus.pendingPayment);
      expect(fetched.paymentMethod, OrderPaymentMethod.qris);
      expect(fetched.createdAt, DateTime(2026, 8, 20, 10, 30));

      final loadedItem = fetched.items.single;
      expect(loadedItem.productId, 'prod_100');
      expect(loadedItem.productName, 'Lada Hitam');
      expect(loadedItem.unit, Unit.kilogram);
      expect(loadedItem.quantity, Quantity(value: 2, scale: 1));
      expect(loadedItem.unitPrice,
          const Money(minorUnits: 3000000, currency: 'IDR'));
      expect(loadedItem.unitCost, isNull); // Order tidak membawa HPP.
    });

    test('getAll mengembalikan semua order', () async {
      final dir = await Directory.systemTemp.createTemp('drift_order_all');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftOrderRepository(db);
      await repository.init();

      await repository.save(buildOrder(id: 'ord_1'));
      await repository.save(buildOrder(id: 'ord_2'));

      expect(repository.getAll(), hasLength(2));
    });

    test('update status persist ke SQLite dan cache', () async {
      final dir = await Directory.systemTemp.createTemp('drift_order_upd');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftOrderRepository(db);
      await repository.init();
      await repository.save(buildOrder());

      final paid = buildOrder(status: OrderStatus.paid);
      await repository.update(paid);

      expect(repository.getById('ord_1')!.status, OrderStatus.paid);
    });

    test('restart DB -> order tetap tersedia dengan status lifecycle',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_order_restart');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftOrderRepository(db);
      await repository.init();
      await repository.save(buildOrder());

      // Lanjutkan lifecycle ke READY_FOR_PICKUP (persist tiap transisi).
      final paid =
          buildOrder(status: OrderStatus.paid);
      await repository.update(paid);
      final preparing =
          buildOrder(status: OrderStatus.preparing);
      await repository.update(preparing);
      final ready =
          buildOrder(status: OrderStatus.readyForPickup);
      await repository.update(ready);

      // Simulasi restart: instance repository baru pada db yang sama.
      final reloaded = DriftOrderRepository(db);
      await reloaded.init();

      final fetched = reloaded.getById('ord_1');
      expect(fetched, isNotNull);
      expect(fetched!.status, OrderStatus.readyForPickup);
      expect(fetched.items.single.productName, 'Lada Hitam');
    });

    test('semua status penting dapat dimuat kembali', () async {
      final dir = await Directory.systemTemp.createTemp('drift_order_status');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftOrderRepository(db);
      await repository.init();

      var i = 0;
      for (final status in OrderStatus.values) {
        i++;
        final order = Order(
          id: 'ord_$i',
          saleId: 'sale_$i',
          source: status == OrderStatus.readyForPickup ||
                  status == OrderStatus.pickedUp
              ? OrderSource.online
              : OrderSource.onsite,
          status: status,
          paymentMethod: OrderPaymentMethod.qris,
          items: [item()],
          createdAt: DateTime(2026, 8, 20),
        );
        await repository.save(order);
      }

      final reloaded = DriftOrderRepository(db);
      await reloaded.init();

      for (final status in OrderStatus.values) {
        final order = reloaded
            .getAll()
            .where((o) => o.status == status)
            .toList();
        expect(order, hasLength(1), reason: 'Status $status harus termuat');
      }
    });

    test('migration v7 -> v8 membuat tabel order', () async {
      final dir = await Directory.systemTemp.createTemp('drift_order_mig');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Simulasi DB v7: tanpa tabel order.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE IF EXISTS order_items_table');
      await initialDb.customStatement('DROP TABLE IF EXISTS orders_table');
      await initialDb.customStatement('PRAGMA user_version = 7');
      await initialDb.close();

      // Buka ulang: migrasi v7 -> v8 membuat tabel order.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
      });

      final repository = DriftOrderRepository(db);
      await repository.init();

      await repository.save(buildOrder());
      expect(repository.getById('ord_1'), isNotNull);
      expect(repository.getById('ord_1')!.status,
          OrderStatus.pendingPayment);
    });
  });
}
