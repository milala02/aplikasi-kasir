import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 3.1 - Dashboard & Product Grid UI Validation', () {
    final List<Map<String, dynamic>> mockProducts = [
      {'id': 'P01', 'name': 'Kopi Latte', 'price': 22000.0, 'stock': 15},
      {'id': 'P02', 'name': 'Croissant', 'price': 18000.0, 'stock': 5},
    ];

    testWidgets('3.1.1 - Render grid produk lengkap dengan nama, harga, dan label stok', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Kasir POS - Katalog')),
            body: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: mockProducts.length,
              itemBuilder: (context, index) {
                final product = mockProducts[index];
                return Card(
                  key: Key('product_card_${product['id']}'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Rp ${product['price']}'),
                      Text('Stok: ${product['stock']}', key: Key('stock_${product['id']}')),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Kasir POS - Katalog'), findsOneWidget);
      expect(find.text('Kopi Latte'), findsOneWidget);
      expect(find.text('Croissant'), findsOneWidget);
      expect(find.text('Stok: 15'), findsOneWidget);
      expect(find.text('Stok: 5'), findsOneWidget);
    });

    testWidgets('3.1.2 - Mengetuk tombol Quick Add menambah item ke indikator keranjang', (WidgetTester tester) async {
      int cartCount = 0;

      // FIX: StatefulBuilder diletakkan di luar Scaffold agar AppBar ikut ter-rebuild
      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                appBar: AppBar(
                  actions: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.shopping_cart),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 8,
                            backgroundColor: Colors.red,
                            child: Text('$cartCount', key: const Key('cart_badge'), style: const TextStyle(fontSize: 10)),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                body: ListView(
                  children: [
                    ListTile(
                      title: const Text('Kopi Latte'),
                      trailing: IconButton(
                        key: const Key('btn_quick_add_P01'),
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          setState(() {
                            cartCount++;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('0'), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn_quick_add_P01')));
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
    });
  });
}
