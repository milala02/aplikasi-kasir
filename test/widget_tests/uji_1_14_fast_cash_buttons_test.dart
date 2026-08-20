import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.14 - Fast Cash Buttons & Exact Amount Validation', () {
    testWidgets('1.14.1 - Mengetuk tombol nominal cepat dan uang pas menghitung kembalian presisi', (WidgetTester tester) async {
      double grandTotal = 35000.0;
      double paidAmount = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                double change = paidAmount >= grandTotal ? paidAmount - grandTotal : 0.0;

                return Column(
                  children: [
                    Text('Total: ${grandTotal.toStringAsFixed(0)}'),
                    Text('Diterima: ${paidAmount.toStringAsFixed(0)}', key: const Key('paid_text')),
                    Text('Kembali: ${change.toStringAsFixed(0)}', key: const Key('change_text')),
                    
                    ElevatedButton(
                      key: const Key('btn_fast_50k'),
                      onPressed: () => setState(() => paidAmount = 50000.0),
                      child: const Text('Rp 50.000'),
                    ),
                    ElevatedButton(
                      key: const Key('btn_exact_cash'),
                      onPressed: () => setState(() => paidAmount = grandTotal),
                      child: const Text('Uang Pas'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verifikasi Awal
      expect(find.text('Diterima: 0'), findsOneWidget);
      expect(find.text('Kembali: 0'), findsOneWidget);

      // Tekan tombol Rp 50.000 (Kembalian harus Rp 15.000)
      await tester.tap(find.byKey(const Key('btn_fast_50k')));
      await tester.pumpAndSettle();

      expect(find.text('Diterima: 50000'), findsOneWidget);
      expect(find.text('Kembali: 15000'), findsOneWidget);

      // Tekan tombol Uang Pas (Kembalian harus Rp 0)
      await tester.tap(find.byKey(const Key('btn_exact_cash')));
      await tester.pumpAndSettle();

      expect(find.text('Diterima: 35000'), findsOneWidget);
      expect(find.text('Kembali: 0'), findsOneWidget);
    });
  });
}
