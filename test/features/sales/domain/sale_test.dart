import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('Sale', () {
    const createdAt = DateTime(2026, 8, 18, 12, 0);

    SaleItem item({
      required String id,
      required int price,
      int quantity = 1,
    }) {
      return SaleItem(
        productId: id,
        productName: 'Product $id',
        unit: Unit.pcs,
        quantity: Quantity(value: quantity),
        unitPrice: Money(
          minorUnits: price,
          currency: 'IDR',
        ),
      );
    }

    Sale createSale({
      List<SaleItem>? items,
      Money discount = const Money(
        minorUnits: 0,
        currency: 'IDR',
      ),
      Money tax = const Money(
        minorUnits: 0,
        currency: 'IDR',
      ),
    }) {
      return Sale(
        id: 'sale-001',
        invoiceNumber: 'INV-001',
        items: items ?? [item(id: 'product-001', price: 10000)],
        discount: discount,
        tax: tax,
        createdAt: createdAt,
      );
    }

    test('calculates subtotal from all items', () {
      final sale = createSale(
        items: [
          item(id: 'product-001', price: 10000, quantity: 2),
          item(id: 'product-002', price: 5000, quantity: 3),
        ],
      );

      expect(
        sale.subtotal,
        const Money(
          minorUnits: 35000,
          currency: 'IDR',
        ),
      );
    });

    test('calculates total with discount and tax', () {
      final sale = createSale(
        items: [
          item(id: 'product-001', price: 50000, quantity: 2),
        ],
        discount: const Money(
          minorUnits: 10000,
          currency: 'IDR',
        ),
        tax: const Money(
          minorUnits: 4000,
          currency: 'IDR',
        ),
      );

      expect(
        sale.subtotal,
        const Money(
          minorUnits: 100000,
          currency: 'IDR',
        ),
      );

      expect(
        sale.total,
        const Money(
          minorUnits: 94000,
          currency: 'IDR',
        ),
      );
    });

    test('rejects empty sale id', () {
      expect(
        () => Sale(
          id: '',
          invoiceNumber: 'INV-001',
          items: [item(id: 'product-001', price: 10000)],
          discount: const Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          tax: const Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          createdAt: createdAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects empty invoice number', () {
      expect(
        () => Sale(
          id: 'sale-001',
          invoiceNumber: '',
          items: [item(id: 'product-001', price: 10000)],
          discount: const Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          tax: const Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          createdAt: createdAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects sale without items', () {
      expect(
        () => Sale(
          id: 'sale-001',
          invoiceNumber: 'INV-001',
          items: const [],
          discount: const Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          tax: const Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          createdAt: createdAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects negative discount', () {
      expect(
        () => createSale(
          discount: const Money(
            minorUnits: -1,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects negative tax', () {
      expect(
        () => createSale(
          tax: const Money(
            minorUnits: -1,
            currency: 'IDR',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects discount greater than subtotal', () {
      final sale = createSale(
        discount: const Money(
          minorUnits: 20000,
          currency: 'IDR',
        ),
      );

      expect(
        () => sale.total,
        throwsArgumentError,
      );
    });

    test('rejects currency mismatch between items', () {
      expect(
        () => Sale(
          id: 'sale-001',
          invoiceNumber: 'INV-001',
          items: [
            item(id: 'product-001', price: 10000),
            SaleItem(
              productId: 'product-002',
              productName: 'USD Product',
              unit: Unit.pcs,
              quantity: Quantity(value: 1),
              unitPrice: const Money(
                minorUnits: 10,
                currency: 'USD',
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
          createdAt: createdAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects discount currency mismatch', () {
      expect(
        () => createSale(
          discount: const Money(
            minorUnits: 1000,
            currency: 'USD',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects tax currency mismatch', () {
      expect(
        () => createSale(
          tax: const Money(
            minorUnits: 1000,
            currency: 'USD',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('sales with identical values are equal', () {
      final first = createSale(
        items: [item(id: 'product-001', price: 10000)],
      );

      final second = createSale(
        items: [item(id: 'product-001', price: 10000)],
      );

      expect(first, equals(second));
    });
  });
}
