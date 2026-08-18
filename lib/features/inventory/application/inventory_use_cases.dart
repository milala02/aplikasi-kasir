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

  StockLedger? getLedger(String productId) {
    return repository.getLedger(productId);
  }

  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(repository.getMovements(productId));
  }

  Quantity getBalance(String productId) {
    final ledger = repository.getLedger(productId);

    if (ledger == null) {
      return Quantity.zero();
    }

    return ledger.calculateBalance();
  }

  void receiveStock({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getOrCreateLedger(productId);

    final service = InventoryService(ledger: ledger).receiveStock(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void sellStock({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).sellStock(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void adjustStockIncrease({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).adjustStockIncrease(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void adjustStockDecrease({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).adjustStockDecrease(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void recordDamage({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).recordDamage(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void returnStockIn({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).returnStockIn(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void returnStockOut({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).returnStockOut(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  StockLedger _getRequiredLedger(String productId) {
    final ledger = repository.getLedger(productId);

    if (ledger == null) {
      throw ArgumentError(
        'Inventory ledger not found for product.',
      );
    }

    return ledger;
  }

  StockLedger _getOrCreateLedger(String productId) {
    return repository.getLedger(productId) ??
        StockLedger(productId: productId);
  }
}
