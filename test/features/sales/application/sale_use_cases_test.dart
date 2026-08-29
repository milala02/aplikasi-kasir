import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/application/sale_use_cases.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_repository.dart';

void main() {
  group('SaleUseCases', () {
    late _FakeSaleRepository repository;
    late SaleUseCases useCases;

    setUp(() {
      repository = _FakeSaleRepository();
      useCases = SaleUseCases(repository: repository);
    });

    test('creates and retrieves a sale', () async {
      final sale = createSale();

      await useCases.create(sale);

      expect(useCases.getById('sale-001'), equals(sale));
      expect(useCases.getAll(), contains(sale));
    });

    test('adds an item to a sale', () async {
      final sale = createSale();
      await useCases.create(sale);

      await useCases.addItem(
        saleId: 'sale-001',
        item: createSecondItem(),
      );

      final updated = useCases.getById('sale-001');

      expect(updated, isNotNull);
      expect(updated!.items.length, 2);
      expect(updated.items.last.productId, 'product-002');
    });

    test('removes an item from a sale', () async {
      final sale = Sale(
        id: 'sale-001',
        invoiceNumber: 'INV-001',
        items: [
          createItem(),
          createSecondItem(),
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

      await useCases.create(sale);

      await useCases.removeItemAt(
        saleId: 'sale-001',
        index: 1,
      );

      expect(useCases.getById('sale-001')!.items.length, 1);
      expect(
        useCases.getById('sale-001')!.items.first.productId,
        'product-001',
      );
    });

    test('applies discount', () async {
      await useCases.create(createSale());

      await useCases.applyDiscount(
        saleId: 'sale-001',
        discount: const Money(
          minorUnits: 1000,
          currency: 'IDR',
        ),
      );

      expect(
        useCases.getById('sale-001')!.discount,
        const Money(
          minorUnits: 1000,
          currency: 'IDR',
        ),
      );
    });

    test('applies tax', () async {
      await useCases.create(createSale());

      await useCases.applyTax(
        saleId: 'sale-001',
        tax: const Money(
          minorUnits: 500,
          currency: 'IDR',
        ),
      );

      expect(
        useCases.getById('sale-001')!.tax,
        const Money(
          minorUnits: 500,
          currency: 'IDR',
        ),
      );
    });

    test('deletes an existing sale', () async {
      await useCases.create(createSale());

      await useCases.delete('sale-001');

      expect(useCases.getById('sale-001'), isNull);
    });

    test('rejects empty sale id', () {
      expect(
        () => useCases.getById(''),
        throwsArgumentError,
      );
    });

    test('rejects unknown sale when adding item', () async {
      await expectLater(
        useCases.addItem(
          saleId: 'unknown',
          item: createItem(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects unknown sale when deleting', () async {
      await expectLater(
        useCases.delete('unknown'),
        throwsArgumentError,
      );
    });

    test('returns an unmodifiable sale list', () async {
      await useCases.create(createSale());

      final sales = useCases.getAll();

      expect(
        () => sales.add(createSale()),
        throwsUnsupportedError,
      );
    });
  });
}

Sale createSale() {
  return Sale(
    id: 'sale-001',
    invoiceNumber: 'INV-001',
    items: [
      createItem(),
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

SaleItem createItem() {
  return SaleItem(
    productId: 'product-001',
    productName: 'Beras Premium',
    unit: Unit.kilogram,
    quantity: Quantity(value: 2),
    unitPrice: const Money(
      minorUnits: 15000,
      currency: 'IDR',
    ),
  );
}

SaleItem createSecondItem() {
  return SaleItem(
    productId: 'product-002',
    productName: 'Minyak Goreng',
    unit: Unit.liter,
    quantity: Quantity(value: 1),
    unitPrice: const Money(
      minorUnits: 18000,
      currency: 'IDR',
    ),
  );
}

class _FakeSaleRepository implements SaleRepository {
  final Map<String, Sale> _sales = {};

  @override
  Sale? getById(String id) => _sales[id];

  @override
  List<Sale> getAll() => List.unmodifiable(_sales.values);

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
