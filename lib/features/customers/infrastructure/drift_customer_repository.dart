import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/customer.dart';
import '../domain/customer_repository.dart';

class DriftCustomerRepository implements CustomerRepository {
  final AppDatabase db;
  final Map<String, Customer> _cache = {};

  DriftCustomerRepository(this.db);

  Future<void> init() async {
    final rows = await db.select(db.customersTable).get();
    for (final row in rows) {
      final customer = _toDomain(row);
      _cache[customer.id] = customer;
    }
  }

  @override
  Customer? getById(String id) => _cache[id];

  @override
  Customer? getByPhoneNumber(String phoneNumber) {
    final formatted = _formatPhone(phoneNumber);
    try {
      return _cache.values.firstWhere(
        (c) => c.formattedWhatsAppNumber == formatted,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  List<Customer> getAll() => _cache.values.toList();

  @override
  Future<void> save(Customer customer) async {
    if (_cache.containsKey(customer.id)) {
      throw ArgumentError('Customer ID already exists.');
    }

    await db.into(db.customersTable).insert(
          CustomersTableCompanion.insert(
            id: customer.id,
            name: customer.name,
            phoneNumber: customer.phoneNumber,
            address: Value(customer.address),
            notes: Value(customer.notes),
            createdAt: customer.createdAt,
          ),
          mode: InsertMode.insertOrReplace,
        );

    _cache[customer.id] = customer;
  }

  @override
  Future<void> update(Customer customer) async {
    if (!_cache.containsKey(customer.id)) {
      throw ArgumentError('Customer not found.');
    }

    // Pertahankan flag CDC saat update (sync layer mengelolanya terpisah).
    final existingRow = await (db.select(db.customersTable)
          ..where((t) => t.id.equals(customer.id)))
        .getSingle();

    await db.update(db.customersTable).replace(
          CustomersTableData(
            id: customer.id,
            name: customer.name,
            phoneNumber: customer.phoneNumber,
            address: customer.address,
            notes: customer.notes,
            createdAt: customer.createdAt,
            isSynced: existingRow.isSynced,
            syncedAt: existingRow.syncedAt,
          ),
        );

    _cache[customer.id] = customer;
  }

  @override
  Future<void> deleteById(String id) async {
    await (db.delete(db.customersTable)..where((tbl) => tbl.id.equals(id)))
        .go();

    _cache.remove(id);
  }

  Customer _toDomain(CustomersTableData data) {
    return Customer(
      id: data.id,
      name: data.name,
      phoneNumber: data.phoneNumber,
      address: data.address,
      notes: data.notes,
      createdAt: data.createdAt,
    );
  }

  String _formatPhone(String raw) {
    var cleaned = raw.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('0')) return '62${cleaned.substring(1)}';
    if (cleaned.startsWith('+')) return cleaned.substring(1);
    return cleaned;
  }
}
