import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Menolak input karakter non-numerik (huruf, simbol, emoji) pada field angka', (WidgetTester tester) async {
    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
        ),
      ),
    );

    final textFieldFinder = find.byType(TextField);

    // 1. Simulasi memasukkan teks campuran (huruf, emoji, simbol, dan angka)
    await tester.enterText(textFieldFinder, 'abc#123😃99');
    await tester.pump();

    // Pastikan hanya karakter angka ('12399') yang diterima
    expect(controller.text, equals('12399'));

    // 2. Simulasi memasukkan karakter simbol murni (menggunakan raw string agar $ tidak terpolasi)
    await tester.enterText(textFieldFinder, r'@#$%^&*');
    await tester.pump();

    // Pastikan string menjadi kosong
    expect(controller.text, equals(''));

    // 3. Simulasi input nilai angka yang valid
    await tester.enterText(textFieldFinder, '50000');
    await tester.pump();

    expect(controller.text, equals('50000'));
  });
}
