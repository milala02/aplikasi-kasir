import '../domain/purchase.dart';
import '../domain/purchase_repository.dart';

class InMemoryPurchaseRepository implements PurchaseRepository {
  final Map<String, Purchase> _purchases = {};

  @override
  Future<Purchase?> getById(String id) async {
    return _purchases[id];
  }

  @override
  Future<Purchase?> getByReferenceNumber(String referenceNumber) async {
    for (final purchase in _purchases.values) {
      if (purchase.referenceNumber == referenceNumber) {
        return purchase;
      }
    }

    return null;
  }

  @override
  Future<List<Purchase>> getAll() async {
    return _purchases.values.toList();
  }

  @override
  Future<void> save(Purchase purchase) async {
    if (_purchases.containsKey(purchase.id)) {
      throw StateError(
        'Purchase with id "${purchase.id}" already exists.',
      );
    }

    _purchases[purchase.id] = purchase;
  }

  @override
  Future<void> update(Purchase purchase) async {
    if (!_purchases.containsKey(purchase.id)) {
      throw StateError(
        'Purchase with id "${purchase.id}" does not exist.',
      );
    }

    _purchases[purchase.id] = purchase;
  }

  @override
  Future<void> deleteById(String id) async {
    if (!_purchases.containsKey(id)) {
      throw StateError(
        'Purchase with id "$id" does not exist.',
      );
    }

    _purchases.remove(id);
  }
}
