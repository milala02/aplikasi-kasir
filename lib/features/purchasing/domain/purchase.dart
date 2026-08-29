import '../../../core/money/money.dart';
import 'purchase_item.dart';

class Purchase {
  final String id;
  final DateTime purchasedAt;
  final String? supplierId;
  final String? referenceNumber;
  final List<PurchaseItem> items;

  const Purchase({
    required this.id,
    required this.purchasedAt,
    this.supplierId,
    this.referenceNumber,
    required this.items,
  })  : assert(id != ''),
        assert(items.length > 0);

  Money get totalCost {
    if (items.isEmpty) {
      throw StateError('Purchase must contain at least one item.');
    }

    var total = items.first.totalCost;

    for (var i = 1; i < items.length; i++) {
      total = total.add(items[i].totalCost);
    }

    return total;
  }
}
