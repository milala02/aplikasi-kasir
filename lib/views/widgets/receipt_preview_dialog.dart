import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptPreviewDialog extends StatefulWidget {
  final dynamic transaction; // Ganti dengan Model Transaksi Anda

  const ReceiptPreviewDialog({super.key, required this.transaction});

  @override
  State<ReceiptPreviewDialog> createState() => _ReceiptPreviewDialogState();
}

class _ReceiptPreviewDialogState extends State<ReceiptPreviewDialog> {
  final BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _getDevices();
  }

  Future<void> _getDevices() async {
    List<BluetoothDevice> devices = await bluetooth.getBondedDevices();
    setState(() => _devices = devices);
  }

  Future<void> _printReceipt(BluetoothDevice device) async {
    bool? isConnected = await bluetooth.isConnected;
    if (isConnected == false) {
      await bluetooth.connect(device);
    }
    
    // Format ESC/POS Thermal
    bluetooth.printCustom("TOKO KASIR", 3, 1);
    bluetooth.printCustom("ID: ${widget.transaction.id}", 1, 1);
    bluetooth.printCustom("-------------------", 1, 1);
    bluetooth.printCustom("Total: Rp ${widget.transaction.totalAmount.toInt()}", 2, 1);
    bluetooth.printCustom("Terima Kasih", 1, 1);
    bluetooth.paperCut();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pratinjau Struk'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total: Rp ${widget.transaction.totalAmount.toInt()}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButton<BluetoothDevice>(
              hint: const Text('Pilih Printer Thermal'),
              value: _selectedDevice,
              onChanged: (val) => setState(() => _selectedDevice = val),
              items: _devices.map((d) => DropdownMenuItem(value: d, child: Text(d.name ?? 'Unknown'))).toList(),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
            icon: const Icon(Icons.print, color: Colors.blue),
            onPressed: _selectedDevice != null ? () => _printReceipt(_selectedDevice!) : null),
        IconButton(
            icon: const Icon(Icons.share, color: Colors.green),
            onPressed: () async {
               final Uri url = Uri.parse("whatsapp://send?text=Struk Belanja: Rp ${widget.transaction.totalAmount}");
               if (await canLaunchUrl(url)) await launchUrl(url);
            }),
      ],
    );
  }
}
