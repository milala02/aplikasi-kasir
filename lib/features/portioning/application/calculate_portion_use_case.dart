import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

import '../../inventory/domain/cost_layer_repository.dart';
import '../domain/portion_calculation_result.dart';

class CalculatePortionUseCase {
  final CostLayerRepository costLayerRepository;

  CalculatePortionUseCase({
    required this.costLayerRepository,
  });

  /// Menghitung rekomendasi takaran gram ketengan berdasarkan harga jual & target margin
  Future<PortionCalculationResult> execute({
    required String productId,
    required Money targetSellingPrice,
    required double targetMarginPercentage, // Misal 0.30 untuk 30%
    Money? packagingCostPerUnit,
  }) async {
    if (targetMarginPercentage <= 0 || targetMarginPercentage >= 1.0) {
      throw ArgumentError(
          'Margin percentage must be between 0.0 and 1.0 (e.g., 0.30 for 30%).');
    }

    final pkgCost =
        packagingCostPerUnit ?? const Money(minorUnits: 0, currency: 'IDR');

    // 1. Ambil modal bahan rata-rata / FIFO layer dari Inventory
    final availableLayers =
        await costLayerRepository.getAvailableByProductId(productId);
    if (availableLayers.isEmpty) {
      throw StateError(
          'Tidak ada stok/cost layer aktif untuk produk $productId.');
    }

    // Mengambil HPP/Cost per gram dari layer FIFO tertua
    final activeLayer = availableLayers.first;

    // Konversi unitCost per kg ke unitCost per Gram (dibagi 1.000)
    final costPerGramMinor = activeLayer.unitCost.minorUnits ~/ 1000;
    final materialCostPerGram = Money(
        minorUnits: costPerGramMinor, currency: activeLayer.unitCost.currency);

    // 2. Hitung Batas Maksimal Modal per Bungkus (COGS = Price * (1 - Margin))
    final maxCogsMinor =
        (targetSellingPrice.minorUnits * (1.0 - targetMarginPercentage))
            .round();

    // 3. Hitung Anggaran Bahan per Bungkus = COGS - Biaya Kemasan
    final materialBudgetMinor = maxCogsMinor - pkgCost.minorUnits;
    if (materialBudgetMinor <= 0) {
      throw ArgumentError(
          'Biaya kemasan terlalu tinggi melebihi batas modal target margin.');
    }

    // 4. Hitung Berat Gram per Bungkus = Anggaran Bahan / Cost per Gram
    final weightInGrams = materialBudgetMinor ~/ costPerGramMinor;

    // 5. Hitung Estimasi Bungkus per Kg (1.000 gram / weightInGrams)
    final portionsPerKg = 1000 ~/ weightInGrams;

    return PortionCalculationResult(
      productId: productId,
      targetSellingPrice: targetSellingPrice,
      targetMarginPercentage: targetMarginPercentage,
      packagingCostPerUnit: pkgCost,
      materialUnitCostPerGram: materialCostPerGram,
      recommendedWeightPerPortionInGrams:
          Quantity(value: weightInGrams, scale: 0),
      totalPortionsPerKg: portionsPerKg,
    );
  }
}
