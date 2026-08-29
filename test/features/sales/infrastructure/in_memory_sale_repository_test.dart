import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('InMemorySaleRepository', () {
    test('saves and retrieves a sale', () async {
      final repository = InMemorySaleRepository();
      final sale = createSale();

      await repository.save(sale);

      expect(repository.getById(sale.id), equals(sale));
      expect(
        repository.getByInvoiceNumber(sale.invoiceNumber),
        equals(sale),
      );
    });

    test('returns all sales', () async {
      final repository = InMemorySaleRepository();

      await repository.save(createSale());
      await repository.save(
        createSale(
          id: 'sale-002',
          invoiceNumber: 'INV-002',
        ),
      );

      expect(repository.getAll(), hasLength(2));
    });

    test('rejects duplicate sale id', () async {
      final repository = InMemorySaleRepository();
      final sale = createSale();

      await repository.save(sale);

      await expectLater(
        repository.save(sale),
        throwsArgumentError,
      );
    });

    test('rejects duplicate invoice number', () async {
      final repository = InMemorySaleRepository();
      final sale = createSale();
      final duplicateInvoice = createSale(
        id: 'sale-002',
      );

      await repository.save(sale);

      await expectLater(
        repository.save(duplicateInvoice),
        throwsArgumentError,
      );
    });

    test('updates an existing sale', () async {
      final repository = InMemorySaleRepository();
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

      expect(repository.getById(sale.id), equals(updated));
    });

    test('deletes a sale', () async {
      final repository = InMemorySaleRepository();
      final sale = createSale();

      await repository.save(sale);
      await repository.deleteById(sale.id);

      expect(repository.getById(sale.id), isNull);
    });
  });
}

Sale createSale({
  String id = 'sale-001',
  String invoiceNumber = 'INV-001',
}) {
  return Sale(
    id: id,
    invoiceNumber: invoiceNumber,
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
