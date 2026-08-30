import '../../../core/unit/unit.dart';
import 'unit_conversion.dart';

/// Konversi packaging per produk (mis. 1 Box = 24 Unit untuk Produk A).
/// Rasional eksak: quantity * multiplierValue ~/ divisorValue.
class ProductPackaging {
  final String id;
  final String productId;
  final Unit fromUnit;
  final Unit toUnit;
  final int multiplierValue;
  final int divisorValue;

  ProductPackaging({
    required this.id,
    required this.productId,
    required this.fromUnit,
    required this.toUnit,
    required this.multiplierValue,
    required this.divisorValue,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('Packaging ID cannot be empty.');
    }
    if (productId.isEmpty) {
      throw ArgumentError('Packaging product ID cannot be empty.');
    }
    if (fromUnit == toUnit) {
      throw ArgumentError('Source and target units must be different.');
    }
    if (multiplierValue <= 0) {
      throw ArgumentError('Multiplier must be greater than zero.');
    }
    if (divisorValue <= 0) {
      throw ArgumentError('Divisor must be greater than zero.');
    }
  }

  UnitConversion get conversion => UnitConversion(
        from: fromUnit,
        to: toUnit,
        multiplier: multiplierValue,
        divisor: divisorValue,
      );
}
