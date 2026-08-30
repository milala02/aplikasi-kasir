import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/orders/application/process_stock_out_use_case.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';
import 'package:aplikasi_kasir/features/sync/application/sync_orchestrator.dart';
import 'package:aplikasi_kasir/features/sync/domain/master_data_pull.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_api_client.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_uuid.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/drift_master_data_pull_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/drift_sync_queue_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/drift_sync_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/http_sync_api_client.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_pull_state_repository.dart';

class _FakeMasterDataApiClient implements SyncApiClient {
  @override
  Future<void> push(SyncQueueEntry entry, {String? authToken}) async {}

  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    final t = DateTime.utc(2026, 8, 20);
    return MasterDataPull(
      products: [
        PulledProduct(
          id: '550e8400-e29b-41d4-a716-446655440000',
          sku: 'BM-001',
          name: 'Bawang Merah',
          stockUomId: SyncUuid.uom('kilogram'),
          categoryId: '9c0e1234-e29b-41d4-a716-446655440001',
          isActive: true,
          createdAt: t,
          updatedAt: t,
        ),
      ],
      categories: [
        PulledCategory(
          id: '9c0e1234-e29b-41d4-a716-446655440001',
          name: 'Bumbu Dapur',
          isActive: true,
          createdAt: t,
          updatedAt: t,
        ),
      ],
      uoms: [
        PulledUom(
          id: SyncUuid.uom('kilogram'),
          name: 'kilogram',
          symbol: 'kg',
          isActive: true,
          createdAt: t,
          updatedAt: t,
        ),
        PulledUom(
          id: SyncUuid.uom('pcs'),
          name: 'pcs',
          symbol: 'pcs',
          isActive: true,
          createdAt: t,
          updatedAt: t,
        ),
      ],
    );
  }
}

void main() {
  group('Fase 10 — verifikasi integrasi', () {
    test(
        'sinkronisasi awal di database kosong: pull master data '
        'mengisi products/uoms/categories + kursor tersimpan', () async {
      final dir = await Directory.systemTemp.createTemp('fase10_pull');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      // Database benar-benar kosong.
      expect(await (db.select(db.productsTable)).get(), isEmpty);
      expect(await (db.select(db.uomsTable)).get(), isEmpty);
      expect(await (db.select(db.categoriesTable)).get(), isEmpty);

      final pullState = InMemoryPullStateRepository();
      final orchestrator = SyncOrchestrator(
        queueRepository: DriftSyncQueueRepository(db),
        apiClient: _FakeMasterDataApiClient(),
        syncStateRepository: DriftSyncStateRepository(db),
        masterDataRepository: DriftMasterDataPullRepository(db),
        pullStateRepository: pullState,
      );

      final result = await orchestrator.pullMasterData(authToken: 'jwt-1');

      expect(result.since, isNull); // tarik penuh pertama kali
      expect(result.productsUpserted, 1);
      expect(result.categoriesUpserted, 1);
      expect(result.uomsUpserted, 2);
      expect(result.productsSkipped, 0);
      expect(pullState.lastPullAt, isNotNull);

      final products = await (db.select(db.productsTable)).get();
      expect(products.single.sku, 'BM-001');
      expect(products.single.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(products.single.baseUnit, 'kilogram');

      expect((await (db.select(db.uomsTable)).get()), hasLength(2));
      expect((await (db.select(db.categoriesTable)).get()).single.name,
          'Bumbu Dapur');

      // Pull kedua memakai kursor since dari pull pertama.
      final cursorAfterFirst = pullState.lastPullAt;
      final second = await orchestrator.pullMasterData(authToken: 'jwt-1');
      expect(second.since, cursorAfterFirst);
    });

    test(
        'isolasi stok: transaksi web (channel web) yang di-push ke backend '
        'TIDAK mengubah cost layer & stok POS lokal', () async {
      final costLayerRepo = InMemoryCostLayerRepository();
      final inventoryRepo = InMemoryInventoryRepository();
      final saleRepo = InMemorySaleRepository();
      final stockOutUseCase = ProcessStockOutUseCase(
        costLayerService: CostLayerService(repository: costLayerRepo),
        costLayerRepository: costLayerRepo,
        inventoryRepository: inventoryRepo,
        saleRepository: saleRepo,
      );

      // 1. Seed stok lokal (POS).
      await costLayerRepo.save(CostLayer(
        id: 'layer_001',
        productId: 'beras',
        originalQuantity: Quantity(value: 10, scale: 0),
        remainingQuantity: Quantity(value: 10, scale: 0),
        unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
        acquiredAt: DateTime.utc(2026, 8, 1),
      ));

      // 2. Transaksi POS lokal: stock-out 3 kg.
      final sale = Sale(
        id: 'sale_pos_1',
        invoiceNumber: 'INV-POS-1',
        items: [
          SaleItem(
            productId: 'beras',
            productName: 'Beras',
            unit: Unit.kilogram,
            quantity: Quantity(value: 3, scale: 0),
            unitPrice: const Money(minorUnits: 1500000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime.utc(2026, 8, 20),
      );
      await saleRepo.save(sale);
      final result = await stockOutUseCase.execute(sale);
      expect(result, isA<Success<Sale>>());

      final layerBefore = (await costLayerRepo.getById('layer_001'))!;
      expect(layerBefore.remainingQuantity.value, 7);

      // 3. Transaksi web (channel web) 5 kg — hanya payload ke backend,
      //    tidak melewati pipeline stok lokal.
      final webPayload = {
        'orders': [
          {
            'id': SyncUuid.entity('web-order-1'),
            'orderNumber': 'WEB-001',
            'channel': 'web',
            'totalAmountMinorUnits': 7500000,
            'createdAt': DateTime.utc(2026, 8, 20).toIso8601String(),
            'items': [
              {
                'productId': SyncUuid.entity('beras'),
                'enteredQuantity': 5,
                'enteredUomId': SyncUuid.uom('kilogram'),
                'normalizedStockQty': 5,
                'stockUomId': SyncUuid.uom('kilogram'),
                'priceMinorUnits': 1500000,
                'subtotalMinorUnits': 7500000,
              },
            ],
          },
        ],
      };

      String? pushedBody;
      final mockServer = MockClient((request) async {
        expect(request.url.path, '/api/v1/sync/push');
        pushedBody = request.body;
        return http.Response('{"status":"SUCCESS"}', 200);
      });
      final apiClient = HttpSyncApiClient(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mockServer,
      );
      await apiClient.push(
        SyncQueueEntry(
          id: 'sq_web_1',
          endpoint: '/api/v1/sync/push',
          sourceTable: 'order',
          referenceId: 'web-order-1',
          payloadJson: jsonEncode(webPayload),
          status: SyncQueueStatus.pending,
          retryCount: 0,
          createdAt: DateTime.utc(2026, 8, 20),
          updatedAt: DateTime.utc(2026, 8, 20),
        ),
      );

      // 4. Stok POS lokal tidak tersentuh transaksi web.
      final layerAfter = (await costLayerRepo.getById('layer_001'))!;
      expect(layerAfter.remainingQuantity.value, 7);
      final movements = await inventoryRepo.getMovements('beras');
      expect(
        movements.where((m) => (m.referenceId ?? '').contains('web')),
        isEmpty,
      );
      expect(pushedBody, contains('"channel":"web"'));
    });
  });
}
