import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/receiving/domain/receiving.dart';
import 'package:aplikasi_kasir/features/receiving/domain/receiving_repository.dart';
import 'package:aplikasi_kasir/features/receiving/application/receive_goods_use_case.dart';

class InMemoryReceivingRepository implements ReceivingRepository {
  final Map<String, Receiving> _receivings = {};

  @override
  Receiving? getById(String id) => _receivings[id];

  @override
  List<Receiving> getByPurchaseId(String purchaseId) {
    return _receivings.values.where((r) => r.purchaseId == purchaseId).toList();
  }

  @override
  List<Receiving> getAll() => _receivings.values.toList();

  @override
  void save(Receiving receiving) {
    _receivings[receiving.id] = receiving;
  }
}

void main() {
  group('ReceiveGoodsUseCase', () {
    late InMemoryReceivingRepository receivingRepo;
    late InMemoryInventoryRepository inventoryRepo;
    late InMemoryCostLayerRepository costLayerRepo;
    late ReceiveGoodsUseCase useCase;

    setUp(() {
      receivingRepo = InMemoryReceivingRepository();
      inventoryRepo = InMemoryInventoryRepository();
      costLayerRepo = InMemoryCostLayerRepository();
      useCase = ReceiveGoodsUseCase(
        receivingRepository: receivingRepo,
        inventoryRepository: inventoryRepo,
        costLayerRepository: costLayerRepo,
      );
    });

    test(
        'harus berhasil mencatat penerimaan barang, stok ledger, dan cost layer HPP',
        () async {
      final receiving = Receiving(
        id: 'rec_001',
        purchaseId: 'po_001',
        receivedAt: DateTime.now(),
        items: [
          ReceivingItem(
            id: 'item_001',
            productId: 'prod_100',
            quantityReceived: Quantity(value: 10, scale: 0),
            unitCost: Money(minorUnits: 1500000, currency: 'IDR'), // Rp 15.000
          ),
        ],
      );

      final result = await useCase.execute(receiving);

      expect(result, isA<Success<void>>());

      // Verifikasi Receiving tersimpan
      final savedReceiving = receivingRepo.getById('rec_001');
      expect(savedReceiving, isNotNull);

      // Verifikasi Ledger Stok bertambah
      final ledger = await inventoryRepo.getLedger('prod_100');
      expect(ledger, isNotNull);
      expect(ledger!.calculateBalance().value, equals(10));

      // Verifikasi Cost Layer HPP terbentuk
      final costLayers = costLayerRepo.getByProductId('prod_100');
      expect(costLayers.length, equals(1));
      expect(costLayers.first.unitCost.minorUnits, equals(1500000));
    });
  });
}
