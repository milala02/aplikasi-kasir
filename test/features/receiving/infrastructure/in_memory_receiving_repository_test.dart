import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/receiving/domain/receiving.dart';
import 'package:aplikasi_kasir/features/receiving/infrastructure/in_memory_receiving_repository.dart';

void main() {
  group('InMemoryReceivingRepository', () {
    late InMemoryReceivingRepository repository;

    setUp(() {
      repository = InMemoryReceivingRepository();
    });

    test('harus dapat menyimpan dan mengambil receiving berdasarkan ID', () {
      final receiving = Receiving(
        id: 'rec_001',
        purchaseId: 'po_001',
        receivedAt: DateTime.now(),
        items: [
          ReceivingItem(
            id: 'item_001',
            productId: 'prod_100',
            quantityReceived: Quantity(value: 5, scale: 0),
            unitCost: Money(minorUnits: 1000000, currency: 'IDR'),
          ),
        ],
      );

      repository.save(receiving);

      final result = repository.getById('rec_001');
      expect(result, isNotNull);
      expect(result!.id, equals('rec_001'));
      expect(result.purchaseId, equals('po_001'));
    });

    test('harus dapat mengambil daftar receiving berdasarkan purchaseId', () {
      final receiving1 = Receiving(
        id: 'rec_001',
        purchaseId: 'po_001',
        receivedAt: DateTime.now(),
        items: [
          ReceivingItem(
            id: 'item_001',
            productId: 'prod_100',
            quantityReceived: Quantity(value: 5, scale: 0),
            unitCost: Money(minorUnits: 1000000, currency: 'IDR'),
          ),
        ],
      );

      final receiving2 = Receiving(
        id: 'rec_002',
        purchaseId: 'po_001',
        receivedAt: DateTime.now(),
        items: [
          ReceivingItem(
            id: 'item_002',
            productId: 'prod_200',
            quantityReceived: Quantity(value: 2, scale: 0),
            unitCost: Money(minorUnits: 2000000, currency: 'IDR'),
          ),
        ],
      );

      repository.save(receiving1);
      repository.save(receiving2);

      final list = repository.getByPurchaseId('po_001');
      expect(list.length, equals(2));
    });
  });
}
