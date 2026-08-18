import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';

void main() {
  group('StockLedger', () {
    final occurredAt = DateTime(2026, 8, 18, 10, 0);

    StockMovement movement({
      required String id,
      required int quantity,
      required StockMovementType type,
    }) {
      return StockMovement(
        id: id,
        productId: 'product-001',
        quantity: Quantity(
          value: quantity,
        ),
        type: type,
        occurredAt: occurredAt,
      );
    }

    test('empty ledger has zero balance', () {
      const ledger = StockLedger();

      expect(
        ledger.calculateBalance(),
        Quantity.zero(),
      );
    });

    test('calculates stock from movements', () {
      var ledger = const StockLedger();

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 50,
          type: StockMovementType.purchase,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-002',
          quantity: 10,
          type: StockMovementType.sale,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-003',
          quantity: 2,
          type: StockMovementType.damage,
        ),
      );

      expect(
        ledger.calculateBalance(),
        Quantity(
          value: 38,
        ),
      );
    });

    test('supports stock adjustment', () {
      var ledger = const StockLedger();

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 20,
          type: StockMovementType.purchase,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-002',
          quantity: 5,
          type: StockMovementType.adjustmentDecrease,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-003',
          quantity: 3,
          type: StockMovementType.adjustmentIncrease,
        ),
      );

      expect(
        ledger.calculateBalance(),
        Quantity(
          value: 18,
        ),
      );
    });

    test('does not modify the original ledger', () {
      const original = StockLedger();

      final updated = original.addMovement(
        movement(
          id: 'movement-001',
          quantity: 10,
          type: StockMovementType.purchase,
        ),
      );

      expect(original.movements, isEmpty);
      expect(updated.movements, hasLength(1));
    });

    test('rejects zero quantity movement', () {
      const ledger = StockLedger();

      expect(
        () => ledger.addMovement(
          movement(
            id: 'movement-001',
            quantity: 0,
            type: StockMovementType.purchase,
          ),
        ),
        throwsArgumentError,
      );
    });

    test('supports quantities with different scales', () {
  var ledger = const StockLedger();

  ledger = ledger.addMovement(
    movement(
      id: 'movement-001',
      quantity: 10,
      type: StockMovementType.purchase,
    ),
  );

  ledger = ledger.addMovement(
    StockMovement(
      id: 'movement-002',
      productId: 'product-001',
      quantity: Quantity(
  value: 500,
  scale: 3,
),
      ),
      type: StockMovementType.sale,
      occurredAt: occurredAt,
    ),
  );

  expect(
    ledger.calculateBalance(),
     Quantity(
      value: 9500,
      scale: 3,
    ),
  );
});

    test('rejects selling more stock than available', () {
      var ledger = const StockLedger();

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 5,
          type: StockMovementType.purchase,
        ),
      );

      expect(
        () => ledger.addMovement(
          movement(
            id: 'movement-002',
            quantity: 6,
            type: StockMovementType.sale,
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
