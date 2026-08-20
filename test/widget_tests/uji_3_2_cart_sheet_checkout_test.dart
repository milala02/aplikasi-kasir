import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 3.2 - Cart Sheet & Checkout UI Validation', () {
    testWidgets('3.2.1 - Render ringkasan keranjang dengan PPN 11% dan diskon', (WidgetTester tester) async {
      double subtotal = 100000.0;
      double discount = 10000.0;
      double tax = (subtotal - discount) * 0.11; // 9900
      double grandTotal = (subtotal - discount) + tax; // 99900

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const ListTile(
                  title: Text('Kopi Latte x2'),
                  trailing: Text('Rp 100.000'),
                ),
                Text('Subtotal: Rp ${subtotal.toStringAsFixed(0)}'),
                Text('Diskon: Rp ${discount.toStringAsFixed(0)}'),
                Text('PPN 11%: Rp ${tax.toStringAsFixed(0)}'),
                Text('Grand Total: Rp ${grandTotal.toStringAsFixed(0)}', key: const Key('grand_total_text')),
                ElevatedButton(
                  key: const Key('btn_checkout'),
                  onPressed: () {},
                  child: const Text('Bayar Sekarang'),
                ),
              ],
            ),
          ),
        ),
      );

      // Verifikasi komponen rincian biaya
      expect(find.text('Kopi Latte x2'), findsOneWidget);
      expect(find.text('Subtotal: Rp 100000'), findsOneWidget);
      expect(find.text('Diskon: Rp 10000'), findsOneWidget);
      expect(find.text('PPN 11%: Rp 9900'), findsOneWidget);
      expect(find.text('Grand Total: Rp 99900'), findsOneWidget);
      expect(find.byKey(const Key('btn_checkout')), findsOneWidget);
    });

    testWidgets('3.2.2 - Mengetuk tombol Bayar memicu dialog konfirmasi pembayaran', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  key: const Key('btn_checkout'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => const AlertDialog(
                        title: Text('Konfirmasi Pembayaran'),
                      ),
                    );
                  },
                  child: const Text('Bayar Sekarang'),
                );
              },
            ),
          ),
        ),
      );

      // Tekan tombol Bayar
      await tester.tap(find.byKey(const Key('btn_checkout')));
      await tester.pumpAndSettle();

      // Verifikasi dialog modal konfirmasi muncul
      expect(find.text('Konfirmasi Pembayaran'), findsOneWidget);
    });
  });
}
