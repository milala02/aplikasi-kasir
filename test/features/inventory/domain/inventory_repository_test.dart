import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/inventory_repository.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';

void main() {
  group('InventoryRepository', () {
    test('defines the inventory repository contract', () {
      final repository = _FakeInventoryRepository();

      expect(repository, isA<InventoryRepository>());
    });

    test('repository exposes ledger and movement operations', () {
      final repository = _FakeInventoryRepository();

      final movement = StockMovement(
        id: 'movement-001',
        productId: 'product-001',
        quantity: Quantity(value: 10),
        type: StockMovementType.purchase,
        occurredAt: DateTime(2026, 1, 1),
      );

      repository.recordMovement(movement);

      expect(
        repository.getMovements('product-001'),
        contains(movement),
      );

      final ledger = StockLedger(
        productId: 'product-001',
        movements: [movement],
      );

      repository.saveLedger(ledger);

      expect(
        repository.getLedger('product-001'),
        equals(ledger),
      );
    });

    test('returns no ledger for an unknown product', () {
      final repository = _FakeInventoryRepository();

      expect(repository.getLedger('unknown'), isNull);
      expect(repository.getMovements('unknown'), isEmpty);
    });
  });
}

class _FakeInventoryRepository implements InventoryRepository {
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> _movements = [];

  @override
  StockLedger? getLedger(String productId) => _ledgers[productId];

  @override
  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(
      _movements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  void saveLedger(StockLedger ledger) {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  void recordMovement(StockMovement movement) {
    _movements.add(movement);
  }
}
