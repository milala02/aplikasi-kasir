import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_service.dart';

void main() {
  group('SaleService', () {
    final createdAt = DateTime(2026, 8, 18, 10, 0);

    SaleItem item({
      String productId = 'product-001',
      int quantity = 2,
      int price = 10000,
    }) {
      return SaleItem(
        productId: productId,
        productName: 'Product',
        unit: Unit.piece,
        quantity: Quantity(value: quantity),
        unitPrice: Money(
          minorUnits: price,
          currency: 'IDR',
        ),
      );
    }

    Sale createSale() {
      return Sale(
        id: 'sale-001',
        invoiceNumber: 'INV-001',
        items: [
          item(),
        ],
        discount: Money(
          minorUnits: 0,
          currency: 'IDR',
        ),
        tax: Money(
          minorUnits: 0,
          currency: 'IDR',
        ),
        createdAt: createdAt,
      );
    }

    test('exposes sale subtotal and total', () {
      final service = SaleService(
        sale: createSale(),
      );

      expect(
        service.subtotal,
        Money(
          minorUnits: 20000,
          currency: 'IDR',
        ),
      );

      expect(
        service.total,
        Money(
          minorUnits: 20000,
          currency: 'IDR',
        ),
      );
    });

    test('adds item without mutating original sale', () {
      final service = SaleService(
        sale: createSale(),
      );

      final updated = service.addItem(
        item(
          productId: 'product-002',
          quantity: 3,
        ),
      );

      expect(service.sale.items, hasLength(1));
      expect(updated.sale.items, hasLength(2));
      expect(
        updated.subtotal,
        Money(
          minorUnits: 50000,
          currency: 'IDR',
        ),
      );
    });

    test('removes item without mutating original sale', () {
      final service = SaleService(
        sale: Sale(
          id: 'sale-001',
          invoiceNumber: 'INV-001',
          items: [
            item(),
            item(productId: 'product-002'),
          ],
          discount: Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          tax: Money(
            minorUnits: 0,
            currency: 'IDR',
          ),
          createdAt: createdAt,
        ),
      );

      final updated = service.removeItemAt(0);

      expect(service.sale.items, hasLength(2));
      expect(updated.sale.items, hasLength(1));
      expect(
        updated.sale.items.single.productId,
        'product-002',
      );
    });

    test('rejects invalid item index', () {
      final service = SaleService(
        sale: createSale(),
      );

      expect(
        () => service.removeItemAt(1),
        throwsRangeError,
      );
    });

    test('applies discount immutably', () {
      final service = SaleService(
        sale: createSale(),
      );

      final updated = service.withDiscount(
        Money(
          minorUnits: 5000,
          currency: 'IDR',
        ),
      );

      expect(
        service.sale.discount,
        Money(
          minorUnits: 0,
          currency: 'IDR',
        ),
      );

      expect(
        updated.sale.discount,
        Money(
          minorUnits: 5000,
          currency: 'IDR',
        ),
      );

      expect(
        updated.total,
        Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );
    });

    test('applies tax immutably', () {
      final service = SaleService(
        sale: createSale(),
      );

      final updated = service.withTax(
        Money(
          minorUnits: 2000,
          currency: 'IDR',
        ),
      );

      expect(
        service.sale.tax,
        Money(
          minorUnits: 0,
          currency: 'IDR',
        ),
      );

      expect(
        updated.sale.tax,
        Money(
          minorUnits: 2000,
          currency: 'IDR',
        ),
      );

      expect(
        updated.total,
        Money(
          minorUnits: 22000,
          currency: 'IDR',
        ),
      );
    });
  });
}
