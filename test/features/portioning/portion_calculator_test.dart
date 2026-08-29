import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/portioning/application/calculate_portion_use_case.dart';

void main() {
  group('Portioning / Ketengan Calculator Engine', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late CalculatePortionUseCase useCase;

    setUp(() {
      costLayerRepo = InMemoryCostLayerRepository();
      useCase = CalculatePortionUseCase(costLayerRepository: costLayerRepo);
    });

    test(
        'Harus menghitung takaran Lada Ketengan Rp 5.000 (Margin 30%, Modal Rp 160rb/kg)',
        () async {
      // Stock Layer Lada: Rp 160.000 / kg = Rp 160 / gram
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_lada_01',
          productId: 'lada_biji',
          originalQuantity: Quantity(value: 10, scale: 0),
          remainingQuantity: Quantity(value: 10, scale: 0),
          unitCost:
              const Money(minorUnits: 16000000, currency: 'IDR'), // Rp 160.000
          acquiredAt: DateTime.now(),
        ),
      );

      final result = await useCase.execute(
        productId: 'lada_biji',
        targetSellingPrice:
            const Money(minorUnits: 500000, currency: 'IDR'), // Rp 5.000
        targetMarginPercentage: 0.30, // 30% Margin Target
        packagingCostPerUnit:
            const Money(minorUnits: 30000, currency: 'IDR'), // Plastik Rp 300
      );

      // Max COGS = 70% x Rp 5.000 = Rp 3.500
      // Material Budget = Rp 3.500 - Rp 300 = Rp 3.200
      // Berat = Rp 3.200 / Rp 160 = 20 gram
      expect(result.recommendedWeightPerPortionInGrams.value, equals(20));
      expect(result.totalPortionsPerKg, equals(50)); // 1000g / 20g = 50 bungkus
      expect(result.profitPerPortion.minorUnits,
          equals(150000)); // Untung Rp 1.500 / bungkus
    });

    test('Harus menghitung takaran Ketengan Rp 10.000 (Margin 40%)', () async {
      await costLayerRepo.save(
        CostLayer(
          id: 'layer_lada_01',
          productId: 'lada_biji',
          originalQuantity: Quantity(value: 5, scale: 0),
          remainingQuantity: Quantity(value: 5, scale: 0),
          unitCost:
              const Money(minorUnits: 16000000, currency: 'IDR'), // Rp 160.000
          acquiredAt: DateTime.now(),
        ),
      );

      final result = await useCase.execute(
        productId: 'lada_biji',
        targetSellingPrice:
            const Money(minorUnits: 1000000, currency: 'IDR'), // Rp 10.000
        targetMarginPercentage: 0.40, // 40% Margin Target
        packagingCostPerUnit:
            const Money(minorUnits: 40000, currency: 'IDR'), // Plastik Rp 400
      );

      // Max COGS = 60% x Rp 10.000 = Rp 6.000
      // Material Budget = Rp 6.000 - Rp 400 = Rp 5.600
      // Berat = Rp 5.600 / Rp 160 = 35 gram
      expect(result.recommendedWeightPerPortionInGrams.value, equals(35));
      expect(result.totalPortionsPerKg, equals(28)); // 1000g / 35g = 28 bungkus
    });
  });
}
