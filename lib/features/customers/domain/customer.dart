import 'dart:core';

class Customer {
  final String id;
  final String name;
  final String phoneNumber;
  final String? address;
  final String? notes;
  final DateTime createdAt;

  Customer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.address,
    this.notes,
    required this.createdAt,
  }) {
    if (id.isEmpty) throw ArgumentError('Customer ID cannot be empty.');
    if (name.isEmpty) throw ArgumentError('Customer name cannot be empty.');
    if (phoneNumber.isEmpty) throw ArgumentError('Customer phone number cannot be empty.');
  }

  /// Format nomor HP standar internasional untuk WhatsApp (misal: 62812345678)
  String get formattedWhatsAppNumber {
    var cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.startsWith('0')) {
      cleaned = '62${cleaned.substring(1)}';
    } else if (cleaned.startsWith('+')) {
      cleaned = cleaned.substring(1);
    }
    return cleaned;
  }

  /// Membuat URL WhatsApp Direct Message
  String generateWhatsAppUrl(String message) {
    final encodedMessage = Uri.encodeComponent(message);
    return 'https://wa.me/$formattedWhatsAppNumber?text=$encodedMessage';
  }
}
