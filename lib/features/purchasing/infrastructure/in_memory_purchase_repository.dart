import '../domain/purchase.dart';
import '../domain/purchase_repository.dart';

class InMemoryPurchaseRepository implements PurchaseRepository {
  final Map<String, Purchase> _purchases = {};

  @override
  Purchase? getById(String id) {
    return _purchases[id];
  }

  @override
  Purchase? getByReferenceNumber(String referenceNumber) {
    for (final purchase in _purchases.values) {
      if (purchase.referenceNumber == referenceNumber) {
        return purchase;
      }
    }

    return null;
  }

  @override
  List<Purchase> getAll() {
    return _purchases.values.toList();
  }

  @override
  void save(Purchase purchase) {
    if (_purchases.containsKey(purchase.id)) {
      throw StateError(
        'Purchase with id "${purchase.id}" already exists.',
      );
    }

    _purchases[purchase.id] = purchase;
  }

  @override
  void update(Purchase purchase) {
    if (!_purchases.containsKey(purchase.id)) {
      throw StateError(
        'Purchase with id "${purchase.id}" does not exist.',
      );
    }

    _purchases[purchase.id] = purchase;
  }

  @override
  void deleteById(String id) {
    if (!_purchases.containsKey(id)) {
      throw StateError(
        'Purchase with id "$id" does not exist.',
      );
    }

    _purchases.remove(id);
  }
}
