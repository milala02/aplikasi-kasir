import 'receiving.dart';

abstract interface class ReceivingRepository {
  Future<Receiving?> getById(String id);
  Future<List<Receiving>> getAll();
  Future<List<Receiving>> getByPurchaseId(String purchaseId);
  Future<void> save(Receiving receiving);
}
