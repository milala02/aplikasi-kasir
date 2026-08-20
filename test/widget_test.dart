import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:aplikasi_kasir/main.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Aplikasi dapat dimuat tanpa error', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Ganti pumpAndSettle dengan pump biasa untuk mengabaikan animasi infinite
    // seperti CircularProgressIndicator atau kursor berkedip.
    await tester.pump(const Duration(seconds: 2));
    
    expect(find.byType(MyApp), findsOneWidget);
  });
}
