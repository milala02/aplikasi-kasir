import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/drift_cost_layer_repository.dart';

void main() {
  group('DriftCostLayerRepository', () {
    test('persists a cost layer (including purchaseId) across reads', () async {
      final dir = await Directory.systemTemp.createTemp('drift_cost_layer');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftCostLayerRepository(db);
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final layer = CostLayer(
        id: 'layer-001',
        productId: 'pepper',
        originalQuantity: Quantity(value: 10),
        remainingQuantity: Quantity(value: 10),
        unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
        acquiredAt: DateTime(2026, 8, 18),
        purchaseId: 'po_001',
      );

      await repository.save(layer);

      final fetched = await repository.getById('layer-001');
      expect(fetched, isNotNull);
      expect(fetched!.id, 'layer-001');
      expect(fetched.productId, 'pepper');
      expect(fetched.originalQuantity, Quantity(value: 10));
      expect(fetched.remainingQuantity, Quantity(value: 10));
      expect(
          fetched.unitCost, const Money(minorUnits: 160000, currency: 'IDR'));
      expect(fetched.acquiredAt, DateTime(2026, 8, 18));
      expect(fetched.purchaseId, 'po_001');

      expect(await repository.getByProductId('pepper'), hasLength(1));
      expect(await repository.getAvailableByProductId('pepper'), hasLength(1));

      // Update: consume sebagian dan pastikan purchaseId ikut tersimpan.
      final updated = fetched.consume(Quantity(value: 4));
      await repository.update(updated);

      final afterUpdate = await repository.getById('layer-001');
      expect(afterUpdate!.remainingQuantity, Quantity(value: 6));
      expect(afterUpdate.purchaseId, 'po_001');
      expect(afterUpdate.originalQuantity, Quantity(value: 10));
    });

    test('keeps FIFO consumption results after app restart', () async {
      final dir = await Directory.systemTemp.createTemp('drift_cost_layer');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Sesi pertama: simpan dua layer lalu konsumsi via CostLayerService.
      final firstDb = AppDatabase(NativeDatabase(file));
      final firstRepository = DriftCostLayerRepository(firstDb);

      await firstRepository.save(
        CostLayer(
          id: 'layer-001',
          productId: 'pepper',
          originalQuantity: Quantity(value: 10),
          remainingQuantity: Quantity(value: 10),
          unitCost: const Money(minorUnits: 10000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 1),
        ),
      );
      await firstRepository.save(
        CostLayer(
          id: 'layer-002',
          productId: 'pepper',
          originalQuantity: Quantity(value: 5),
          remainingQuantity: Quantity(value: 5),
          unitCost: const Money(minorUnits: 12000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 2),
        ),
      );

      final consumption = await CostLayerService(repository: firstRepository)
          .consume(productId: 'pepper', quantity: Quantity(value: 12));
      expect(consumption.totalCost,
          const Money(minorUnits: 124000, currency: 'IDR'));

      // Simulasi restart: tutup database lalu buka ulang file yang sama.
      await firstDb.close();

      final secondDb = AppDatabase(NativeDatabase(file));
      final secondRepository = DriftCostLayerRepository(secondDb);
      addTearDown(() async {
        await secondDb.close();
      });

      final firstAfterRestart = await secondRepository.getById('layer-001');
      final secondAfterRestart = await secondRepository.getById('layer-002');

      expect(firstAfterRestart!.remainingQuantity, Quantity.zero());
      expect(secondAfterRestart!.remainingQuantity, Quantity(value: 3));
      expect(
        await secondRepository.getAvailableByProductId('pepper'),
        hasLength(1),
      );

      // FIFO tetap berfungsi setelah restart: habiskan sisa 3 kg.
      final afterRestart = await CostLayerService(repository: secondRepository)
          .consume(productId: 'pepper', quantity: Quantity(value: 3));

      expect(afterRestart.totalCost,
          const Money(minorUnits: 36000, currency: 'IDR'));
      expect(afterRestart.consumptions.single.layerId, 'layer-002');
      expect(
        await secondRepository.getAvailableByProductId('pepper'),
        isEmpty,
      );
    });

    test('migrates an existing v2 database by adding purchase_id column',
        () async {
      final dir = await Directory.systemTemp.createTemp('drift_cost_layer');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Buat database versi 2 (schema lama tanpa purchase_id) secara manual.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE cost_layers_table');
      await initialDb.customStatement('''
        CREATE TABLE cost_layers_table (
          id TEXT NOT NULL PRIMARY KEY,
          product_id TEXT NOT NULL,
          original_quantity_value INTEGER NOT NULL,
          original_quantity_scale INTEGER NOT NULL,
          remaining_quantity_value INTEGER NOT NULL,
          remaining_quantity_scale INTEGER NOT NULL,
          unit_cost_minor_units INTEGER NOT NULL,
          unit_cost_currency TEXT NOT NULL,
          acquired_at INTEGER NOT NULL
        )
      ''');
      await initialDb.customStatement('PRAGMA user_version = 2');
      final oldAcquiredAtSeconds =
          DateTime(2026, 8, 1).millisecondsSinceEpoch ~/ 1000;
      await initialDb.customStatement(
        'INSERT INTO cost_layers_table (id, product_id, '
        'original_quantity_value, '
        'original_quantity_scale, remaining_quantity_value, '
        'remaining_quantity_scale, unit_cost_minor_units, unit_cost_currency, '
        'acquired_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          'old_layer',
          'pepper',
          5,
          0,
          5,
          0,
          10000,
          'IDR',
          oldAcquiredAtSeconds,
        ],
      );
      await initialDb.close();

      // Buka dengan AppDatabase versi 3: migrasi harus menambah purchase_id.
      final db = AppDatabase(NativeDatabase(file));
      final repository = DriftCostLayerRepository(db);
      addTearDown(() async {
        await db.close();
      });

      // Data lama tetap terbaca, purchaseId bernilai null.
      final oldLayer = await repository.getById('old_layer');
      expect(oldLayer, isNotNull);
      expect(oldLayer!.purchaseId, isNull);
      expect(oldLayer.remainingQuantity, Quantity(value: 5));

      // Simpan layer baru dengan purchaseId di skema hasil migrasi.
      await repository.save(
        CostLayer(
          id: 'new_layer',
          productId: 'pepper',
          originalQuantity: Quantity(value: 2),
          remainingQuantity: Quantity(value: 2),
          unitCost: const Money(minorUnits: 12000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 2),
          purchaseId: 'po_002',
        ),
      );

      final newLayer = await repository.getById('new_layer');
      expect(newLayer!.purchaseId, 'po_002');
    });
  });
}
