import 'customer.dart';

abstract interface class CustomerRepository {
  Customer? getById(String id);
  Customer? getByPhoneNumber(String phoneNumber);
  List<Customer> getAll();
  Future<void> save(Customer customer);
  Future<void> update(Customer customer);
  Future<void> deleteById(String id);
}
