import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.9 - Discount & Tax Calculation Validation', () {
    testWidgets('1.9.1 - Perhitungan Diskon Persen dan PPN 11%', (WidgetTester tester) async {
      double subtotal = 100000.0;
      double discountPercent = 0.0;
      bool applyTax = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                double discountAmount = subtotal * (discountPercent / 100);
                double afterDiscount = subtotal - discountAmount;
                double taxAmount = applyTax ? (afterDiscount * 0.11) : 0.0;
                double grandTotal = afterDiscount + taxAmount;

                return Column(
                  children: [
                    Text('Subtotal: ${subtotal.toStringAsFixed(0)}', key: const Key('subtotal_text')),
                    Text('Grand Total: ${grandTotal.toStringAsFixed(0)}', key: const Key('grand_total_text')),
                    
                    // Tombol Diskon 10%
                    ElevatedButton(
                      key: const Key('btn_discount_10'),
                      onPressed: () => setState(() => discountPercent = 10.0),
                      child: const Text('Diskon 10%'),
                    ),
                    
                    // Switch PPN 11%
                    Switch(
                      key: const Key('switch_tax'),
                      value: applyTax,
                      onChanged: (val) => setState(() => applyTax = val),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Status Awal (Subtotal 100.000, Diskon 0%, PPN Off -> Grand Total 100.000)
      expect(find.text('Grand Total: 100000'), findsOneWidget);

      // Tekan Diskon 10% (100.000 - 10.000 = 90.000)
      await tester.tap(find.byKey(const Key('btn_discount_10')));
      await tester.pumpAndSettle();
      expect(find.text('Grand Total: 90000'), findsOneWidget);

      // Aktifkan PPN 11% (90.000 + 11% [9.900] = 99.900)
      await tester.tap(find.byKey(const Key('switch_tax')));
      await tester.pumpAndSettle();
      expect(find.text('Grand Total: 99900'), findsOneWidget);
    });

    testWidgets('1.9.2 - Diskon nominal khusus (Custom Discount)', (WidgetTester tester) async {
      double subtotal = 50000.0;
      double customDiscount = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                double grandTotal = subtotal - customDiscount;
                if (grandTotal < 0) grandTotal = 0;

                return Column(
                  children: [
                    Text('Grand Total: ${grandTotal.toStringAsFixed(0)}', key: const Key('grand_total_text')),
                    TextField(
                      key: const Key('input_custom_discount'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          customDiscount = double.tryParse(val) ?? 0.0;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Masukkan Diskon Nominal Rp 5.000
      await tester.enterText(find.byKey(const Key('input_custom_discount')), '5000');
      await tester.pumpAndSettle();

      expect(find.text('Grand Total: 45000'), findsOneWidget);
    });
  });
}
