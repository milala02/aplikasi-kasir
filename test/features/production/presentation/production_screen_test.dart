import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/production/application/execute_production_use_case.dart';
import 'package:aplikasi_kasir/features/production/application/process_production_batch_use_case.dart';
import 'package:aplikasi_kasir/features/production/application/record_production_output_use_case.dart';
import 'package:aplikasi_kasir/features/production/domain/production_batch.dart';
import 'package:aplikasi_kasir/features/production/presentation/production_screen.dart';
import 'package:aplikasi_kasir/features/recipes/domain/recipe.dart';
import 'package:aplikasi_kasir/features/recipes/infrastructure/in_memory_recipe_repository.dart';

void main() {
  group('ProductionScreen - produksi dari resep nyata', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late InMemoryProductRepository productRepo;
    late InMemoryRecipeRepository recipeRepo;

    setUp(() async {
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      productRepo = InMemoryProductRepository();
      recipeRepo = InMemoryRecipeRepository();

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
      productRepo.save(
        const Product(
          id: 'prod_bawang_merah',
          sku: 'BM-001',
          name: 'Bawang Merah',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 0, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 0, currency: 'IDR'),
        ),
      );
      productRepo.save(
        const Product(
          id: 'prod_tanpa_stok',
          sku: 'TS-001',
          name: 'Tanpa Stok',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 0, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 0, currency: 'IDR'),
        ),
      );

      await costLayerRepo.save(
        CostLayer(
          id: 'layer_bm',
          productId: 'prod_bawang_merah',
          originalQuantity: Quantity(value: 10, scale: 3), // 10 kg
          remainingQuantity: Quantity(value: 10, scale: 3),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'), // Rp 10.000/kg
          acquiredAt: DateTime.now(),
        ),
      );

      await recipeRepo.save(
        Recipe(
          id: 'rec_1',
          name: 'Bumbu Utama',
          items: [
            RecipeItem(
              productId: 'prod_bawang_merah',
              quantityRequired: Quantity(value: 6, scale: 3),
            ),
          ],
          expectedOutputQuantity: Quantity(value: 182, scale: 1),
          outputProductId: 'prod_bumbu_utama',
        ),
      );
      await recipeRepo.save(
        Recipe(
          id: 'rec_noout',
          name: 'Resep Tanpa Output',
          items: [
            RecipeItem(
              productId: 'prod_bawang_merah',
              quantityRequired: Quantity(value: 1, scale: 0),
            ),
          ],
          expectedOutputQuantity: Quantity(value: 100, scale: 1),
        ),
      );
    });

    Widget buildApp({bool delayExecution = false}) {
      final processBatch = delayExecution
          ? _DelayedProcessBatchUseCase(
              costLayerRepository: costLayerRepo,
              inventoryRepository: inventoryRepo,
            )
          : ProcessProductionBatchUseCase(
              costLayerRepository: costLayerRepo,
              inventoryRepository: inventoryRepo,
            );
      final recordOutput = RecordProductionOutputUseCase(
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
      );
      final executeProduction = ExecuteProductionUseCase(
        processBatchUseCase: processBatch,
        recordOutputUseCase: recordOutput,
        productRepository: productRepo,
      );

      return MaterialApp(
        home: ProductionAndPortioningScreen(
          costLayerRepository: costLayerRepo,
          executeProductionUseCase: executeProduction,
          recipeRepository: recipeRepo,
          productRepository: productRepo,
        ),
      );
    }

    Future<void> selectRecipe(WidgetTester tester, String name) async {
      await tester.tap(find.byKey(const Key('production_recipe_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(name).last);
      await tester.pumpAndSettle();
    }

    testWidgets('produksi sukses: bahan FIFO berkurang + output tercatat',
        (tester) async {
      await tester.pumpWidget(buildApp());

      // Tombol disabled sebelum resep dipilih.
      final button = find.byKey(const Key('production_execute_button'));
      expect(tester.widget<ElevatedButton>(button).onPressed, isNull);

      await selectRecipe(tester, 'Bumbu Utama');
      expect(find.textContaining('Produk hasil: Bumbu Utama'), findsOneWidget);

      await tester.enterText(
          find.byKey(const Key('production_batch_number_field')), 'BATCH-001');
      await tester.tap(button);
      await tester.pumpAndSettle();

      // Bahan: 10 - 6 = 4 (scale 3).
      final material = await costLayerRepo.getById('layer_bm');
      expect(material!.remainingQuantity, Quantity(value: 4, scale: 3));

      // Output: satu CostLayer untuk Bumbu Utama.
      final outputLayers =
          await costLayerRepo.getByProductId('prod_bumbu_utama');
      expect(outputLayers, hasLength(1));
      expect(outputLayers.single.originalQuantity,
          Quantity(value: 182, scale: 1));

      expect(find.textContaining('PRODUKSI BERHASIL'), findsOneWidget);
    });

    testWidgets('double tap saat eksekusi tidak membuat dua batch',
        (tester) async {
      await tester.pumpWidget(buildApp(delayExecution: true));
      await selectRecipe(tester, 'Bumbu Utama');

      final button = find.byKey(const Key('production_execute_button'));
      await tester.tap(button);
      await tester.pump(); // Satu frame: eksekusi masih berjalan (delay).

      // Tombol disabled selama busy -> tap kedua tidak mungkin.
      expect(tester.widget<ElevatedButton>(button).onPressed, isNull);

      await tester.pumpAndSettle();

      // Hanya satu konsumsi.
      final material = await costLayerRepo.getById('layer_bm');
      expect(material!.remainingQuantity, Quantity(value: 4, scale: 3));
      expect(await costLayerRepo.getByProductId('prod_bumbu_utama'),
          hasLength(1));
    });

    testWidgets('resep tanpa produk hasil -> tombol tetap disabled',
        (tester) async {
      await tester.pumpWidget(buildApp());

      await selectRecipe(tester, 'Resep Tanpa Output');

      expect(find.textContaining('tidak punya produk hasil'), findsOneWidget);
      final button = find.byKey(const Key('production_execute_button'));
      expect(tester.widget<ElevatedButton>(button).onPressed, isNull);
    });

    Future<void> selectPortionProduct(
        WidgetTester tester, String name) async {
      await tester.tap(find.text('Kalkulator Ketengan Lada'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('portion_product_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(name).last);
      await tester.pumpAndSettle();
    }

    testWidgets(
        'ketengan: produk tanpa cost layer -> pesan ramah tanpa crash',
        (tester) async {
      await tester.pumpWidget(buildApp());
      await selectPortionProduct(tester, 'Tanpa Stok');

      await tester.tap(find.text('HITUNG TAKARAN GRAM OTOMATIS'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('catat penerimaan dulu'),
        findsOneWidget,
      );
    });

    testWidgets(
        'ketengan: produk dengan layer -> rekomendasi muncul dan FIFO tidak '
        'berkurang', (tester) async {
      await tester.pumpWidget(buildApp());
      await selectPortionProduct(tester, 'Bawang Merah');

      // Isi field yang diperlukan untuk kalkulasi
      await tester.enterText(
          find.byKey(const Key('portion_price_field')), '10000');
      await tester.enterText(
          find.byKey(const Key('portion_margin_field')), '30');
      await tester.enterText(
          find.byKey(const Key('portion_pkg_cost_field')), '300');

      await tester.tap(find.text('HITUNG TAKARAN GRAM OTOMATIS'));
      await tester.pumpAndSettle();

      expect(find.textContaining('HASIL REKOMENDASI TAKARAN'), findsOneWidget);
      // Kalkulasi rekomendasi TIDAK mengonsumsi layer FIFO.
      final layer = await costLayerRepo.getById('layer_bm');
      expect(layer!.remainingQuantity.value, equals(10));
    });
  });
}

class _DelayedProcessBatchUseCase extends ProcessProductionBatchUseCase {
  _DelayedProcessBatchUseCase({
    required super.costLayerRepository,
    required super.inventoryRepository,
  });

  @override
  Future<Result<ProductionBatch>> execute({
    required String batchId,
    required String batchNumber,
    required Recipe recipe,
    required DateTime producedAt,
    Money? additionalProductionCost,
    Quantity? actualOutputQuantity,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return super.execute(
      batchId: batchId,
      batchNumber: batchNumber,
      recipe: recipe,
      producedAt: producedAt,
      additionalProductionCost: additionalProductionCost,
      actualOutputQuantity: actualOutputQuantity,
    );
  }
}
