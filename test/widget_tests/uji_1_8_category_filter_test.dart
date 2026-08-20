import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.8 - Category Filter & Product Search Validation', () {
    final List<Map<String, String>> dummyProducts = [
      {'name': 'Kopi Hitam', 'category': 'Minuman'},
      {'name': 'Es Teh manis', 'category': 'Minuman'},
      {'name': 'Roti Bakar', 'category': 'Makanan'},
      {'name': 'Nasi Goreng', 'category': 'Makanan'},
    ];

    testWidgets('1.8.1 - Filter produk berdasarkan tombol kategori', (WidgetTester tester) async {
      String selectedCategory = 'Semua';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                final filtered = selectedCategory == 'Semua'
                    ? dummyProducts
                    : dummyProducts.where((p) => p['category'] == selectedCategory).toList();

                return Column(
                  children: [
                    Row(
                      children: [
                        ElevatedButton(
                          key: const Key('btn_cat_semua'),
                          onPressed: () => setState(() => selectedCategory = 'Semua'),
                          child: const Text('Semua'),
                        ),
                        ElevatedButton(
                          key: const Key('btn_cat_makanan'),
                          onPressed: () => setState(() => selectedCategory = 'Makanan'),
                          child: const Text('Makanan'),
                        ),
                        ElevatedButton(
                          key: const Key('btn_cat_minuman'),
                          onPressed: () => setState(() => selectedCategory = 'Minuman'),
                          child: const Text('Minuman'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) => ListTile(
                          title: Text(filtered[index]['name']!),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Awal: Semua produk muncul (4 item)
      expect(find.text('Kopi Hitam'), findsOneWidget);
      expect(find.text('Roti Bakar'), findsOneWidget);

      // Filter Makanan
      await tester.tap(find.byKey(const Key('btn_cat_makanan')));
      await tester.pumpAndSettle();

      expect(find.text('Kopi Hitam'), findsNothing);
      expect(find.text('Roti Bakar'), findsOneWidget);
      expect(find.text('Nasi Goreng'), findsOneWidget);

      // Filter Minuman
      await tester.tap(find.byKey(const Key('btn_cat_minuman')));
      await tester.pumpAndSettle();

      expect(find.text('Kopi Hitam'), findsOneWidget);
      expect(find.text('Es Teh manis'), findsOneWidget);
      expect(find.text('Roti Bakar'), findsNothing);
    });

    testWidgets('1.8.2 - Tampilan Empty State saat produk tidak ditemukan', (WidgetTester tester) async {
      String searchQuery = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                final filtered = dummyProducts
                    .where((p) => p['name']!.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();

                return Column(
                  children: [
                    TextField(
                      key: const Key('input_search_product'),
                      onChanged: (val) => setState(() => searchQuery = val),
                    ),
                    Expanded(
                      child: filtered.isEmpty
                          ? const Center(child: Text('Produk tidak ditemukan', key: Key('empty_state')))
                          : ListView.builder(
                              itemCount: filtered.length,
                              itemBuilder: (context, index) => ListTile(
                                title: Text(filtered[index]['name']!),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Cari kata kunci acak yang tidak ada di daftar
      await tester.enterText(find.byKey(const Key('input_search_product')), 'PizzaXyz');
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('empty_state')), findsOneWidget);
      expect(find.text('Produk tidak ditemukan'), findsOneWidget);
    });
  });
}
