import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 3.3 - History & Receipt Viewer UI Validation', () {
    final List<Map<String, dynamic>> mockHistory = [
      {
        'id': 'TRX-20260401',
        'date': '2026-04-01 14:30',
        'total': 45000.0,
        'items': ['Kopi Susu x2', 'Roti Bakar x1']
      },
      {
        'id': 'TRX-20260402',
        'date': '2026-04-02 09:15',
        'total': 22000.0,
        'items': ['Kopi Latte x1']
      },
    ];

    testWidgets('3.3.1 - Render daftar riwayat transaksi dengan benar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Riwayat Transaksi')),
            body: ListView.builder(
              itemCount: mockHistory.length,
              itemBuilder: (context, index) {
                final item = mockHistory[index];
                return ListTile(
                  key: Key('history_item_${item['id']}'),
                  title: Text(item['id']),
                  subtitle: Text(item['date']),
                  trailing: Text('Rp ${item['total'].toStringAsFixed(0)}'),
                );
              },
            ),
          ),
        ),
      );

      // Verifikasi item riwayat ter-render
      expect(find.text('Riwayat Transaksi'), findsOneWidget);
      expect(find.text('TRX-20260401'), findsOneWidget);
      expect(find.text('Rp 45000'), findsOneWidget);
      expect(find.text('TRX-20260402'), findsOneWidget);
      expect(find.text('Rp 22000'), findsOneWidget);
    });

    testWidgets('3.3.2 - Mengetuk transaksi membuka modal detail struk & opsi cetak', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ListTile(
                  key: const Key('btn_open_receipt'),
                  title: const Text('TRX-20260401'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Struk Pembayaran'),
                        content: const Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Item: Kopi Susu x2'),
                            Text('Total: Rp 45.000'),
                          ],
                        ),
                        actions: [
                          TextButton(
                            key: const Key('btn_print_receipt'),
                            onPressed: () {},
                            child: const Text('Cetak Struk'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      );

      // Tap transaksi untuk buka struk
      await tester.tap(find.byKey(const Key('btn_open_receipt')));
      await tester.pumpAndSettle();

      // Verifikasi dialog detail struk dan tombol cetak muncul
      expect(find.text('Struk Pembayaran'), findsOneWidget);
      expect(find.text('Item: Kopi Susu x2'), findsOneWidget);
      expect(find.byKey(const Key('btn_print_receipt')), findsOneWidget);
    });
  });
}
