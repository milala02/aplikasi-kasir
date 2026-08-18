import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/unit_conversion.dart';

void main() {
  group('UnitConversion', () {
    test('converts cartons to bottles', () {
      const conversion = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(
        conversion.convert(
          Quantity(value: 1),
        ),
        Quantity(value: 24),
      );
    });

    test('converts packs to bottles', () {
      const conversion = UnitConversion(
        from: Unit.pack,
        to: Unit.bottle,
        multiplier: 6,
      );

      expect(
        conversion.convert(
          Quantity(value: 2),
        ),
        Quantity(value: 12),
      );
    });

    test('converts grams to kilograms', () {
      const conversion = UnitConversion(
        from: Unit.gram,
        to: Unit.kilogram,
        divisor: 1000,
      );

      expect(
        conversion.convert(
          Quantity(value: 2000),
        ),
        Quantity(value: 2),
      );
    });

    test('supports reverse conversion', () {
      const cartonToBottle = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      final bottleToCarton = cartonToBottle.reverse();

      expect(
        bottleToCarton.convert(
          Quantity(value: 48),
        ),
        Quantity(value: 2),
      );
    });

    test('supports zero quantity', () {
      const conversion = UnitConversion(
        from: Unit.carton,
        to: Unit.bottle,
        multiplier: 24,
      );

      expect(
        conversion.convert(
          Quantity.zero(),
        ),
        Quantity.zero(),
      );
    });

    test('rejects non-exact conversion', () {
      const conversion = UnitConversion(
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
        throwsAssertionError,
      );
    });

    test('rejects invalid divisor', () {
      expect(
        () => UnitConversion(
          from: Unit.gram,
          to: Unit.kilogram,
          divisor: 0,
        ),
        throwsAssertionError,
      );
    });
  });
}
