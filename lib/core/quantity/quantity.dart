class Quantity {
  final int value;
  final int scale;

  const Quantity._({
    required this.value,
    required this.scale,
  });

  factory Quantity({
    required int value,
    int scale = 0,
  }) {
    if (scale < 0) {
      throw ArgumentError.value(
        scale,
        'scale',
        'Scale cannot be negative.',
      );
    }

    if (value < 0) {
      throw ArgumentError.value(
        value,
        'value',
        'Quantity cannot be negative.',
      );
    }

    return Quantity._(
      value: value,
      scale: scale,
    );
  }

  static Quantity zero({int scale = 0}) {
    return Quantity(
      value: 0,
      scale: scale,
    );
  }

  double get asDouble => value / _factor(scale);

  bool get isZero => value == 0;

  bool get isPositive => value > 0;

  Quantity add(Quantity other) {
    final commonScale = scale > other.scale ? scale : other.scale;

    final left = _scaleTo(commonScale);
    final right = other._scaleTo(commonScale);

    return Quantity._(
      value: left + right,
      scale: commonScale,
    );
  }

  Quantity subtract(Quantity other) {
    final commonScale = scale > other.scale ? scale : other.scale;

    final left = _scaleTo(commonScale);
    final right = other._scaleTo(commonScale);

    final result = left - right;

    if (result < 0) {
      throw ArgumentError(
        'Quantity cannot become negative.',
      );
    }

    return Quantity._(
      value: result,
      scale: commonScale,
    );
  }

  Quantity multiply(int multiplier) {
    if (multiplier < 0) {
      throw ArgumentError.value(
        multiplier,
        'multiplier',
        'Multiplier cannot be negative.',
      );
    }

    return Quantity._(
      value: value * multiplier,
      scale: scale,
    );
  }

  int _scaleTo(int targetScale) {
    if (targetScale == scale) {
      return value;
    }

    final difference = targetScale - scale;

    return value * _factor(difference);
  }

  static int _factor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }

  @override
  bool operator ==(Object other) {
    return other is Quantity &&
        other.value == value &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(value, scale);

  @override
  String toString() {
    return 'Quantity(value: $value, scale: $scale)';
  }
}
