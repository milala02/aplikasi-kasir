import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.7 - Transaction History & Search Validation', () {
    final List<Map<String, dynamic>> dummyTransactions = [
      {'id': 'TRX-1001', 'total': 25000.0, 'date': '2026-08-20'},
      {'id': 'TRX-1002', 'total': 45000.0, 'date': '2026-08-20'},
      {'id': 'TRX-1003', 'total': 12000.0, 'date': '2026-08-20'},
    ];

    testWidgets('1.7.1 - Menampilkan seluruh daftar riwayat transaksi', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: dummyTransactions.length,
              itemBuilder: (context, index) {
                final item = dummyTransactions[index];
                return ListTile(
                  title: Text(item['id']),
                  subtitle: Text('Total: ${item['total']}'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('TRX-1001'), findsOneWidget);
      expect(find.text('TRX-1002'), findsOneWidget);
      expect(find.text('TRX-1003'), findsOneWidget);
    });

    testWidgets('1.7.2 - Filter pencarian berdasarkan nomor nota', (WidgetTester tester) async {
      String searchQuery = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                final filteredList = dummyTransactions.where((trx) {
                  return trx['id'].toString().toLowerCase().contains(searchQuery.toLowerCase());
                }).toList();

                return Column(
                  children: [
                    TextField(
                      key: const Key('input_search_trx'),
                      onChanged: (val) {
                        setState(() {
                          searchQuery = val;
                        });
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return ListTile(
                            title: Text(item['id']),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Pastikan awalnya muncul semua 3 transaksi
      expect(find.text('TRX-1001'), findsOneWidget);
      expect(find.text('TRX-1002'), findsOneWidget);
      expect(find.text('TRX-1003'), findsOneWidget);

      // Cari "1002"
      await tester.enterText(find.byKey(const Key('input_search_trx')), '1002');
      await tester.pumpAndSettle();

      // Hasil filter hanya TRX-1002
      expect(find.text('TRX-1001'), findsNothing);
      expect(find.text('TRX-1002'), findsOneWidget);
      expect(find.text('TRX-1003'), findsNothing);
    });
  });
}
