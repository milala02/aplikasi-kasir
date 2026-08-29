import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/production/application/execute_production_use_case.dart';
import 'package:aplikasi_kasir/features/production/application/process_production_batch_use_case.dart';
import 'package:aplikasi_kasir/features/production/application/record_production_output_use_case.dart';
import 'package:aplikasi_kasir/features/production/domain/production_batch.dart';
import 'package:aplikasi_kasir/features/recipes/domain/recipe.dart';

void main() {
  group('ExecuteProductionUseCase - Recipe -> FIFO -> Output', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late InMemoryProductRepository productRepo;
    late ExecuteProductionUseCase useCase;

    setUp(() async {
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      productRepo = InMemoryProductRepository();

      final processBatch = ProcessProductionBatchUseCase(
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
      );
      final recordOutput = RecordProductionOutputUseCase(
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
      );
      useCase = ExecuteProductionUseCase(
        processBatchUseCase: processBatch,
        recordOutputUseCase: recordOutput,
        productRepository: productRepo,
      );

      productRepo.save(
        const Product(
          id: 'prod_bumbu_utama',
          sku: 'BU-001',
          name: 'Bumbu Utama',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 0, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 0, currency: 'IDR'),
        ),
      );

      await costLayerRepo.save(
        CostLayer(
          id: 'layer_bm',
          productId: 'prod_bawang_merah',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );
    });

    Recipe buildRecipe({String? outputProductId = 'prod_bumbu_utama'}) {
      return Recipe(
        id: 'rec_1',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'prod_bawang_merah',
            quantityRequired: Quantity(value: 6, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
        outputProductId: outputProductId,
      );
    }

    test('produksi sukses: bahan FIFO berkurang + output CostLayer benar',
        () async {
      final result = await useCase.execute(
        recipe: buildRecipe(),
        batchNumber: 'BATCH-001',
      );

      expect(result, isA<Success<ProductionBatch>>());
      final batch = (result as Success<ProductionBatch>).value;

      // Bahan berkurang: 10 - 6 = 4 kg.
      final material = await costLayerRepo.getById('layer_bm');
      expect(material!.remainingQuantity, Quantity(value: 4, scale: 0));

      // Output layer: produk hasil nyata dari Recipe, HPP = HPP batch.
      final outputLayers =
          await costLayerRepo.getByProductId('prod_bumbu_utama');
      expect(outputLayers, hasLength(1));
      final output = outputLayers.single;
      expect(output.originalQuantity, Quantity(value: 182, scale: 1));
      expect(output.unitCost, batch.unitCost);

      // HPP material 6 kg x 10.000 = 60.000; per unit (scale 1):
      // 60.000 * 10 / 182 = 3.296 (pembulatan integer).
      expect(batch.totalMaterialCost,
          const Money(minorUnits: 6000000, currency: 'IDR'));
      expect(output.unitCost,
          const Money(minorUnits: 329670, currency: 'IDR'));

      // Movement outbound bahan + inbound output.
      final materialMovements =
          await inventoryRepo.getMovements('prod_bawang_merah');
      expect(materialMovements, hasLength(1));
      final outputMovements =
          await inventoryRepo.getMovements('prod_bumbu_utama');
      expect(outputMovements, hasLength(1));
      expect(outputMovements.first.type, StockMovementType.production);
      expect(outputMovements.first.isIncrease, isTrue);
    });

    test('recipe tanpa outputProductId -> gagal SEBELUM konsumsi', () async {
      final result = await useCase.execute(
        recipe: buildRecipe(outputProductId: null),
        batchNumber: 'BATCH-002',
      );

      expect(result, isA<Failure>());
      expect((result as Failure).error.toString(),
          contains('RECIPE_NO_OUTPUT'));

      final material = await costLayerRepo.getById('layer_bm');
      expect(material!.remainingQuantity, Quantity(value: 10, scale: 0));
      expect(await costLayerRepo.getByProductId('prod_bumbu_utama'), isEmpty);
    });

    test('output product tidak dikenal -> gagal SEBELUM konsumsi', () async {
      final result = await useCase.execute(
        recipe: buildRecipe(outputProductId: 'ghost_product'),
        batchNumber: 'BATCH-003',
      );

      expect(result, isA<Failure>());
      expect((result as Failure).error.toString(),
          contains('INVALID_OUTPUT_PRODUCT'));

      final material = await costLayerRepo.getById('layer_bm');
      expect(material!.remainingQuantity, Quantity(value: 10, scale: 0));
    });

    test('stok bahan kurang -> Failure tanpa output dan tanpa konsumsi',
        () async {
      // Recipe butuh 12 kg, layer hanya 10 kg.
      final recipe = Recipe(
        id: 'rec_2',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'prod_bawang_merah',
            quantityRequired: Quantity(value: 12, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
        outputProductId: 'prod_bumbu_utama',
      );

      final result = await useCase.execute(
        recipe: recipe,
        batchNumber: 'BATCH-004',
      );

      expect(result, isA<Failure>());
      expect((result as Failure).error.toString(),
          contains('INSUFFICIENT_STOCK'));

      final material = await costLayerRepo.getById('layer_bm');
      expect(material!.remainingQuantity, Quantity(value: 10, scale: 0));
      expect(await costLayerRepo.getByProductId('prod_bumbu_utama'), isEmpty);
      expect(await inventoryRepo.getMovements('prod_bumbu_utama'), isEmpty);
    });
  });
}
