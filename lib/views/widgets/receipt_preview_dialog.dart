import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReceiptPreviewDialog extends StatefulWidget {
  final dynamic transaction; // Ganti dengan Model Transaksi Anda

  const ReceiptPreviewDialog({super.key, required this.transaction});

  @override
  State<ReceiptPreviewDialog> createState() => _ReceiptPreviewDialogState();
}

class _ReceiptPreviewDialogState extends State<ReceiptPreviewDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Pratinjau Struk'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Total: Rp ${widget.transaction.totalAmount.toInt()}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Fitur cetak printer thermal akan ditambahkan di masa depan',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.green),
          onPressed: () async {
            final Uri url = Uri.parse(
              "whatsapp://send?text=Struk Belanja: Rp ${widget.transaction.totalAmount}",
            );
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }
}
