import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Mempertahankan input data & layout saat terjadi rotasi layar (Portrait ke Landscape)', (WidgetTester tester) async {
    // 1. Atur ukuran layar awal ke kondisi Portrait (400x800)
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final controller = TextEditingController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Text('Form Transaksi Kasir'),
                TextField(
                  key: const Key('field_catatan'),
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 2. Simulasi pengisian data pada posisi Portrait
    await tester.enterText(find.byKey(const Key('field_catatan')), 'Diskon Khusus Member');
    await tester.pump();

    expect(controller.text, equals('Diskon Khusus Member'));

    // 3. Simulasi rotasi layar ke posisi Landscape (800x400)
    tester.view.physicalSize = const Size(800, 400);
    await tester.pumpAndSettle();

    // 4. Verifikasi data input tidak terhapus/reset setelah layar berotasi
    expect(controller.text, equals('Diskon Khusus Member'));
    expect(find.byKey(const Key('field_catatan')), findsOneWidget);
  });
}
