import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/features/customers/domain/customer.dart';
import 'package:aplikasi_kasir/features/customers/infrastructure/in_memory_customer_repository.dart';

void main() {
  group('Customer Domain & Repository Test', () {
    late InMemoryCustomerRepository repository;

    setUp(() {
      repository = InMemoryCustomerRepository();
    });

    test('Harus memformat nomor HP lokal (08...) ke format WhatsApp internasional (628...)', () {
      final customer = Customer(
        id: 'cust_001',
        name: 'Budi Santoso',
        phoneNumber: '081234567890',
        createdAt: DateTime.now(),
      );

      expect(customer.formattedWhatsAppNumber, equals('6281234567890'));
      expect(
        customer.generateWhatsAppUrl('Halo Budi'),
        equals('https://wa.me/6281234567890?text=Halo%20Budi'),
      );
    });

    test('Harus menyimpan dan menemukan pelanggan berdasarkan nomor telepon', () {
      final customer = Customer(
        id: 'cust_002',
        name: 'Siti Rahma',
        phoneNumber: '085699887766',
        address: 'Jl. Merdeka No. 12',
        createdAt: DateTime.now(),
      );

      repository.save(customer);

      final result = repository.getByPhoneNumber('6285699887766');
      expect(result, isNotNull);
      expect(result!.name, equals('Siti Rahma'));
      expect(result.address, equals('Jl. Merdeka No. 12'));
    });
  });
}
