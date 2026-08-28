import '../domain/receiving.dart';
import '../domain/receiving_repository.dart';

class InMemoryReceivingRepository implements ReceivingRepository {
  final Map<String, Receiving> _receivings = {};

  @override
  Receiving? getById(String id) {
    return _receivings[id];
  }

  @override
  List<Receiving> getAll() => _receivings.values.toList();

  @override
  List<Receiving> getByPurchaseId(String purchaseId) {
    return _receivings.values
        .where((receiving) => receiving.purchaseId == purchaseId)
        .toList();
  }

  @override
  void save(Receiving receiving) {
    _receivings[receiving.id] = receiving;
  }

  void clear() {
    _receivings.clear();
  }
}
