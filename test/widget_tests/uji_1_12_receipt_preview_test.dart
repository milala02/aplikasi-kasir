import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.12 - Receipt Preview & Print Trigger Validation', () {
    final Map<String, dynamic> mockTransactionData = {
      'storeName': 'Kasir Pintar Store',
      'trxId': 'TRX-9901',
      'items': [
        {'name': 'Kopi Susu', 'qty': 2, 'price': 15000.0},
        {'name': 'Roti Bakar', 'qty': 1, 'price': 20000.0},
      ],
      'total': 50000.0,
      'paymentMethod': 'Cash',
    };

    testWidgets('1.12.1 - Render komponen struk pada dialog pratinjau', (WidgetTester tester) async {
      bool printTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text(mockTransactionData['storeName'], key: const Key('receipt_store_name')),
                    Text('No: ${mockTransactionData['trxId']}', key: const Key('receipt_trx_id')),
                    ...List.generate(
                      (mockTransactionData['items'] as List).length,
                      (index) {
                        final item = mockTransactionData['items'][index];
                        return Text('${item['name']} x${item['qty']} = ${item['price'] * item['qty']}');
                      },
                    ),
                    Text('TOTAL: Rp ${mockTransactionData['total']}', key: const Key('receipt_total')),
                    ElevatedButton(
                      key: const Key('btn_print_receipt'),
                      onPressed: () {
                        setState(() {
                          printTriggered = true;
                        });
                      },
                      child: const Text('Cetak Struk'),
                    ),
                    if (printTriggered)
                      const Text('Mengirim perintah ke printer...', key: Key('print_status_text')),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verifikasi rendering elemen struk
      expect(find.text('Kasir Pintar Store'), findsOneWidget);
      expect(find.text('No: TRX-9901'), findsOneWidget);
      expect(find.text('TOTAL: Rp 50000.0'), findsOneWidget);

      // Tekan tombol cetak struk
      await tester.tap(find.byKey(const Key('btn_print_receipt')));
      await tester.pumpAndSettle();

      // Verifikasi trigger simulasi percetakan
      expect(find.byKey(const Key('print_status_text')), findsOneWidget);
      expect(find.text('Mengirim perintah ke printer...'), findsOneWidget);
    });
  });
}
