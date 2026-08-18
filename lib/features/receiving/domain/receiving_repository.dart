import 'receiving.dart';

abstract interface class ReceivingRepository {
  Receiving? getById(String id);
  List<Receiving> getByPurchaseId(String purchaseId);
  void save(Receiving receiving);
}
