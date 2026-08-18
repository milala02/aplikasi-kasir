import '../../../core/money/money.dart';
import 'sale_item.dart';

class Sale {
  final String id;
  final String invoiceNumber;
  final List<SaleItem> items;
  final Money discount;
  final Money tax;
  final DateTime createdAt;
  final DateTime soldAt;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    Money? discount,
    Money? tax,
    required this.createdAt,
    DateTime? soldAt,
  })  : discount = discount ?? const Money(minorUnits: 0, currency: 'IDR'),
        tax = tax ?? const Money(minorUnits: 0, currency: 'IDR'),
        soldAt = soldAt ?? createdAt {
    if (id.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }
    if (invoiceNumber.isEmpty) {
      throw ArgumentError('Invoice number cannot be empty.');
    }
    if (items.isEmpty) {
      throw ArgumentError('Sale items cannot be empty.');
    }
  }

  /// Menghitung subtotal dari seluruh item
  Money get subtotal {
    if (items.isEmpty) {
      return const Money(minorUnits: 0, currency: 'IDR');
    }
    var totalMinor = 0;
    final currency = items.first.unitPrice.currency;

    for (final item in items) {
      totalMinor += item.subtotal.minorUnits;
    }

    return Money(minorUnits: totalMinor, currency: currency);
  }

  /// Menghitung total transaksi (subtotal - discount + tax)
  Money get total {
    final netMinor = subtotal.minorUnits - discount.minorUnits + tax.minorUnits;
    return Money(
      minorUnits: netMinor < 0 ? 0 : netMinor,
      currency: subtotal.currency,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Sale &&
        other.id == id &&
        other.invoiceNumber == invoiceNumber &&
        other.discount == discount &&
        other.tax == tax &&
        other.createdAt == createdAt &&
        other.soldAt == soldAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      invoiceNumber,
      discount,
      tax,
      createdAt,
      soldAt,
    );
  }
}
