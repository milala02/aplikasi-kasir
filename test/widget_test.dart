import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/main.dart';

void main() {
  testWidgets('Aplikasi merender InitialPinSetupScreen saat instalasi pertama', (WidgetTester tester) async {
    // 1. Mock SharedPreferences agar tidak crash di environment test
    SharedPreferences.setMockInitialValues({
      'is_initial_setup_done': false,
    });
    
    // 2. Render MyApp dengan state isSetupDone = false
    await tester.pumpWidget(const MyApp(isSetupDone: false));
    await tester.pumpAndSettle();

    // 3. Verifikasi UI: Pastikan layar Setup PIN yang muncul, bukan PosDashboard
    expect(find.text('Selamat Datang di POS Kasir'), findsOneWidget);
    expect(find.text('Buat PIN Owner (6 Digit)'), findsOneWidget);
  });
}
