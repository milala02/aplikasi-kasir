import '../../../core/money/money.dart';
import '../../../core/unit/unit.dart';

class Product {
  final String id;
  final String sku;
  final String name;
  final Unit baseUnit;
  final Money purchasePrice;
  final Money sellingPrice;
  final bool active;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.baseUnit,
    required this.purchasePrice,
    required this.sellingPrice,
    this.active = true,
  });

  Product copyWith({
    String? id,
    String? sku,
    String? name,
    Unit? baseUnit,
    Money? purchasePrice,
    Money? sellingPrice,
    bool? active,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      baseUnit: baseUnit ?? this.baseUnit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      active: active ?? this.active,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'sku: $sku, '
        'name: $name, '
        'baseUnit: $baseUnit, '
        'purchasePrice: $purchasePrice, '
        'sellingPrice: $sellingPrice, '
        'active: $active'
        ')';
  }
}
