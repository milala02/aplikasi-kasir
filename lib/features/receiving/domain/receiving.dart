import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class ReceivingItem {
  final String id;
  final String productId;
  final Quantity quantityReceived;
  final Money unitCost;

  ReceivingItem({
    required this.id,
    required this.productId,
    required this.quantityReceived,
    required this.unitCost,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('ReceivingItem ID cannot be empty.');
    }
    if (productId.isEmpty) {
      throw ArgumentError('ReceivingItem product ID cannot be empty.');
    }
    if (quantityReceived.isZero) {
      throw ArgumentError('Quantity received cannot be zero.');
    }
  }
}

class Receiving {
  final String id;
  final String purchaseId;
  final List<ReceivingItem> items;
  final DateTime receivedAt;

  Receiving({
    required this.id,
    required this.purchaseId,
    required this.items,
    required this.receivedAt,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('Receiving ID cannot be empty.');
    }
    if (purchaseId.isEmpty) {
      throw ArgumentError('Purchase ID cannot be empty.');
    }
    if (items.isEmpty) {
      throw ArgumentError('Receiving items cannot be empty.');
    }
  }
}
