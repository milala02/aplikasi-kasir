import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.10 - Clear Cart Confirmation Dialog Validation', () {
    testWidgets('1.10.1 - Batal menghapus keranjang saat konfirmasi ditolak', (WidgetTester tester) async {
      List<String> cartItems = ['Kopi Susu', 'Roti Bakar'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Total Item: ${cartItems.length}', key: const Key('cart_count')),
                    ElevatedButton(
                      key: const Key('btn_clear_cart'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text('Yakin ingin mengosongkan keranjang?'),
                            actions: [
                              TextButton(
                                key: const Key('btn_dialog_cancel'),
                                onPressed: () => Navigator.of(ctx).pop(),
                                child: const Text('Batal'),
                              ),
                              TextButton(
                                key: const Key('btn_dialog_confirm'),
                                onPressed: () {
                                  setState(() {
                                    cartItems.clear();
                                  });
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Kosongkan Keranjang'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Verifikasi awal: 2 item di keranjang
      expect(find.text('Total Item: 2'), findsOneWidget);

      // Tekan tombol Kosongkan Keranjang -> Dialog muncul
      await tester.tap(find.byKey(const Key('btn_clear_cart')));
      await tester.pumpAndSettle();
      expect(find.text('Yakin ingin mengosongkan keranjang?'), findsOneWidget);

      // Tekan 'Batal' pada Dialog
      await tester.tap(find.byKey(const Key('btn_dialog_cancel')));
      await tester.pumpAndSettle();

      // Jumlah item harus tetap 2
      expect(find.text('Total Item: 2'), findsOneWidget);
    });

    testWidgets('1.10.2 - Mengosongkan keranjang saat konfirmasi diterima', (WidgetTester tester) async {
      List<String> cartItems = ['Kopi Susu', 'Roti Bakar'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Total Item: ${cartItems.length}', key: const Key('cart_count')),
                    ElevatedButton(
                      key: const Key('btn_clear_cart'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Konfirmasi'),
                            content: const Text('Yakin ingin mengosongkan keranjang?'),
                            actions: [
                              TextButton(
                                key: const Key('btn_dialog_confirm'),
                                onPressed: () {
                                  setState(() {
                                    cartItems.clear();
                                  });
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('Hapus'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Kosongkan Keranjang'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Tekan tombol Kosongkan Keranjang
      await tester.tap(find.byKey(const Key('btn_clear_cart')));
      await tester.pumpAndSettle();

      // Tekan 'Hapus' pada Dialog
      await tester.tap(find.byKey(const Key('btn_dialog_confirm')));
      await tester.pumpAndSettle();

      // Jumlah item menjadi 0
      expect(find.text('Total Item: 0'), findsOneWidget);
    });
  });
}
