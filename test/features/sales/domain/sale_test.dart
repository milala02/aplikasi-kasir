import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('Sale Domain Model', () {
    test('harus menghitung subtotal item dan total transaksi penjualan dengan benar', () {
      final item1 = SaleItem(
        productId: 'prod_1',
        productName: 'Produk A',
        unit: Unit.pcs,
        quantity: Quantity(value: 2, scale: 0),
        unitPrice: Money(minorUnits: 1500000, currency: 'IDR'), // Rp 15.000 x 2 = Rp 30.000
      );

      final item2 = SaleItem(
        productId: 'prod_2',
        productName: 'Produk B',
        unit: Unit.pcs,
        quantity: Quantity(value: 1, scale: 0),
        unitPrice: Money(minorUnits: 5000000, currency: 'IDR'), // Rp 50.000 x 1 = Rp 50.000
      );

      final sale = Sale(
        id: 'sale_001',
        invoiceNumber: 'INV-20260819-001',
        items: [item1, item2],
        createdAt: DateTime.now(),
      );

      expect(item1.subtotal.minorUnits, equals(3000000));
      expect(item2.subtotal.minorUnits, equals(5000000));
      expect(sale.total.minorUnits, equals(8000000)); // Total Rp 80.000
    });
  });
}
