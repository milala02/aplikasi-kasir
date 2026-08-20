import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 1.15 - Edge Cases & Extreme Input Validation', () {
    testWidgets('1.15.1 - Input angka negatif di-reset ke 0', (WidgetTester tester) async {
      double parsedAmount = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Amount: ${parsedAmount.toStringAsFixed(0)}', key: const Key('amount_text')),
                    TextField(
                      key: const Key('input_amount'),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        double valNum = double.tryParse(val) ?? 0.0;
                        setState(() {
                          parsedAmount = valNum < 0 ? 0.0 : valNum;
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

      await tester.enterText(find.byKey(const Key('input_amount')), '-50000');
      await tester.pumpAndSettle();

      expect(find.text('Amount: 0'), findsOneWidget);
    });

    testWidgets('1.15.2 - Penanganan input karakter tak valid (Fallback Safe)', (WidgetTester tester) async {
      double parsedAmount = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Amount: ${parsedAmount.toStringAsFixed(0)}', key: const Key('amount_text')),
                    TextField(
                      key: const Key('input_amount'),
                      onChanged: (val) {
                        setState(() {
                          parsedAmount = double.tryParse(val) ?? 0.0;
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

      // Raw String Dart (r'abc@#$') menjamin tidak terjadi interpolasi parser
      await tester.enterText(find.byKey(const Key('input_amount')), r'abc@#$');
      await tester.pumpAndSettle();

      expect(find.text('Amount: 0'), findsOneWidget);
    });

    testWidgets('1.15.3 - Penanganan nominal besar/ekstrem (Rp 1 Miliar)', (WidgetTester tester) async {
      double parsedAmount = 0.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Text('Amount: ${parsedAmount.toStringAsFixed(0)}', key: const Key('amount_text')),
                    TextField(
                      key: const Key('input_amount'),
                      onChanged: (val) {
                        setState(() {
                          parsedAmount = double.tryParse(val) ?? 0.0;
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

      await tester.enterText(find.byKey(const Key('input_amount')), '1000000000');
      await tester.pumpAndSettle();

      expect(find.text('Amount: 1000000000'), findsOneWidget);
    });
  });
}
