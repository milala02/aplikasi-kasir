import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';

void main() {
  group('Unit', () {
    test('contains supported inventory units', () {
      expect(Unit.values, contains(Unit.pcs));
      expect(Unit.values, contains(Unit.gram));
      expect(Unit.values, contains(Unit.kilogram));
      expect(Unit.values, contains(Unit.milliliter));
      expect(Unit.values, contains(Unit.liter));
      expect(Unit.values, contains(Unit.box));
      expect(Unit.values, contains(Unit.pack));
      expect(Unit.values, contains(Unit.bottle));
      expect(Unit.values, contains(Unit.carton));
    });

    test('unit values are distinct', () {
      expect(Unit.pcs, isNot(Unit.gram));
      expect(Unit.gram, isNot(Unit.kilogram));
      expect(Unit.liter, isNot(Unit.milliliter));
    });
  });
}
