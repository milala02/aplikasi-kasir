import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/main.dart' as app;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Uji Inisialisasi & Cold-Start Aplikasi', () {
    testWidgets('Boot Test: Aplikasi harus lolos inisialisasi dan merender UI tanpa error', (WidgetTester tester) async {
      SharedPreferences.setMockInitialValues({});
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(app.MyApp), findsOneWidget);
      expect(find.textContaining('GAGAL INISIALISASI APLIKASI'), findsNothing);
    });
  });
}
