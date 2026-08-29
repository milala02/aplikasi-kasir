import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/customers/domain/customer.dart';
import 'package:aplikasi_kasir/features/sales/application/receipt_service.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('ReceiptService Test', () {
    late ReceiptService service;

    setUp(() {
      service = ReceiptService();
    });

    test('Harus menghasilkan format struk teks WhatsApp yang rapi', () {
      final sale = Sale(
        id: 'sale_101',
        invoiceNumber: 'INV-20260819-001',
        items: [
          SaleItem(
            productId: 'p1',
            productName: 'Bumbu Utama Batch #023',
            unit: Unit.pcs,
            quantity: Quantity(value: 2, scale: 0),
            unitPrice: const Money(minorUnits: 5000000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime(2026, 8, 19, 10, 0),
      );

      final customer = Customer(
        id: 'c1',
        name: 'Budi Santoso',
        phoneNumber: '081234567890',
        createdAt: DateTime.now(),
      );

      final receiptText = service.generateWhatsAppReceipt(sale, customer: customer);

      expect(receiptText, contains('*WARUNG BUMBU & RETAIL*'));
      expect(receiptText, contains('INV-20260819-001'));
      expect(receiptText, contains('Pelanggan: Budi Santoso'));
      expect(receiptText, contains('Bumbu Utama Batch #023'));
      expect(receiptText, contains('*TOTAL: Rp 100000*'));
    });

    test('Total struk mengikuti Sale.total (diskon & pajak diperhitungkan)',
        () {
      final sale = Sale(
        id: 'sale_103',
        invoiceNumber: 'INV-20260819-003',
        items: [
          SaleItem(
            productId: 'p1',
            productName: 'Bumbu Utama Batch #023',
            unit: Unit.pcs,
            quantity: Quantity(value: 2, scale: 0),
            unitPrice: const Money(minorUnits: 5000000, currency: 'IDR'),
          ),
        ],
        discount: const Money(
            minorUnits: 1000000, currency: 'IDR'), // Rp 10.000
        tax: const Money(minorUnits: 100000, currency: 'IDR'), // Rp 1.000
        createdAt: DateTime(2026, 8, 19, 10, 0),
      );

      final receiptText = service.generateWhatsAppReceipt(sale);

      // Subtotal 100.000 - diskon 10.000 + pajak 1.000 = 91.000.
      expect(receiptText, contains('Diskon  : -Rp 10000'));
      expect(receiptText, contains('Pajak   : +Rp 1000'));
      expect(receiptText, contains('*TOTAL: Rp 91000*'));
    });

    test('Harus menghasilkan byte ESC/POS printer thermal', () {
      final sale = Sale(
        id: 'sale_102',
        invoiceNumber: 'INV-20260819-002',
        items: [
          SaleItem(
            productId: 'p2',
            productName: 'Lada Ketengan 5k',
            unit: Unit.pcs,
            quantity: Quantity(value: 4, scale: 0),
            unitPrice: const Money(minorUnits: 500000, currency: 'IDR'),
          ),
        ],
        createdAt: DateTime.now(),
      );

      final bytes = service.generateEscPosBytes(sale);

      expect(bytes, isNotEmpty);
      expect(bytes.first, equals(0x1B)); // ESC byte code
    });
  });
}
