import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
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

    test('Test 1: Konsumsi dari 1 layer tertua (7 kg dari 10 kg @ 30.000)', () {
      // Layer #001: 10 kg @ 30.000
      costLayerRepo.save(
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

      final result = useCase.execute(
        batchId: 'batch_023',
        batchNumber: 'BATCH-023',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      expect(batch.totalMaterialCost.minorUnits, equals(21000000)); // Rp 210.000

      final remaining = costLayerRepo.getById('layer_001');
      expect(remaining!.remainingQuantity.value, equals(3));
    });

    test('Test 2: Konsumsi lintas 2 layer (12 kg = 10 kg @ 30.000 + 2 kg @ 35.000)', () {
      costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'bawang_merah',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 3000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );
      costLayerRepo.save(
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

      final result = useCase.execute(
        batchId: 'batch_024',
        batchNumber: 'BATCH-024',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      // 10 * 30.000 (300.000) + 2 * 35.000 (70.000) = Rp 370.000
      expect(batch.totalMaterialCost.minorUnits, equals(37000000));

      final remainingLayer2 = costLayerRepo.getById('layer_002');
      expect(remainingLayer2!.remainingQuantity.value, equals(3));
    });

    test('Test 4: Jika stok tidak mencukupi, produksi HARUS gagal (tanpa stok negatif)', () {
      costLayerRepo.save(
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

      final result = useCase.execute(
        batchId: 'batch_025',
        batchNumber: 'BATCH-025',
        recipe: recipe,
        producedAt: DateTime.now(),
      );

      expect(result, isA<Failure>());
      final failure = result as Failure;
      expect(failure.error.toString(), contains('INSUFFICIENT_STOCK'));
    });

    test('Test 6 & 7: Total HPP Batch dan HPP per kg/satuan hasil produksi', () {
      costLayerRepo.save(
        CostLayer(
          id: 'layer_001',
          productId: 'bawang_putih',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 4000000, currency: 'IDR'), // Rp 40.000/kg
          acquiredAt: DateTime.now(),
        ),
      );

      final recipe = Recipe(
        id: 'rec_03',
        name: 'Bumbu Putih',
        items: [
          RecipeItem(
            productId: 'bawang_putih',
            quantityRequired: Quantity(value: 10, scale: 0), // Material: Rp 400.000
          ),
        ],
        expectedOutputQuantity: Quantity(value: 10, scale: 0), // Output 10 kg
      );

      final result = useCase.execute(
        batchId: 'batch_026',
        batchNumber: 'BATCH-026',
        recipe: recipe,
        producedAt: DateTime.now(),
        additionalProductionCost: const Money(minorUnits: 10000000, currency: 'IDR'), // Biaya Gas/Kemasan: Rp 100.000
      );

      expect(result, isA<Success>());
      final batch = (result as Success).value;
      // Total Batch Cost = Rp 400.000 + Rp 100.000 = Rp 500.000
      expect(batch.totalBatchCost.minorUnits, equals(50000000));
      // HPP per kg = Rp 500.000 / 10 kg = Rp 50.000 / kg
      expect(batch.unitCost.minorUnits, equals(5000000));
    });
  });
}
