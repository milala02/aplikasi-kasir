import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/drift_sync_queue_repository.dart';

void main() {
  group('DriftSyncQueueRepository', () {
    SyncQueueEntry buildEntry({
      String id = 'sq_001',
      SyncQueueStatus status = SyncQueueStatus.pending,
      int retryCount = 0,
      String sourceTable = 'orders',
    }) {
      final now = DateTime(2026, 8, 20, 10, 0);
      return SyncQueueEntry(
        id: id,
        endpoint: 'orders/push',
        sourceTable: sourceTable,
        payloadJson: '{"id":"sale_1"}',
        status: status,
        retryCount: retryCount,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('round-trip: enqueue -> getPending -> mark synced/failed',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_syncq');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftSyncQueueRepository(db);

      await repository.save(buildEntry());
      await repository.save(buildEntry(id: 'sq_002'));
      await repository.save(
        buildEntry(id: 'sq_003', status: SyncQueueStatus.synced),
      );

      expect(await repository.getAll(), hasLength(3));

      final pending = await repository.getPending();
      expect(pending.map((e) => e.id), ['sq_001', 'sq_002']);

      // Mark synced: keluar dari antrian pending.
      final synced =
          pending.first.copyWith(status: SyncQueueStatus.synced);
      await repository.update(synced);
      expect((await repository.getPending()).map((e) => e.id), ['sq_002']);

      // Mark failed dengan retryCount bertambah: tetap bukan pending
      // sampai di-enqueue ulang.
      final failed = buildEntry(
        id: 'sq_002',
        status: SyncQueueStatus.failed,
        retryCount: 1,
      );
      await repository.update(failed);
      expect(await repository.getPending(), isEmpty);

      final all = await repository.getAll();
      final failedEntry =
          all.where((e) => e.id == 'sq_002').single;
      expect(failedEntry.status, SyncQueueStatus.failed);
      expect(failedEntry.retryCount, 1);
    });

    test('migration v11 -> v12: kolom CDC + tabel sync queue; baris legacy '
        'fallback isSynced=false', () async {
      final dir = await Directory.systemTemp.createTemp('drift_v12_mig');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Simulasi DB v11: header tabel tanpa kolom sync, tanpa sync_queue.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE IF EXISTS sync_queue_table');
      await initialDb.customStatement('DROP TABLE IF EXISTS sales_table');
      await initialDb.customStatement('''
        CREATE TABLE sales_table (
          id TEXT NOT NULL PRIMARY KEY,
          invoice_number TEXT NOT NULL UNIQUE,
          discount_minor_units INTEGER NOT NULL,
          tax_minor_units INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          sold_at INTEGER NOT NULL
        )
      ''');
      await initialDb.customStatement('DROP TABLE IF EXISTS products_table');
      await initialDb.customStatement('''
        CREATE TABLE products_table (
          id TEXT NOT NULL PRIMARY KEY,
          sku TEXT NOT NULL,
          name TEXT NOT NULL,
          base_unit TEXT NOT NULL,
          purchase_price_minor_units INTEGER NOT NULL,
          purchase_price_currency TEXT NOT NULL,
          selling_price_minor_units INTEGER NOT NULL,
          selling_price_currency TEXT NOT NULL,
          active INTEGER NOT NULL
        )
      ''');
      await initialDb.customStatement('DROP TABLE IF EXISTS customers_table');
      await initialDb.customStatement('''
        CREATE TABLE customers_table (
          id TEXT NOT NULL PRIMARY KEY,
          name TEXT NOT NULL,
          phone_number TEXT NOT NULL,
          address TEXT,
          notes TEXT,
          created_at INTEGER NOT NULL
        )
      ''');
      await initialDb.customStatement('DROP TABLE IF EXISTS receivings_table');
      await initialDb.customStatement('''
        CREATE TABLE receivings_table (
          id TEXT NOT NULL PRIMARY KEY,
          purchase_id TEXT NOT NULL,
          received_at INTEGER NOT NULL
        )
      ''');
      await initialDb.customStatement('DROP TABLE IF EXISTS purchases_table');
      await initialDb.customStatement('''
        CREATE TABLE purchases_table (
          id TEXT NOT NULL PRIMARY KEY,
          purchased_at INTEGER NOT NULL,
          supplier_id TEXT,
          reference_number TEXT
        )
      ''');
      await initialDb.customStatement('DROP TABLE IF EXISTS orders_table');
      await initialDb.customStatement('''
        CREATE TABLE orders_table (
          id TEXT NOT NULL PRIMARY KEY,
          sale_id TEXT NOT NULL,
          source TEXT NOT NULL,
          status TEXT NOT NULL,
          payment_method TEXT NOT NULL,
          created_at INTEGER NOT NULL
        )
      ''');

      final t = DateTime(2026, 8, 1).millisecondsSinceEpoch ~/ 1000;
      await initialDb.customStatement(
        'INSERT INTO sales_table '
        "(id, invoice_number, discount_minor_units, tax_minor_units, "
        "created_at, sold_at) VALUES ('sale_old', 'INV-OLD', 0, 0, $t, $t)",
      );
      await initialDb.customStatement(
        'INSERT INTO products_table '
        "(id, sku, name, base_unit, purchase_price_minor_units, "
        "purchase_price_currency, selling_price_minor_units, "
        "selling_price_currency, active) "
        "VALUES ('prod_old', 'SKU-OLD', 'Produk Lama', 'pcs', 0, 'IDR', "
        "0, 'IDR', 1)",
      );

      await initialDb.customStatement('PRAGMA user_version = 11');
      await initialDb.close();

      // Buka ulang: migrasi v11 -> v12.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
      });

      // Baris legacy: isSynced=false, syncedAt null.
      final saleRow = await (db.select(db.salesTable)
            ..where((t) => t.id.equals('sale_old')))
          .getSingle();
      expect(saleRow.isSynced, isFalse);
      expect(saleRow.syncedAt, isNull);

      final productRow = await (db.select(db.productsTable)
            ..where((t) => t.id.equals('prod_old')))
          .getSingle();
      expect(productRow.isSynced, isFalse);
      expect(productRow.syncedAt, isNull);

      // Tabel sync queue tersedia dan berfungsi.
      final repository = DriftSyncQueueRepository(db);
      final now = DateTime(2026, 8, 20);
      await repository.save(
        SyncQueueEntry(
          id: 'sq_001',
          endpoint: 'orders/push',
          sourceTable: 'orders',
          payloadJson: '{"id":"sale_old"}',
          status: SyncQueueStatus.pending,
          retryCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      expect((await repository.getPending()).map((e) => e.id), ['sq_001']);
    });

    test('migration v12 -> v13: sync queue + sourceTable, baris legacy '
        'terbaca dengan default kosong', () async {
      final dir = await Directory.systemTemp.createTemp('drift_v13_mig');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Simulasi DB v12: sync_queue_table tanpa kolom source_table.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE IF EXISTS sync_queue_table');
      await initialDb.customStatement('''
        CREATE TABLE sync_queue_table (
          id TEXT NOT NULL PRIMARY KEY,
          endpoint TEXT NOT NULL,
          payload_json TEXT NOT NULL,
          status TEXT NOT NULL,
          retry_count INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');
      final t = DateTime(2026, 8, 1).millisecondsSinceEpoch ~/ 1000;
      await initialDb.customStatement(
        'INSERT INTO sync_queue_table '
        "(id, endpoint, payload_json, status, retry_count, created_at, "
        "updated_at) "
        "VALUES ('sq_old', 'orders/push', '{\"id\":\"sale_old\"}', "
        "'pending', 0, $t, $t)",
      );
      await initialDb.customStatement('PRAGMA user_version = 12');
      await initialDb.close();

      // Buka ulang: migrasi v12 -> v13.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
      });

      final repository = DriftSyncQueueRepository(db);
      final legacy = (await repository.getAll()).single;
      expect(legacy.id, 'sq_old');
      expect(legacy.sourceTable, ''); // Default migrasi untuk baris lama.

      // Penulisan baru dengan sourceTable berfungsi.
      await repository.save(buildEntry());
      expect(
        (await repository.getAll()).firstWhere((e) => e.id == 'sq_001').sourceTable,
        'orders',
      );
    });

    test('migration v13 -> v14: sync queue + referenceId, baris legacy '
        'terbaca dengan referenceId kosong', () async {
      final dir = await Directory.systemTemp.createTemp('drift_v14_mig');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Simulasi DB v13: sync_queue_table tanpa kolom reference_id.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE IF EXISTS sync_queue_table');
      await initialDb.customStatement('''
        CREATE TABLE sync_queue_table (
          id TEXT NOT NULL PRIMARY KEY,
          endpoint TEXT NOT NULL,
          source_table TEXT NOT NULL,
          payload_json TEXT NOT NULL,
          status TEXT NOT NULL,
          retry_count INTEGER NOT NULL,
          created_at INTEGER NOT NULL,
          updated_at INTEGER NOT NULL
        )
      ''');
      final t = DateTime(2026, 8, 1).millisecondsSinceEpoch ~/ 1000;
      await initialDb.customStatement(
        'INSERT INTO sync_queue_table '
        '(id, endpoint, source_table, payload_json, status, retry_count, '
        'created_at, updated_at) '
        "VALUES ('sq_old', 'orders/push', 'order', '{\"id\":\"sale_old\"}', "
        "'pending', 0, $t, $t)",
      );
      await initialDb.customStatement('PRAGMA user_version = 13');
      await initialDb.close();

      // Buka ulang: migrasi v13 -> v14.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
      });

      final repository = DriftSyncQueueRepository(db);
      final legacy = (await repository.getAll()).single;
      expect(legacy.id, 'sq_old');
      expect(legacy.referenceId, ''); // Default migrasi untuk baris lama.

      // Penulisan baru dengan referenceId round-trip.
      final now = DateTime(2026, 8, 20);
      await repository.save(
        SyncQueueEntry(
          id: 'sq_002',
          endpoint: 'orders/push',
          sourceTable: 'order',
          referenceId: 'ord_1',
          payloadJson: '{"orders":[]}',
          status: SyncQueueStatus.pending,
          retryCount: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
      final saved = (await repository.getAll())
          .firstWhere((e) => e.id == 'sq_002');
      expect(saved.referenceId, 'ord_1');
    });
  });
}
