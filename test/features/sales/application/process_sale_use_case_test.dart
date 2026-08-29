import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/result/result.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/application/process_sale_use_case.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_repository.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('ProcessSaleUseCase - pencatatan sale (tanpa konsumsi stok)', () {
    late InMemorySaleRepository saleRepo;
    late ProcessSaleUseCase useCase;

    setUp(() {
      saleRepo = InMemorySaleRepository();
      useCase = ProcessSaleUseCase(saleRepository: saleRepo);
    });

    Sale buildSale({String id = 'sale_test_001', String invoice = 'INV-TEST-001'}) {
      return Sale(
        id: id,
        invoiceNumber: invoice,
        items: [
          SaleItem(
            productId: 'beras',
            productName: 'Beras',
            unit: Unit.kilogram,
            quantity: Quantity(value: 1, scale: 0),
            unitPrice: const Money(minorUnits: 1500000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime.now(),
      );
    }

    test('menyimpan sale tanpa menyentuh stok', () async {
      final result = await useCase.execute(buildSale());

      expect(result, isA<Success<Sale>>());
      expect(saleRepo.getById('sale_test_001'), isNotNull);
    });

    test('invoice duplikat -> Failure DUPLICATE_INVOICE', () async {
      await saleRepo.save(buildSale());

      final result =
          await useCase.execute(buildSale(id: 'sale_test_002'));

      expect(result, isA<Failure>());
      expect(
          (result as Failure).error.toString(), contains('DUPLICATE_INVOICE'));
      expect(saleRepo.getAll(), hasLength(1));
    });

    test('persistence failure -> Failure PROCESS_SALE_ERROR', () async {
      final failingUseCase =
          ProcessSaleUseCase(saleRepository: _ThrowingSaveSaleRepository());

      final result = await failingUseCase.execute(buildSale());

      expect(result, isA<Failure>());
      expect(
          (result as Failure).error.toString(), contains('PROCESS_SALE_ERROR'));
    });
  });
}

class _ThrowingSaveSaleRepository implements SaleRepository {
  @override
  Sale? getById(String id) => null;

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) => null;

  @override
  List<Sale> getAll() => const [];

  @override
  Future<void> save(Sale sale) async {
    throw StateError('DB failure simulated.');
  }

  @override
  Future<void> update(Sale sale) async {}

  @override
  Future<void> deleteById(String id) async {}
}
