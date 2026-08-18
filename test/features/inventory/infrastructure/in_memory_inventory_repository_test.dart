import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';

void main() {
  group('InMemoryInventoryRepository', () {
    test('saves and retrieves a ledger', () {
      final repository = InMemoryInventoryRepository();
      final ledger = StockLedger(
        productId: 'product-001',
      );

      repository.saveLedger(ledger);

      expect(
        repository.getLedger('product-001'),
        equals(ledger),
      );
    });

    test('records and retrieves movements by product', () {
      final repository = InMemoryInventoryRepository();
      final movement = createMovement();

      repository.recordMovement(movement);

      expect(
        repository.getMovements('product-001'),
        [movement],
      );
      expect(
        repository.getMovements('product-002'),
        isEmpty,
      );
    });

    test('updates an existing ledger', () {
      final repository = InMemoryInventoryRepository();

      repository.saveLedger(
        StockLedger(
          productId: 'product-001',
        ),
      );

      final movement = createMovement();

      repository.saveLedger(
        StockLedger(
          productId: 'product-001',
          movements: [movement],
        ),
      );

      expect(
        repository.getLedger('product-001')?.movements,
        [movement],
      );
    });

    test('rejects duplicate movement id', () {
      final repository = InMemoryInventoryRepository();
      final movement = createMovement();

      repository.recordMovement(movement);

      expect(
        () => repository.recordMovement(movement),
        throwsArgumentError,
      );
    });
  });
}

StockMovement createMovement() {
  return StockMovement(
    id: 'movement-001',
    productId: 'product-001',
    quantity: Quantity(value: 10),
    type: StockMovementType.purchase,
    occurredAt: DateTime(2026, 1, 1),
  );
}
