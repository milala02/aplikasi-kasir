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

    test('repository exposes ledger and movement operations', () async {
      final repository = _FakeInventoryRepository();

      final movement = StockMovement(
        id: 'movement-001',
        productId: 'product-001',
        quantity: Quantity(value: 10),
        type: StockMovementType.purchase,
        occurredAt: DateTime(2026, 1, 1),
      );

      await repository.recordMovement(movement);

      expect(
        await repository.getMovements('product-001'),
        contains(movement),
      );

      final ledger = StockLedger(
        productId: 'product-001',
        movements: [movement],
      );

      await repository.saveLedger(ledger);

      expect(
        await repository.getLedger('product-001'),
        equals(ledger),
      );
    });

    test('returns no ledger for an unknown product', () async {
      final repository = _FakeInventoryRepository();

      expect(await repository.getLedger('unknown'), isNull);
      expect(await repository.getMovements('unknown'), isEmpty);
    });
  });
}

class _FakeInventoryRepository implements InventoryRepository {
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> _movements = [];

  @override
  Future<StockLedger?> getLedger(String productId) async => _ledgers[productId];

  @override
  Future<List<StockMovement>> getMovements(String productId) async {
    return List.unmodifiable(
      _movements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  Future<void> saveLedger(StockLedger ledger) async {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  Future<void> recordMovement(StockMovement movement) async {
    _movements.add(movement);
  }
}
