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

    test('creates and retrieves a sale', () {
      final sale = createSale();

      useCases.create(sale);

      expect(useCases.getById('sale-001'), equals(sale));
      expect(useCases.getAll(), contains(sale));
    });

    test('adds an item to a sale', () {
      final sale = createSale();
      useCases.create(sale);

      useCases.addItem(
        saleId: 'sale-001',
        item: createSecondItem(),
      );

      final updated = useCases.getById('sale-001');

      expect(updated, isNotNull);
      expect(updated!.items.length, 2);
      expect(updated.items.last.productId, 'product-002');
    });

    test('removes an item from a sale', () {
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

      useCases.create(sale);

      useCases.removeItemAt(
        saleId: 'sale-001',
        index: 1,
      );

      expect(useCases.getById('sale-001')!.items.length, 1);
      expect(
        useCases.getById('sale-001')!.items.first.productId,
        'product-001',
      );
    });

    test('applies discount', () {
      useCases.create(createSale());

      useCases.applyDiscount(
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

    test('applies tax', () {
      useCases.create(createSale());

      useCases.applyTax(
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

    test('deletes an existing sale', () {
      useCases.create(createSale());

      useCases.delete('sale-001');

      expect(useCases.getById('sale-001'), isNull);
    });

    test('rejects empty sale id', () {
      expect(
        () => useCases.getById(''),
        throwsArgumentError,
      );
    });

    test('rejects unknown sale when adding item', () {
      expect(
        () => useCases.addItem(
          saleId: 'unknown',
          item: createItem(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects unknown sale when deleting', () {
      expect(
        () => useCases.delete('unknown'),
        throwsArgumentError,
      );
    });

    test('returns an unmodifiable sale list', () {
      useCases.create(createSale());

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
  void save(String id, Sale sale) {
    _sales[id] = sale;
  }

  @override
  void update(String id, Sale sale) {
    _sales[id] = sale;
  }

  @override
  void deleteById(String id) {
    _sales.remove(id);
  }
}
