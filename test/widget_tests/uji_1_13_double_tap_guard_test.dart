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
                    Text('Status: ${isProcessing ? "Processing" : "Idle"}'),
                    Text('Count: $transactionProcessCount', key: const Key('process_count')),
                    ElevatedButton(
                      key: const Key('btn_submit_transaction'),
                      onPressed: isProcessing
                          ? null // Tombol disable saat sedang memproses
                          : () {
                              setState(() {
                                isProcessing = true;
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

      // Verifikasi awal
      expect(find.text('Count: 0'), findsOneWidget);

      // Tekan tombol pertama kali
      await tester.tap(find.byKey(const Key('btn_submit_transaction')));
      
      // Tekan lagi dengan cepat sebelum frame selesai dirender (simulasi double-tap)
      await tester.tap(find.byKey(const Key('btn_submit_transaction')), warnIfMissed: false);
      await tester.pumpAndSettle();

      // Jumlah transaksi harus tetap 1, tidak boleh 2
      expect(find.text('Count: 1'), findsOneWidget);
    });
  });
}
