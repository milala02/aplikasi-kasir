import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/process_stock_out_use_case.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('ProcessStockOutUseCase - konsumsi FIFO saat stock-out', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late InMemorySaleRepository saleRepo;
    late ProcessStockOutUseCase useCase;

    setUp(() async {
      costLayerRepo = InMemoryCostLayerRepository();
      inventoryRepo = InMemoryInventoryRepository();
      saleRepo = InMemorySaleRepository();
      useCase = ProcessStockOutUseCase(
        costLayerService: CostLayerService(repository: costLayerRepo),
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
        saleRepository: saleRepo,
      );
    });

    SaleItem buildItem({String productId = 'beras', int quantity = 1}) {
      return SaleItem(
        productId: productId,
        productName: 'Beras',
        unit: Unit.kilogram,
        quantity: Quantity(value: quantity, scale: 0),
        unitPrice: const Money(minorUnits: 1500000, currency: 'IDR'),
      );
    }

    Future<Sale> seedSale({List<SaleItem>? items}) async {
      final sale = Sale(
        id: 'sale_test_001',
        invoiceNumber: 'INV-TEST-001',
        items: items ?? [buildItem(quantity: 3)],
        createdAt: DateTime.now(),
      );
      await saleRepo.save(sale);
      return sale;
    }

    Future<CostLayer> seedLayer({
      String id = 'layer_001',
      String productId = 'beras',
      int remaining = 10,
      int unitCostMinor = 1000000,
      DateTime? acquiredAt,
    }) async {
      final layer = CostLayer(
        id: id,
        productId: productId,
        originalQuantity: Quantity(value: 10, scale: 0),
        remainingQuantity: Quantity(value: remaining, scale: 0),
        unitCost: Money(minorUnits: unitCostMinor, currency: 'IDR'),
        acquiredAt: acquiredAt ?? DateTime.now(),
      );
      await costLayerRepo.save(layer);
      return layer;
    }

    test('stok cukup -> Success: FIFO berkurang, HPP terkunci, movement tercatat',
        () async {
      await seedLayer();
      final sale = await seedSale(items: [buildItem(quantity: 3)]);

      final result = await useCase.execute(sale);

      expect(result, isA<Success<Sale>>());
      final enriched = (result as Success<Sale>).value;
      expect(
        enriched.items.single.unitCost,
        const Money(minorUnits: 1000000, currency: 'IDR'),
      );

      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(7));

      // HPP tersimpan pada sale.
      expect(
        saleRepo.getById('sale_test_001')!.items.single.unitCost,
        const Money(minorUnits: 1000000, currency: 'IDR'),
      );

      final movements = await inventoryRepo.getMovements('beras');
      expect(movements, hasLength(1));
      expect(movements.first.type, equals(StockMovementType.sale));
      expect(movements.first.quantity.value, equals(3));
    });

    test('konsumsi lintas 2 layer berjalan FIFO (acquiredAt tertua dulu)',
        () async {
      await seedLayer(
        id: 'layer_new',
        remaining: 10,
        unitCostMinor: 1200000,
        acquiredAt: DateTime.now(),
      );
      await seedLayer(
        id: 'layer_old',
        remaining: 5,
        unitCostMinor: 1000000,
        acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      final sale = await seedSale(items: [buildItem(quantity: 12)]);

      final result = await useCase.execute(sale);

      expect(result, isA<Success<Sale>>());
      // (5 kg @ 10.000) + (7 kg @ 12.000) = 134.000 -> unit 1.116.666.
      final enriched = (result as Success<Sale>).value;
      expect(
        enriched.items.single.unitCost,
        const Money(minorUnits: 1116666, currency: 'IDR'),
      );

      final oldLayer = await costLayerRepo.getById('layer_old');
      expect(oldLayer!.remainingQuantity.value, equals(0));
      final newLayer = await costLayerRepo.getById('layer_new');
      expect(newLayer!.remainingQuantity.value, equals(3));
    });

    test('stok kurang -> Failure tanpa efek samping', () async {
      await seedLayer(remaining: 2);
      final sale = await seedSale(items: [buildItem(quantity: 5)]);

      final check = await useCase.checkAvailability(sale);
      expect(check, isA<Failure>());
      expect((check as Failure).error.toString(), contains('INSUFFICIENT_STOCK'));

      final result = await useCase.execute(sale);
      expect(result, isA<Failure>());

      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(2));
      expect(await inventoryRepo.getMovements('beras'), isEmpty);
      expect(saleRepo.getById('sale_test_001')!.items.single.unitCost, isNull);
    });

    test('multi-item: satu item kurang stok -> tanpa konsumsi parsial',
        () async {
      await seedLayer(productId: 'beras', remaining: 10);
      final sale = await seedSale(items: [
        buildItem(productId: 'beras', quantity: 2),
        buildItem(productId: 'gula', quantity: 5), // tanpa layer
      ]);

      final result = await useCase.execute(sale);

      expect(result, isA<Failure>());
      expect((result as Failure).error.toString(), contains('INSUFFICIENT_STOCK'));

      final layer = await costLayerRepo.getById('layer_001');
      expect(layer!.remainingQuantity.value, equals(10));
      expect(await inventoryRepo.getMovements('beras'), isEmpty);
      expect(await inventoryRepo.getMovements('gula'), isEmpty);
    });

    test(
        'skala campuran: dua layer fraksional yang dijumlah tepat memenuhi '
        'item tanpa false-negative', () async {
      // 1,5 + 1,5 = 3,0 kg pada skala 1; item butuh 3 scale 0.
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_a',
          productId: 'beras',
          originalQuantity: Quantity(value: 15, scale: 1),
          remainingQuantity: Quantity(value: 15, scale: 1),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      );
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_b',
          productId: 'beras',
          originalQuantity: Quantity(value: 15, scale: 1),
          remainingQuantity: Quantity(value: 15, scale: 1),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      );
      final sale = await seedSale(items: [buildItem(quantity: 3)]);

      final result = await useCase.execute(sale);

      expect(result, isA<Success<Sale>>());
      final layerA = await costLayerRepo.getById('layer_a');
      final layerB = await costLayerRepo.getById('layer_b');
      expect(layerA!.remainingQuantity.isZero, isTrue);
      expect(layerB!.remainingQuantity.isZero, isTrue);
    });

    test('skala campuran: layer lebih halus dari item -> tanpa overcount',
        () async {
      // Layer 250 scale 2 = 2,5 kg; item butuh 3 scale 0 -> harus gagal.
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_fine',
          productId: 'beras',
          originalQuantity: Quantity(value: 250, scale: 2),
          remainingQuantity: Quantity(value: 250, scale: 2),
          unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
          acquiredAt: DateTime.now(),
        ),
      );
      final sale = await seedSale(items: [buildItem(quantity: 3)]);

      final check = await useCase.checkAvailability(sale);
      expect(check, isA<Failure>());
      expect(
          (check as Failure).error.toString(), contains('INSUFFICIENT_STOCK'));

      final result = await useCase.execute(sale);
      expect(result, isA<Failure>());

      final layer = await costLayerRepo.getById('layer_fine');
      expect(layer!.remainingQuantity, Quantity(value: 250, scale: 2));
      expect(await inventoryRepo.getMovements('beras'), isEmpty);
    });
  });
}
