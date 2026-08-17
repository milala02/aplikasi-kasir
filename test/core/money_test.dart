import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';

void main() {
  group('Money', () {
    test('adds money with the same currency', () {
      const first = Money(
        minorUnits: 10000,
        currency: 'IDR',
      );

      const second = Money(
        minorUnits: 5000,
        currency: 'IDR',
      );

      expect(
        first.add(second),
        const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );
    });

    test('subtracts money with the same currency', () {
      const first = Money(
        minorUnits: 10000,
        currency: 'IDR',
      );

      const second = Money(
        minorUnits: 3000,
        currency: 'IDR',
      );

      expect(
        first.subtract(second),
        const Money(
          minorUnits: 7000,
          currency: 'IDR',
        ),
      );
    });

    test('multiplies money by an integer', () {
      const money = Money(
        minorUnits: 5000,
        currency: 'IDR',
      );

      expect(
        money.multiply(3),
        const Money(
          minorUnits: 15000,
          currency: 'IDR',
        ),
      );
    });

    test('detects negative money', () {
      const money = Money(
        minorUnits: -1000,
        currency: 'IDR',
      );

      expect(money.isNegative, isTrue);
    });

    test('rejects different currencies', () {
      const idr = Money(
        minorUnits: 10000,
        currency: 'IDR',
      );

      const usd = Money(
        minorUnits: 10000,
        currency: 'USD',
      );

      expect(
        () => idr.add(usd),
        throwsArgumentError,
      );
    });
  });
}
