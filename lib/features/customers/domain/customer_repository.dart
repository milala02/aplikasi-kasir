import 'customer.dart';

abstract interface class CustomerRepository {
  Customer? getById(String id);
  Customer? getByPhoneNumber(String phoneNumber);
  List<Customer> getAll();
  void save(Customer customer);
  void update(Customer customer);
  void deleteById(String id);
}
