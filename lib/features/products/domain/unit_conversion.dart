import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';

class UnitConversion {
  final Unit from;
  final Unit to;
  final int multiplier;
  final int divisor;

  const UnitConversion({
    required this.from,
    required this.to,
    this.multiplier = 1,
    this.divisor = 1,
  })  : assert(multiplier > 0),
        assert(divisor > 0);

  Quantity convert(Quantity quantity) {
    if (quantity.isZero) {
      return Quantity.zero(
        scale: quantity.scale,
      );
    }

    final numerator = quantity.value * multiplier;

    if (numerator % divisor != 0) {
      throw ArgumentError(
        'Conversion produces a non-exact quantity.',
      );
    }

    return Quantity(
      value: numerator ~/ divisor,
      scale: quantity.scale,
    );
  }

  UnitConversion reverse() {
    return UnitConversion(
      from: to,
      to: from,
      multiplier: divisor,
      divisor: multiplier,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnitConversion &&
        other.from == from &&
        other.to == to &&
        other.multiplier == multiplier &&
        other.divisor == divisor;
  }

  @override
  int get hashCode {
    return Object.hash(
      from,
      to,
      multiplier,
      divisor,
    );
  }

  @override
  String toString() {
    return 'UnitConversion('
        'from: $from, '
        'to: $to, '
        'multiplier: $multiplier, '
        'divisor: $divisor'
        ')';
  }
}
