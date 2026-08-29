import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';

void main() {
  group('InMemoryInventoryRepository', () {
    test('saves and retrieves a ledger', () async {
      final repository = InMemoryInventoryRepository();
      final ledger = StockLedger(
        productId: 'product-001',
      );

      await repository.saveLedger(ledger);

      expect(
        await repository.getLedger('product-001'),
        equals(ledger),
      );
    });

    test('records and retrieves movements by product', () async {
      final repository = InMemoryInventoryRepository();
      final movement = createMovement();

      await repository.recordMovement(movement);

      expect(
        await repository.getMovements('product-001'),
        [movement],
      );
      expect(
        await repository.getMovements('product-002'),
        isEmpty,
      );
    });

    test('updates an existing ledger', () async {
      final repository = InMemoryInventoryRepository();

      await repository.saveLedger(
        StockLedger(
          productId: 'product-001',
        ),
      );

      final movement = createMovement();

      await repository.saveLedger(
        StockLedger(
          productId: 'product-001',
          movements: [movement],
        ),
      );

      expect(
        (await repository.getLedger('product-001'))?.movements,
        [movement],
      );
    });

    test('rejects duplicate movement id', () async {
      final repository = InMemoryInventoryRepository();
      final movement = createMovement();

      await repository.recordMovement(movement);

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
