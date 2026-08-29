import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_repository.dart';

void main() {
  group('SaleRepository', () {
    test('defines the sale repository contract', () {
      final repository = _FakeSaleRepository();

      expect(repository, isA<SaleRepository>());
    });

    test('repository exposes sale lookup and storage operations', () async {
      final repository = _FakeSaleRepository();
      final sale = createSale();

      await repository.save(sale);

      expect(repository.getById('sale-001'), equals(sale));
      expect(
        repository.getByInvoiceNumber('INV-001'),
        equals(sale),
      );
      expect(repository.getAll(), contains(sale));
    });

    test('repository can update and delete a sale', () async {
      final repository = _FakeSaleRepository();
      final sale = createSale();

      await repository.save(sale);

      final updated = Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: sale.items,
        discount: const Money(
          minorUnits: 1000,
          currency: 'IDR',
        ),
        tax: sale.tax,
        createdAt: sale.createdAt,
      );

      await repository.update(updated);

      expect(repository.getById('sale-001'), equals(updated));

      await repository.deleteById('sale-001');

      expect(repository.getById('sale-001'), isNull);
    });

    test('returns null for unknown sale', () {
      final repository = _FakeSaleRepository();

      expect(repository.getById('unknown'), isNull);
      expect(repository.getByInvoiceNumber('UNKNOWN'), isNull);
    });
  });
}

Sale createSale() {
  return Sale(
    id: 'sale-001',
    invoiceNumber: 'INV-001',
    items: [
      SaleItem(
        productId: 'product-001',
        productName: 'Beras Premium',
        unit: Unit.kilogram,
        quantity: Quantity(value: 2),
        unitPrice: const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      ),
    ],
    discount: const Money(
      minorUnits: 0,
      currency: 'IDR',
    ),
    tax: const Money(
      minorUnits: 0,
      currency: 'IDR',
    ),
    createdAt: DateTime(2026, 1, 1),
  );
}

class _FakeSaleRepository implements SaleRepository {
  final Map<String, Sale> _sales = {};

  @override
  Sale? getById(String id) => _sales[id];

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) {
    for (final sale in _sales.values) {
      if (sale.invoiceNumber == invoiceNumber) {
        return sale;
      }
    }
    return null;
  }

  @override
  List<Sale> getAll() => List.unmodifiable(_sales.values);

  @override
  Future<void> save(Sale sale) async {
    _sales[sale.id] = sale;
  }

  @override
  Future<void> update(Sale sale) async {
    _sales[sale.id] = sale;
  }

  @override
  Future<void> deleteById(String id) async {
    _sales.remove(id);
  }
}
