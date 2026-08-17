import '../../../core/money/money.dart';
import '../../../core/unit/unit.dart';

class Product {
  final String id;
  final String sku;
  final String name;
  final Unit unit;
  final Money purchasePrice;
  final Money sellingPrice;
  final bool active;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.unit,
    required this.purchasePrice,
    required this.sellingPrice,
    this.active = true,
  });

  Product copyWith({
    String? id,
    String? sku,
    String? name,
    Unit? unit,
    Money? purchasePrice,
    Money? sellingPrice,
    bool? active,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      active: active ?? this.active,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Product &&
        other.id == id &&
        other.sku == sku &&
        other.name == name &&
        other.unit == unit &&
        other.purchasePrice == purchasePrice &&
        other.sellingPrice == sellingPrice &&
        other.active == active;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      sku,
      name,
      unit,
      purchasePrice,
      sellingPrice,
      active,
    );
  }

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'sku: $sku, '
        'name: $name, '
        'unit: $unit, '
        'purchasePrice: $purchasePrice, '
        'sellingPrice: $sellingPrice, '
        'active: $active'
        ')';
  }
}
