import '../../../core/money/money.dart';
import 'sale_item.dart';

class Sale {
  final String id;
  final String invoiceNumber;
  final List<SaleItem> items;
  final Money discount;
  final Money tax;
  final DateTime createdAt;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.discount,
    required this.tax,
    required this.createdAt,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }

    if (invoiceNumber.isEmpty) {
      throw ArgumentError('Invoice number cannot be empty.');
    }

    if (items.isEmpty) {
      throw ArgumentError('Sale must contain at least one item.');
    }

    if (discount.isNegative) {
      throw ArgumentError('Sale discount cannot be negative.');
    }

    if (tax.isNegative) {
      throw ArgumentError('Sale tax cannot be negative.');
    }

    final currency = items.first.unitPrice.currency;

    if (discount.currency != currency) {
      throw ArgumentError('Sale discount currency must match item currency.');
    }

    if (tax.currency != currency) {
      throw ArgumentError('Sale tax currency must match item currency.');
    }

    for (final item in items) {
      if (item.unitPrice.currency != currency) {
        throw ArgumentError(
          'All sale items must use the same currency.',
        );
      }
    }
  }

  Money get subtotal {
    var result = Money(
      minorUnits: 0,
      currency: items.first.unitPrice.currency,
    );

    for (final item in items) {
      result = result.add(item.subtotal);
    }

    return result;
  }

  Money get total {
    final afterDiscount = subtotal.subtract(discount);

    if (afterDiscount.isNegative) {
      throw ArgumentError(
        'Sale discount cannot exceed subtotal.',
      );
    }

    return afterDiscount.add(tax);
  }

  @override
  bool operator ==(Object other) {
    return other is Sale &&
        other.id == id &&
        other.invoiceNumber == invoiceNumber &&
        _listEquals(other.items, items) &&
        other.discount == discount &&
        other.tax == tax &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      invoiceNumber,
      Object.hashAll(items),
      discount,
      tax,
      createdAt,
    );
  }

  bool _listEquals(List<SaleItem> other, List<SaleItem> current) {
    if (other.length != current.length) {
      return false;
    }

    for (var i = 0; i < current.length; i++) {
      if (other[i] != current[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  String toString() {
    return 'Sale('
        'id: $id, '
        'invoiceNumber: $invoiceNumber, '
        'items: $items, '
        'discount: $discount, '
        'tax: $tax, '
        'createdAt: $createdAt'
        ')';
  }
}
