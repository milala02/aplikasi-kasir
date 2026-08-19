import '../domain/customer.dart';
import '../domain/customer_repository.dart';

class InMemoryCustomerRepository implements CustomerRepository {
  final Map<String, Customer> _customers = {};

  @override
  Customer? getById(String id) => _customers[id];

  @override
  Customer? getByPhoneNumber(String phoneNumber) {
    try {
      return _customers.values.firstWhere(
        (c) => c.formattedWhatsAppNumber == _formatPhone(phoneNumber),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  List<Customer> getAll() => _customers.values.toList();

  @override
  void save(Customer customer) {
    if (_customers.containsKey(customer.id)) {
      throw ArgumentError('Customer ID already exists.');
    }
    _customers[customer.id] = customer;
  }

  @override
  void update(Customer customer) {
    if (!_customers.containsKey(customer.id)) {
      throw ArgumentError('Customer not found.');
    }
    _customers[customer.id] = customer;
  }

  @override
  void deleteById(String id) {
    _customers.remove(id);
  }

  String _formatPhone(String raw) {
    var cleaned = raw.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('0')) return '62${cleaned.substring(1)}';
    if (cleaned.startsWith('+')) return cleaned.substring(1);
    return cleaned;
  }
}
