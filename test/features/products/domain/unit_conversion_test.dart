import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/unit_conversion.dart';

void main() {
  group('UnitConversion', () {
    test('converts cartons to bottles', () {
      final conversion = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(
        conversion.convert(Quantity(value: 1)),
        Quantity(value: 24),
      );
    });

    test('converts packs to bottles', () {
      final conversion = UnitConversion(
        from: Unit.pack,
        to: Unit.bottle,
        multiplier: 6,
      );

      expect(
        conversion.convert(Quantity(value: 2)),
        Quantity(value: 12),
      );
    });

    test('converts grams to kilograms', () {
      final conversion = UnitConversion(
        from: Unit.gram,
        to: Unit.kilogram,
        divisor: 1000,
      );

      expect(
        conversion.convert(Quantity(value: 2000)),
        Quantity(value: 2),
      );
    });

    test('supports fractional quantities with scale', () {
      final conversion = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(
        conversion.convert(
          Quantity(
            value: 500,
            scale: 3,
          ),
        ),
        Quantity(
          value: 12000,
          scale: 3,
        ),
      );
    });

    test('supports reverse conversion', () {
      final cartonToBottle = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      final bottleToCarton = cartonToBottle.reverse();

      expect(
        bottleToCarton.convert(Quantity(value: 48)),
        Quantity(value: 2),
      );
    });

    test('reverse conversion rejects non-exact quantity', () {
      final cartonToBottle = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      final bottleToCarton = cartonToBottle.reverse();

      expect(
        () => bottleToCarton.convert(Quantity(value: 1)),
        throwsArgumentError,
      );
    });

    test('supports zero quantity', () {
      final conversion = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(
        conversion.convert(Quantity.zero()),
        Quantity.zero(),
      );
    });

    test('preserves zero quantity scale', () {
      final conversion = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(
        conversion.convert(
          Quantity.zero(scale: 3),
        ),
        Quantity.zero(scale: 3),
      );
    });

    test('rejects non-exact conversion', () {
      final conversion = UnitConversion(
        from: Unit.bottle,
        to: Unit.carton,
        divisor: 24,
      );

      expect(
        () => conversion.convert(
          Quantity(value: 1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects invalid multiplier', () {
      expect(
        () => UnitConversion(
          from: Unit.carton,
          to: Unit.bottle,
          multiplier: 0,
        ),
        throwsArgumentError,
      );

      expect(
        () => UnitConversion(
          from: Unit.carton,
          to: Unit.bottle,
          multiplier: -1,
        ),
        throwsArgumentError,
      );
    });

    test('rejects invalid divisor', () {
      expect(
        () => UnitConversion(
          from: Unit.gram,
          to: Unit.kilogram,
          divisor: 0,
        ),
        throwsArgumentError,
      );

      expect(
        () => UnitConversion(
          from: Unit.gram,
          to: Unit.kilogram,
          divisor: -1,
        ),
        throwsArgumentError,
      );
    });

    test('rejects conversion between the same unit', () {
      expect(
        () => UnitConversion(
          from: Unit.kilogram,
          to: Unit.kilogram,
        ),
        throwsArgumentError,
      );
    });

    test('equal conversions have equal hash codes', () {
      final first = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      final second = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(first, equals(second));
      expect(first.hashCode, second.hashCode);
    });
  });
}
