import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EmptyStateListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  final String emptyMessage;

  const EmptyStateListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              emptyMessage,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index]),
    );
  }
}

void main() {
  testWidgets('Menampilkan pesan Empty State saat data list kosong tanpa crash', (WidgetTester tester) async {
    final List<String> emptyInventory = [];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyStateListView<String>(
            items: emptyInventory,
            emptyMessage: 'Data inventaris belum tersedia',
            itemBuilder: (context, item) => ListTile(title: Text(item)),
          ),
        ),
      ),
    );

    // Verifikasi ikon dan pesan empty state tampil di layar
    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(find.text('Data inventaris belum tersedia'), findsOneWidget);

    // Verifikasi tidak ada widget ListTile yang dirender
    expect(find.byType(ListTile), findsNothing);
  });
}
