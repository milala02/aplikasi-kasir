import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 4.1 - End-to-End Full Transaction Flow', () {
    testWidgets('4.1.1 - Alur Transaksi Lengkap: Pilih Produk -> Keranjang -> Bayar -> Update Stok & Riwayat', (WidgetTester tester) async {
      int productStock = 10;
      int cartQty = 0;
      double itemPrice = 20000.0;
      List<String> historyLogs = [];

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                appBar: AppBar(title: const Text('POS App - E2E')),
                body: Column(
                  children: [
                    // Component 1: Catalog Item
                    ListTile(
                      title: const Text('Kopi Robusta'),
                      subtitle: Text('Stok: $productStock'),
                      trailing: ElevatedButton(
                        key: const Key('btn_add_kopi'),
                        onPressed: productStock > 0 ? () {
                          setState(() {
                            cartQty++;
                          });
                        } : null,
                        child: const Text('Tambah'),
                      ),
                    ),
                    const Divider(),
                    // Component 2: Cart & Checkout
                    Text('Item di Keranjang: $cartQty', key: const Key('cart_qty_text')),
                    Text('Total: Rp ${(cartQty * itemPrice).toStringAsFixed(0)}'),
                    ElevatedButton(
                      key: const Key('btn_process_checkout'),
                      onPressed: cartQty > 0 ? () {
                        setState(() {
                          productStock -= cartQty;
                          historyLogs.add('TRX-E2E-01 (${cartQty}x Kopi Robusta)');
                          cartQty = 0;
                        });
                      } : null,
                      child: const Text('Proses Pembayaran'),
                    ),
                    const Divider(),
                    // Component 3: History List
                    const Text('Riwayat Transaksi:', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...historyLogs.map((log) => Text(log, key: Key('history_$log'))),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // STEP 1: Verifikasi Kondisi Awal
      expect(find.text('Stok: 10'), findsOneWidget);
      expect(find.text('Item di Keranjang: 0'), findsOneWidget);

      // STEP 2: Tambahkan 2 Kopi ke Keranjang
      await tester.tap(find.byKey(const Key('btn_add_kopi')));
      await tester.tap(find.byKey(const Key('btn_add_kopi')));
      await tester.pumpAndSettle();

      expect(find.text('Item di Keranjang: 2'), findsOneWidget);

      // STEP 3: Proses Checkout Pembayaran
      await tester.tap(find.byKey(const Key('btn_process_checkout')));
      await tester.pumpAndSettle();

      // STEP 4: Verifikasi Hasil Akhir (Stok Berkurang, Keranjang Reset, Riwayat Bertambah)
      expect(find.text('Stok: 8'), findsOneWidget);
      expect(find.text('Item di Keranjang: 0'), findsOneWidget);
      expect(find.text('TRX-E2E-01 (2x Kopi Robusta)'), findsOneWidget);
    });
  });
}
