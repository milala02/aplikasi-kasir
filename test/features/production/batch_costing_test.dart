import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/recipes/domain/recipe.dart';
import 'package:aplikasi_kasir/features/production/application/process_production_batch_use_case.dart';

void main() {
  group('Production Batch FIFO Costing Engine', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late ProcessProductionBatchUseCase useCase;

    setUp(() {
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      useCase = ProcessProductionBatchUseCase(
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
      );
    });

    test('Test 1: Konsumsi dari 1 layer tertua (7 kg dari 10 kg @ 30.000)',
        () async {
      // Layer #001: 10 kg @ 30.000
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'bawang_merah',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 3000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );

      final recipe = Recipe(
        id: 'rec_01',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'bawang_merah',
            quantityRequired: Quantity(value: 7, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 5, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_023',
        batchNumber: 'BATCH-023',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      expect(
          batch.totalMaterialCost.minorUnits, equals(21000000)); // Rp 210.000

      final remaining = await costLayerRepo.getById('layer_001');
      expect(remaining!.remainingQuantity.value, equals(3));
    });

    test(
        'Test 2: Konsumsi lintas 2 layer (12 kg = 10 kg @ 30.000 + 2 kg @ 35.000)',
        () async {
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'bawang_merah',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 3000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_002',
          productId: 'bawang_merah',
          originalQuantity: Quantity(value: 5, scale: 0),
          remainingQuantity: Quantity(value: 5, scale: 0),
          unitCost: const Money(minorUnits: 3500000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );

      final recipe = Recipe(
        id: 'rec_01',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'bawang_merah',
            quantityRequired: Quantity(value: 12, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 10, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_024',
        batchNumber: 'BATCH-024',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      // 10 * 30.000 (300.000) + 2 * 35.000 (70.000) = Rp 370.000
      expect(batch.totalMaterialCost.minorUnits, equals(37000000));

      final remainingLayer2 = await costLayerRepo.getById('layer_002');
      expect(remainingLayer2!.remainingQuantity.value, equals(3));
    });

    test(
        'Test 4: Jika stok tidak mencukupi, produksi HARUS gagal (tanpa stok negatif)',
        () async {
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'jahe',
          originalQuantity: Quantity(value: 2, scale: 0),
          remainingQuantity: Quantity(value: 2, scale: 0),
          unitCost: const Money(minorUnits: 2000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );

      final recipe = Recipe(
        id: 'rec_02',
        name: 'Bumbu Jahe',
        items: [
          RecipeItem(
            productId: 'jahe',
            quantityRequired: Quantity(value: 5, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 2, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_025',
        batchNumber: 'BATCH-025',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Failure>());
      final failure = result as Failure;
      expect(failure.error.toString(), contains('INSUFFICIENT_STOCK'));
    });

    test('Test 6 & 7: Total HPP Batch dan HPP per kg/satuan hasil produksi',
        () async {
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'bawang_putih',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost:
              const Money(minorUnits: 4000000, currency: 'IDR'), // Rp 40.000/kg
          acquiredAt: DateTime.now(),
        ),
      );

      final recipe = Recipe(
        id: 'rec_03',
        name: 'Bumbu Putih',
        items: [
          RecipeItem(
            productId: 'bawang_putih',
            quantityRequired:
                Quantity(value: 10, scale: 0), // Material: Rp 400.000
          ),
        ],
        expectedOutputQuantity: Quantity(value: 10, scale: 0), // Output 10 kg
      );

      final result = await useCase.execute(
        batchId: 'batch_026',
        batchNumber: 'BATCH-026',
        recipe: recipe,
        producedAt: DateTime.now(),
        additionalProductionCost: const Money(
            minorUnits: 10000000,
            currency: 'IDR'), // Biaya Gas/Kemasan: Rp 100.000
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      // Total Batch Cost = Rp 400.000 + Rp 100.000 = Rp 500.000
      expect(batch.totalBatchCost.minorUnits, equals(50000000));
      // HPP per kg = Rp 500.000 / 10 kg = Rp 50.000 / kg
      expect(batch.unitCost.minorUnits, equals(5000000));
    });

    test(
        'Test 8: FIFO deterministik berdasarkan acquiredAt walau layer di-insert tidak urut',
        () async {
      // Insert layer terbaru lebih dulu (bukan urutan FIFO).
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_new',
          productId: 'cabai',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 3500000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_old',
          productId: 'cabai',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 3000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );

      final recipe = Recipe(
        id: 'rec_04',
        name: 'Bumbu Cabai',
        items: [
          RecipeItem(
            productId: 'cabai',
            quantityRequired: Quantity(value: 12, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 8, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_027',
        batchNumber: 'BATCH-027',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      // FIFO: 10 kg @ 30.000 (layer_old) + 2 kg @ 35.000 (layer_new) = Rp 370.000
      expect(batch.totalMaterialCost.minorUnits, equals(37000000));

      final oldLayer = await costLayerRepo.getById('layer_old');
      expect(oldLayer!.remainingQuantity.value, equals(0));

      final newLayer = await costLayerRepo.getById('layer_new');
      expect(newLayer!.remainingQuantity.value, equals(8));
    });

    test('Test 9: Tie-break FIFO berdasarkan id saat acquiredAt sama',
        () async {
      final acquiredAt = DateTime.now();
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_z',
          productId: 'kunyit',
          originalQuantity: Quantity(value: 5, scale: 0),
          remainingQuantity: Quantity(value: 5, scale: 0),
          unitCost: const Money(minorUnits: 3000000, currency: 'IDR'),
          acquiredAt: acquiredAt,
        ),
      );
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_a',
          productId: 'kunyit',
          originalQuantity: Quantity(value: 5, scale: 0),
          remainingQuantity: Quantity(value: 5, scale: 0),
          unitCost: const Money(minorUnits: 2500000, currency: 'IDR'),
          acquiredAt: acquiredAt,
        ),
      );

      final recipe = Recipe(
        id: 'rec_05',
        name: 'Bumbu Kunyit',
        items: [
          RecipeItem(
            productId: 'kunyit',
            quantityRequired: Quantity(value: 5, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 4, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_028',
        batchNumber: 'BATCH-028',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      // acquiredAt sama -> id terkecil ('layer_a') dikonsumsi duluan: 5 @ 25.000
      expect(batch.totalMaterialCost.minorUnits, equals(12500000));

      final layerA = await costLayerRepo.getById('layer_a');
      expect(layerA!.remainingQuantity.value, equals(0));

      final layerZ = await costLayerRepo.getById('layer_z');
      expect(layerZ!.remainingQuantity.value, equals(5));
    });

    test(
        'Test 11: skala campuran - layer lebih halus dari resep tanpa overcount',
        () async {
      // Layer 250 scale 2 = 2,5 kg; resep butuh 2 scale 0 -> cukup (2,5 >= 2).
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_fine',
          productId: 'sereh',
          originalQuantity: Quantity(value: 250, scale: 2),
          remainingQuantity: Quantity(value: 250, scale: 2),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );

      final recipe = Recipe(
        id: 'rec_07',
        name: 'Bumbu Sereh',
        items: [
          RecipeItem(
            productId: 'sereh',
            quantityRequired: Quantity(value: 2, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 1, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_030',
        batchNumber: 'BATCH-030',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());

      // 250 - 200 = 50 pada scale 2 (0,5 kg tersisa).
      final layer = await costLayerRepo.getById('layer_fine');
      expect(layer!.remainingQuantity, Quantity(value: 50, scale: 2));
    });

    test(
        'Test 12: skala campuran - resep butuh 3 kg dari layer 2,5 kg -> '
        'gagal tanpa konsumsi', () async {
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_fine',
          productId: 'sereh',
          originalQuantity: Quantity(value: 250, scale: 2),
          remainingQuantity: Quantity(value: 250, scale: 2),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );

      final recipe = Recipe(
        id: 'rec_08',
        name: 'Bumbu Sereh',
        items: [
          RecipeItem(
            productId: 'sereh',
            quantityRequired: Quantity(value: 3, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 1, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_031',
        batchNumber: 'BATCH-031',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Failure>());
      expect(
          (result as Failure).error.toString(), contains('INSUFFICIENT_STOCK'));

      final layer = await costLayerRepo.getById('layer_fine');
      expect(layer!.remainingQuantity, Quantity(value: 250, scale: 2));
    });

    test('Test 10: Stock movement outbound tercatat di inventory repository',
        () async {
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'bawang_merah',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 3000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );

      final recipe = Recipe(
        id: 'rec_06',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'bawang_merah',
            quantityRequired: Quantity(value: 7, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 5, scale: 0),
      );

      final result = await useCase.execute(
        batchId: 'batch_029',
        batchNumber: 'BATCH-029',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());

      final movements = await inventoryRepo.getMovements('bawang_merah');
      expect(movements, hasLength(1));
      expect(movements.first.id, equals('mov_prod_batch_029_bawang_merah'));
      expect(movements.first.quantity.value, equals(7));
      expect(movements.first.type, equals(StockMovementType.sale));
      expect(movements.first.referenceId, equals('batch_029'));
    });
  });
}
