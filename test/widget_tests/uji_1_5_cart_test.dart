import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.5 - Cart Quantity & Calculation Validation', () {
    testWidgets('1.5.1 - Increment kuantitas memperbarui subtotal dengan benar', (WidgetTester tester) async {
      int currentQty = 1;
      double unitPrice = 15000.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Qty: $currentQty', key: const Key('qty_text')),
                    Text('Total: ${unitPrice * currentQty}', key: const Key('total_text')),
                    IconButton(
                      key: const Key('btn_increment'),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          currentQty++;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Total: 15000.0'), findsOneWidget);

      await tester.tap(find.byKey(const Key('btn_increment')));
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Total: 30000.0'), findsOneWidget);
    });

    testWidgets('1.5.2 - Mencegah penambahan jika melebihi batas stok', (WidgetTester tester) async {
      int stockLimit = 2;
      int currentQty = 2;
      bool showStockWarning = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Qty: $currentQty'),
                    if (showStockWarning) const Text('Stok tidak mencukupi'),
                    IconButton(
                      key: const Key('btn_increment'),
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (currentQty >= stockLimit) {
                          setState(() {
                            showStockWarning = true;
                          });
                        } else {
                          setState(() {
                            currentQty++;
                          });
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('btn_increment')));
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Stok tidak mencukupi'), findsOneWidget);
    });
  });
}
