import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';

void main() {
  group('Quantity', () {
    test('creates zero quantity', () {
      final quantity = Quantity.zero();

      expect(quantity.value, 0);
      expect(quantity.scale, 0);
      expect(quantity.isZero, isTrue);
    });

    test('creates positive quantity', () {
      final quantity = Quantity(
        value: 5,
      );

      expect(quantity.value, 5);
      expect(quantity.isPositive, isTrue);
    });

    test('supports decimal precision', () {
      final quantity = Quantity(
        value: 500,
        scale: 3,
      );

      expect(quantity.asDouble, 0.5);
    });

    test('adds quantities with the same scale', () {
      final first = Quantity(
        value: 500,
        scale: 3,
      );

      final second = Quantity(
        value: 250,
        scale: 3,
      );

      final result = first.add(second);

      expect(result.value, 750);
      expect(result.scale, 3);
      expect(result.asDouble, 0.75);
    });

    test('adds quantities with different scales', () {
      final kilogram = Quantity(
        value: 1,
        scale: 0,
      );

      final halfKilogram = Quantity(
        value: 500,
        scale: 3,
      );

      final result = kilogram.add(halfKilogram);

      expect(result.value, 1500);
      expect(result.scale, 3);
      expect(result.asDouble, 1.5);
    });

    test('subtracts quantities', () {
      final first = Quantity(
        value: 1000,
        scale: 3,
      );

      final second = Quantity(
        value: 250,
        scale: 3,
      );

      final result = first.subtract(second);

      expect(result.value, 750);
      expect(result.scale, 3);
      expect(result.asDouble, 0.75);
    });

    test('rejects negative quantity', () {
      expect(
        () => Quantity(value: -1),
        throwsArgumentError,
      );
    });

    test('rejects negative subtraction result', () {
      final first = Quantity(
        value: 2,
      );

      final second = Quantity(
        value: 3,
      );

      expect(
        () => first.subtract(second),
        throwsArgumentError,
      );
    });

    test('multiplies quantity', () {
      final quantity = Quantity(
        value: 500,
        scale: 3,
      );

      final result = quantity.multiply(4);

      expect(result.value, 2000);
      expect(result.scale, 3);
      expect(result.asDouble, 2.0);
    });

    test('rejects negative multiplier', () {
      final quantity = Quantity(value: 5);

      expect(
        () => quantity.multiply(-1),
        throwsArgumentError,
      );
    });

    test('rejects negative scale', () {
      expect(
        () => Quantity(
          value: 1,
          scale: -1,
        ),
        throwsArgumentError,
      );
    });
  });
}
