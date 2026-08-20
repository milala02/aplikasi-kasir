import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.11 - Payment Method Selection & UI Response Validation', () {
    testWidgets('1.11.1 - Perubahan UI saat berpindah dari Cash ke QRIS', (WidgetTester tester) async {
      String selectedMethod = 'Cash';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    DropdownButton<String>(
                      key: const Key('dropdown_payment_method'),
                      value: selectedMethod,
                      items: const [
                        DropdownMenuItem(value: 'Cash', child: Text('Tunai / Cash')),
                        DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
                        DropdownMenuItem(value: 'Transfer', child: Text('Transfer Bank')),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => selectedMethod = val);
                        }
                      },
                    ),
                    if (selectedMethod == 'Cash') ...[
                      const TextField(
                        key: Key('input_cash_amount'),
                        decoration: InputDecoration(labelText: 'Uang Tunai Diterima'),
                      ),
                      const Text('Kembalian: Rp 0', key: Key('cash_change_text')),
                    ],
                    if (selectedMethod == 'QRIS') ...[
                      const Icon(Icons.qr_code_2, key: Key('qris_code_icon')),
                      const Text('Pindai QRIS untuk membayar', key: Key('qris_instruction')),
                    ],
                    if (selectedMethod == 'Transfer') ...[
                      const Text('No. Rekening: 123-456-7890', key: Key('bank_account_info')),
                    ],
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verifikasi awal: Mode Cash aktif, input cash muncul
      expect(find.byKey(const Key('input_cash_amount')), findsOneWidget);
      expect(find.byKey(const Key('qris_code_icon')), findsNothing);

      // Pilih metode QRIS
      await tester.tap(find.byKey(const Key('dropdown_payment_method')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('QRIS').last);
      await tester.pumpAndSettle();

      // Input cash hilang, QRIS instruction muncul
      expect(find.byKey(const Key('input_cash_amount')), findsNothing);
      expect(find.byKey(const Key('qris_code_icon')), findsOneWidget);
      expect(find.text('Pindai QRIS untuk membayar'), findsOneWidget);
    });
  });
}
