import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/process_stock_out_use_case.dart';
import 'package:aplikasi_kasir/features/production/application/record_production_output_use_case.dart';
import 'package:aplikasi_kasir/features/production/domain/production_batch.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('RecordProductionOutputUseCase - hasil produksi jadi stok FIFO', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late InMemorySaleRepository saleRepo;
    late RecordProductionOutputUseCase useCase;

    setUp(() {
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      saleRepo = InMemorySaleRepository();
      useCase = RecordProductionOutputUseCase(
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
      );
    });

    ProductionBatch buildBatch({
      String id = 'batch_001',
      int outputValue = 10,
      int outputScale = 0,
      int additionalCostMinor = 0,
    }) {
      return ProductionBatch(
        id: id,
        recipeId: 'rec_x',
        batchNumber: 'BATCH-001',
        producedAt: DateTime(2026, 8, 25, 9, 0),
        allocations: [
          MaterialCostAllocation(
            costLayerId: 'layer_in',
            productId: 'bawang_merah',
            quantityConsumed: Quantity(value: 10, scale: 0),
            unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          ),
        ],
        additionalProductionCost:
            Money(minorUnits: additionalCostMinor, currency: 'IDR'),
        actualOutputQuantity: Quantity(value: outputValue, scale: outputScale),
      );
    }

    test('menghasilkan CostLayer output dengan HPP batch + movement inbound',
        () async {
      final batch = buildBatch();
      final result = await useCase.execute(
        batch: batch,
        productId: 'bumbu_utama',
      );

      expect(result, isA<Success>());

      final layer = await costLayerRepo.getById('layer_prod_out_batch_001');
      expect(layer, isNotNull);
      expect(layer!.productId, 'bumbu_utama');
      expect(layer.originalQuantity, Quantity(value: 10, scale: 0));
      expect(layer.remainingQuantity, Quantity(value: 10, scale: 0));
      // HPP per unit: material 10 x 10.000 = 100.000 / 10 kg = 10.000.
      expect(layer.unitCost,
          const Money(minorUnits: 1000000, currency: 'IDR'));
      expect(layer.acquiredAt, DateTime(2026, 8, 25, 9, 0));

      final movements = await inventoryRepo.getMovements('bumbu_utama');
      expect(movements, hasLength(1));
      expect(movements.first.type, StockMovementType.production);
      expect(movements.first.isIncrease, isTrue);
      expect(movements.first.quantity, Quantity(value: 10, scale: 0));
      expect(movements.first.referenceId, 'batch_001');
    });

    test('HPP per unit memasukkan biaya tambahan (additionalProductionCost)',
        () async {
      final batch = buildBatch(additionalCostMinor: 1000000); // Rp 10.000
      // Total batch = 100.000 + 10.000 = 110.000 -> 11.000/kg.
      await useCase.execute(batch: batch, productId: 'bumbu_utama');

      final layer = await costLayerRepo.getById('layer_prod_out_batch_001');
      expect(layer!.unitCost,
          const Money(minorUnits: 1100000, currency: 'IDR'));
    });

    test('quantity scale output dipertahankan', () async {
      final batch = buildBatch(outputValue: 150, outputScale: 1);
      await useCase.execute(batch: batch, productId: 'bumbu_utama');

      final layer = await costLayerRepo.getById('layer_prod_out_batch_001');
      expect(layer!.originalQuantity, Quantity(value: 150, scale: 1));

      final movements = await inventoryRepo.getMovements('bumbu_utama');
      expect(movements.first.quantity, Quantity(value: 150, scale: 1));
    });

    test('output dapat dikonsumsi Sales melalui FIFO (stock-out)', () async {
      final batch = buildBatch();
      await useCase.execute(batch: batch, productId: 'bumbu_utama');

      final stockOut = ProcessStockOutUseCase(
        costLayerService: CostLayerService(repository: costLayerRepo),
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
        saleRepository: saleRepo,
      );

      final sale = Sale(
        id: 'sale_1',
        invoiceNumber: 'INV-1',
        items: [
          SaleItem(
            productId: 'bumbu_utama',
            productName: 'Bumbu Utama',
            unit: Unit.kilogram,
            quantity: Quantity(value: 4, scale: 0),
            unitPrice: const Money(minorUnits: 1500000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime(2026, 8, 25),
      );
      await saleRepo.save(sale);

      final result = await stockOut.execute(sale);

      expect(result, isA<Success<Sale>>());
      // HPP FIFO dari layer output produksi.
      expect(
        (result as Success<Sale>).value.items.single.unitCost,
        const Money(minorUnits: 1000000, currency: 'IDR'),
      );

      final layer = await costLayerRepo.getById('layer_prod_out_batch_001');
      expect(layer!.remainingQuantity, Quantity(value: 6, scale: 0));
    });

    test('pemanggilan ganda gagal tanpa membuat layer kedua', () async {
      final batch = buildBatch();
      await useCase.execute(batch: batch, productId: 'bumbu_utama');

      final second = await useCase.execute(
        batch: batch,
        productId: 'bumbu_utama',
      );

      expect(second, isA<Failure>());

      final layers =
          await costLayerRepo.getByProductId('bumbu_utama');
      expect(layers, hasLength(1));
      final movements = await inventoryRepo.getMovements('bumbu_utama');
      expect(movements, hasLength(1));
    });

    test('failure movement tidak meninggalkan layer output parsial',
        () async {
      final batch = buildBatch();
      // Pre-create movement dengan id yang sama agar recordMovement gagal.
      await inventoryRepo.recordMovement(
        StockMovement(
          id: 'mov_prod_out_batch_001',
          productId: 'bumbu_utama',
          quantity: Quantity(value: 10, scale: 0),
          type: StockMovementType.production,
          referenceId: 'batch_001',
          occurredAt: DateTime(2026, 8, 25, 9, 0),
        ),
      );

      final result = await useCase.execute(
        batch: batch,
        productId: 'bumbu_utama',
      );

      expect(result, isA<Failure>());
      expect(
          (result as Failure).error.toString(),
          contains('PRODUCTION_OUTPUT_ERROR'));

      // Tidak ada cost layer output yang tertinggal.
      expect(await costLayerRepo.getByProductId('bumbu_utama'), isEmpty);
    });
  });
}
