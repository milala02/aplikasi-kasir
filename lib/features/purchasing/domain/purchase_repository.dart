import 'purchase.dart';

abstract interface class PurchaseRepository {
  Future<Purchase?> getById(String id);

  Future<Purchase?> getByReferenceNumber(String referenceNumber);

  Future<List<Purchase>> getAll();

  Future<void> save(Purchase purchase);

  Future<void> update(Purchase purchase);

  Future<void> deleteById(String id);
}
