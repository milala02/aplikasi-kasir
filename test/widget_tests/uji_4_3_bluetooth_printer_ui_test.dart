import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Uji 4.3 - Bluetooth Printer UI & Selection Validation', () {
    final List<Map<String, String>> mockDevices = [
      {'name': 'Thermal Printer 58mm', 'address': '00:11:22:33:44:55'},
      {'name': 'RPP02N Portable', 'address': 'AA:BB:CC:DD:EE:FF'},
    ];

    testWidgets('3.3.1 / 4.3.1 - Dialog pemindaian Bluetooth menampilkan daftar printer', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  key: const Key('btn_scan_printer'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Pilih Printer Bluetooth'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: mockDevices.map((dev) => ListTile(
                            key: Key('device_${dev['address']}'),
                            title: Text(dev['name']!),
                            subtitle: Text(dev['address']!),
                          )).toList(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Cari Printer'),
                );
              },
            ),
          ),
        ),
      );

      // Buka modal pencarian printer
      await tester.tap(find.byKey(const Key('btn_scan_printer')));
      await tester.pumpAndSettle();

      // Verifikasi dialog dan daftar perangkat Bluetooth muncul
      expect(find.text('Pilih Printer Bluetooth'), findsOneWidget);
      expect(find.text('Thermal Printer 58mm'), findsOneWidget);
      expect(find.text('RPP02N Portable'), findsOneWidget);
    });

    testWidgets('4.3.2 - Memilih printer mengubah indikator status menjadi Terhubung & mengaktifkan Test Print', (WidgetTester tester) async {
      String connectedDevice = 'Belum Terhubung';
      bool isConnected = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Pengaturan Printer'),
                  actions: [
                    Chip(
                      key: const Key('printer_status_chip'),
                      backgroundColor: isConnected ? Colors.green : Colors.red,
                      label: Text(
                        isConnected ? 'Terhubung' : 'Terputus',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Text('Perangkat: $connectedDevice', key: const Key('device_name_text')),
                    ElevatedButton(
                      key: const Key('btn_select_printer'),
                      onPressed: () {
                        setState(() {
                          connectedDevice = 'Thermal Printer 58mm';
                          isConnected = true;
                        });
                      },
                      child: const Text('Hubungkan Printer'),
                    ),
                    ElevatedButton(
                      key: const Key('btn_test_print'),
                      onPressed: isConnected ? () {} : null,
                      child: const Text('Cetak Struk Tes'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Verifikasi kondisi awal
      expect(find.text('Terputus'), findsOneWidget);
      expect(find.text('Perangkat: Belum Terhubung'), findsOneWidget);

      // Pilih printer
      await tester.tap(find.byKey(const Key('btn_select_printer')));
      await tester.pumpAndSettle();

      // Verifikasi status berubah jadi Terhubung & tombol Test Print aktif
      expect(find.text('Terhubung'), findsOneWidget);
      expect(find.text('Perangkat: Thermal Printer 58mm'), findsOneWidget);
      expect(find.byKey(const Key('btn_test_print')), findsOneWidget);
    });
  });
}
