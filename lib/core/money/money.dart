class Money {
  final int minorUnits;
  final String currency;

  const Money({
    required this.minorUnits,
    required this.currency,
  });

  Money add(Money other) {
    _ensureSameCurrency(other);

    return Money(
      minorUnits: minorUnits + other.minorUnits,
      currency: currency,
    );
  }

  Money subtract(Money other) {
    _ensureSameCurrency(other);

    return Money(
      minorUnits: minorUnits - other.minorUnits,
      currency: currency,
    );
  }

  Money multiply(int multiplier) {
    return Money(
      minorUnits: minorUnits * multiplier,
      currency: currency,
    );
  }

  bool get isNegative => minorUnits < 0;

  bool get isZero => minorUnits == 0;

  bool get isPositive => minorUnits > 0;

  void _ensureSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Currency mismatch: $currency vs ${other.currency}',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Money &&
        other.minorUnits == minorUnits &&
        other.currency == currency;
  }

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() {
    return '$currency $minorUnits';
  }
}
