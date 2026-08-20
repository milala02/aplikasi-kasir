import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.13 - Anti-Spam & Double-Tap Guard Validation', () {
    testWidgets('1.13.1 - Mencegah pemrosesan ganda saat tombol bayar ditekan cepat', (WidgetTester tester) async {
      int transactionProcessCount = 0;
      bool isProcessing = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Count: $transactionProcessCount', key: const Key('process_count')),
                    ElevatedButton(
                      key: const Key('btn_submit_transaction'),
                      onPressed: () {
                        // Synchronous guard check: menolak eksekusi jika flag sudah true
                        if (isProcessing) return;
                        isProcessing = true;
                        
                        setState(() {
                          transactionProcessCount++;
                        });
                      },
                      child: const Text('Bayar Sekarang'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Count: 0'), findsOneWidget);

      // Tap pertama
      await tester.tap(find.byKey(const Key('btn_submit_transaction')));
      // Tap kedua berurutan secara instan (sebelum render frame baru)
      await tester.tap(find.byKey(const Key('btn_submit_transaction')), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Jumlah transaksi dipastikan tetap 1
      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}
