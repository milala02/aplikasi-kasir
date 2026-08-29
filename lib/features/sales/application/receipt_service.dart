import '../../customers/domain/customer.dart';
import '../domain/sale.dart';

class ReceiptService {
  final String storeName;
  final String storeAddress;
  final String storePhone;

  ReceiptService({
    this.storeName = 'WARUNG BUMBU & RETAIL',
    this.storeAddress = 'Jl. Bintara Jaya, Bekasi',
    this.storePhone = '081234567890',
  });

  /// Menghasilkan format Teks Struk Rapi untuk WhatsApp
  String generateWhatsAppReceipt(Sale sale, {Customer? customer}) {
    final buffer = StringBuffer();
    buffer.writeln('==============================');
    buffer.writeln('       *$storeName*');
    buffer.writeln('   $storeAddress');
    buffer.writeln('==============================');
    buffer.writeln('No. Nota : ${sale.invoiceNumber}');
    buffer.writeln('Tanggal  : ${sale.createdAt.toString().split('.')[0]}');
    if (customer != null) {
      buffer.writeln('Pelanggan: ${customer.name}');
    }
    buffer.writeln('------------------------------');

    for (final item in sale.items) {
      final name = item.productName;
      final qty = item.quantity.value;
      final price = item.unitPrice.minorUnits ~/ 100;
      final subtotal = item.subtotal.minorUnits ~/ 100;
      buffer.writeln(name);
      buffer.writeln('  $qty x Rp $price = Rp $subtotal');
    }

    buffer.writeln('------------------------------');
    // Total konsisten dengan Sale.total (subtotal - diskon + pajak).
    if (!sale.discount.isZero) {
      buffer.writeln('Diskon  : -Rp ${sale.discount.minorUnits ~/ 100}');
    }
    if (!sale.tax.isZero) {
      buffer.writeln('Pajak   : +Rp ${sale.tax.minorUnits ~/ 100}');
    }
    final total = sale.total.minorUnits ~/ 100;
    buffer.writeln('*TOTAL: Rp $total*');
    buffer.writeln('==============================');
    buffer.writeln('Terima kasih atas kunjungan Anda!');

    return buffer.toString();
  }

  /// Menghasilkan Perintah Teks ESC/POS untuk Thermal Printer
  List<int> generateEscPosBytes(Sale sale) {
    final bytes = <int>[];

    // Initialize Printer (ESC @)
    bytes.addAll([0x1B, 0x40]);

    // Center Align
    bytes.addAll([0x1B, 0x61, 0x01]);
    bytes.addAll('$storeName\n'.codeUnits);
    bytes.addAll('$storeAddress\n'.codeUnits);
    bytes.addAll('--------------------------------\n'.codeUnits);

    // Left Align
    bytes.addAll([0x1B, 0x61, 0x00]);
    bytes.addAll('Nota : ${sale.invoiceNumber}\n'.codeUnits);
    bytes.addAll('Tgl  : ${sale.createdAt.toString().split('.')[0]}\n'.codeUnits);
    bytes.addAll('--------------------------------\n'.codeUnits);

    for (final item in sale.items) {
      bytes.addAll('${item.productName}\n'.codeUnits);
      final qty = item.quantity.value;
      final price = item.unitPrice.minorUnits ~/ 100;
      final subtotal = item.subtotal.minorUnits ~/ 100;
      bytes.addAll('  $qty x $price = $subtotal\n'.codeUnits);
    }

    // Total konsisten dengan Sale.total (subtotal - diskon + pajak).
    if (!sale.discount.isZero) {
      bytes.addAll('Diskon  : -Rp ${sale.discount.minorUnits ~/ 100}\n'.codeUnits);
    }
    if (!sale.tax.isZero) {
      bytes.addAll('Pajak   : +Rp ${sale.tax.minorUnits ~/ 100}\n'.codeUnits);
    }
    bytes.addAll('--------------------------------\n'.codeUnits);
    // Right Align Total
    bytes.addAll([0x1B, 0x61, 0x02]);
    final total = sale.total.minorUnits ~/ 100;
    bytes.addAll('TOTAL: Rp $total\n'.codeUnits);

    // Feed lines & Cut Paper
    bytes.addAll([0x1B, 0x64, 0x03]);

    return bytes;
  }
}
