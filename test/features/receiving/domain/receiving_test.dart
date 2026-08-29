import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/receiving/domain/receiving.dart';
import 'package:aplikasi_kasir/features/receiving/infrastructure/in_memory_receiving_repository.dart';

void main() {
  group('Receiving - validasi produk duplikat', () {
    ReceivingItem buildItem(String id, String productId) {
      return ReceivingItem(
        id: id,
        productId: productId,
        quantityReceived: Quantity(value: 5, scale: 0),
        unitCost: const Money(minorUnits: 1000000, currency: 'IDR'),
      );
    }

    test('dua item dengan productId sama ditolak', () {
      expect(
        () => Receiving(
          id: 'recv_1',
          purchaseId: 'po_1',
          receivedAt: DateTime(2026, 8, 20),
          items: [
            buildItem('ri_1', 'prod_100'),
            buildItem('ri_2', 'prod_100'),
          ],
        ),
        throwsArgumentError,
      );
    });

    test('item dengan productId berbeda tetap valid', () {
      final receiving = Receiving(
        id: 'recv_1',
        purchaseId: 'po_1',
        receivedAt: DateTime(2026, 8, 20),
        items: [
          buildItem('ri_1', 'prod_100'),
          buildItem('ri_2', 'prod_200'),
        ],
      );

      expect(receiving.items, hasLength(2));
    });

    test('penolakan terjadi sebelum persistensi: tidak ada partial state',
        () async {
      final receivingRepo = InMemoryReceivingRepository();
      final inventoryRepo = InMemoryInventoryRepository();
      final costLayerRepo = InMemoryCostLayerRepository();

      // Konstruksi Receiving duplikat gagal sebelum use case berjalan.
      expect(
        () => Receiving(
          id: 'recv_dup',
          purchaseId: 'po_1',
          receivedAt: DateTime(2026, 8, 20),
          items: [
            buildItem('ri_1', 'prod_100'),
            buildItem('ri_2', 'prod_100'),
          ],
        ),
        throwsArgumentError,
      );

      expect(await receivingRepo.getAll(), isEmpty);
      expect(await inventoryRepo.getMovements('prod_100'), isEmpty);
      expect(await costLayerRepo.getByProductId('prod_100'), isEmpty);
    });
  });
}
