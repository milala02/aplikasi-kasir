import 'purchase.dart';

abstract interface class PurchaseRepository {
  Purchase? getById(String id);

  Purchase? getByReferenceNumber(String referenceNumber);

  List<Purchase> getAll();

  void save(Purchase purchase);

  void update(Purchase purchase);

  void deleteById(String id);
}
