import '../../../core/quantity/quantity.dart';
import '../domain/inventory_repository.dart';
import '../domain/inventory_service.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class InventoryUseCases {
  final InventoryRepository repository;

  const InventoryUseCases({
    required this.repository,
  });

  Future<StockLedger?> getLedger(String productId) {
    return repository.getLedger(productId);
  }

  Future<List<StockMovement>> getMovements(String productId) async {
    return List.unmodifiable(
      await repository.getMovements(productId),
    );
  }

  Future<Quantity> getBalance(String productId) async {
    final ledger = await repository.getLedger(productId);

    if (ledger == null) {
      return Quantity.zero();
    }

    return ledger.calculateBalance();
  }

  Future<void> receiveStock({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getOrCreateLedger(productId);

    final service = InventoryService(ledger: ledger).receiveStock(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<void> sellStock({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).sellStock(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<void> adjustStockIncrease({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).adjustStockIncrease(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<void> adjustStockDecrease({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).adjustStockDecrease(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<void> recordDamage({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).recordDamage(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<void> returnStockIn({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).returnStockIn(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<void> returnStockOut({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) async {
    final ledger = await _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).returnStockOut(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    await repository.saveLedger(service.ledger);
    await repository.recordMovement(service.ledger.movements.last);
  }

  Future<StockLedger> _getRequiredLedger(String productId) async {
    final ledger = await repository.getLedger(productId);

    if (ledger == null) {
      throw ArgumentError(
        'Inventory ledger not found for product.',
      );
    }

    return ledger;
  }

  Future<StockLedger> _getOrCreateLedger(String productId) async {
    final ledger = await repository.getLedger(productId);

    return ledger ?? StockLedger(productId: productId);
  }
}
