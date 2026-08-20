import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.6 - Checkout & Payment Validation', () {
    testWidgets('1.6.1 - Validasi pembayaran kurang dan perhitungan kembalian', (WidgetTester tester) async {
      double totalBelanja = 50000.0;
      double uangBayar = 0.0;
      double kembalian = 0.0;
      String errorMessage = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Total: $totalBelanja', key: const Key('total_text')),
                    TextField(
                      key: const Key('input_bayar'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          uangBayar = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                    ElevatedButton(
                      key: const Key('btn_proses_bayar'),
                      onPressed: () {
                        setState(() {
                          if (uangBayar < totalBelanja) {
                            errorMessage = 'Uang pembayaran kurang';
                            kembalian = 0.0;
                          } else {
                            errorMessage = '';
                            kembalian = uangBayar - totalBelanja;
                          }
                        });
                      },
                      child: const Text('Bayar'),
                    ),
                    if (errorMessage.isNotEmpty)
                      Text(errorMessage, key: const Key('error_text')),
                    Text('Kembalian: $kembalian', key: const Key('kembalian_text')),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Skenario A: Uang Kurang (Bayar 30000)
      await tester.enterText(find.byKey(const Key('input_bayar')), '30000');
      await tester.tap(find.byKey(const Key('btn_proses_bayar')));
      await tester.pumpAndSettle();

      expect(find.text('Uang pembayaran kurang'), findsOneWidget);
      expect(find.text('Kembalian: 0.0'), findsOneWidget);

      // Skenario B: Uang Pas/Cukup (Bayar 100000)
      await tester.enterText(find.byKey(const Key('input_bayar')), '100000');
      await tester.tap(find.byKey(const Key('btn_proses_bayar')));
      await tester.pumpAndSettle();

      expect(find.text('Uang pembayaran kurang'), findsNothing);
      expect(find.text('Kembalian: 50000.0'), findsOneWidget);
    });

    testWidgets('1.6.2 - Reset keranjang setelah transaksi berhasil', (WidgetTester tester) async {
      List<String> cartItems = ['Kopi Susu', 'Roti Bakar'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Jumlah Item: ${cartItems.length}', key: const Key('item_count')),
                    ElevatedButton(
                      key: const Key('btn_finish_order'),
                      onPressed: () {
                        setState(() {
                          cartItems.clear();
                        });
                      },
                      child: const Text('Selesaikan Transaksi'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Jumlah Item: 2'), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn_finish_order')));
      await tester.pumpAndSettle();

      expect(find.text('Jumlah Item: 0'), findsOneWidget);
    });
  });
}
