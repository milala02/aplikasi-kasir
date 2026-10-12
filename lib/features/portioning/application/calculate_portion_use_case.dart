import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

import '../../inventory/domain/cost_layer_repository.dart';
import '../domain/portion_calculation_result.dart';
import '../domain/portion_calculation_exception.dart';

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
      throw const PortionCalculationException(
        'Target margin harus lebih dari 0% dan kurang dari 100%.',
      );
    }

    final pkgCost =
        packagingCostPerUnit ?? const Money(minorUnits: 0, currency: 'IDR');

    // 1. Ambil modal bahan rata-rata / FIFO layer dari Inventory
    final availableLayers =
        await costLayerRepository.getAvailableByProductId(productId);
    if (availableLayers.isEmpty) {
      throw const PortionCalculationException(
        'Produk belum punya stok/cost layer — catat penerimaan dulu.',
      );
    }

    // Mengambil HPP/Cost per gram dari layer FIFO tertua
    final activeLayer = availableLayers.first;

    // unitCost adalah per base unit sesuai scale layer (scale=0: per gram, scale=3: per kg, dll)
    // Konversi ke cost per gram: unitCost / (10^scale)
    final layerScale = activeLayer.remainingQuantity.scale;
    final scaleFactor = Quantity.factor(layerScale); // 10^scale
    final costPerGramMinor = activeLayer.unitCost.minorUnits ~/ scaleFactor;
    if (costPerGramMinor <= 0) {
      throw PortionCalculationException(
        'Harga beli bahan tidak valid (nol atau terlalu kecil). '
        'Periksa harga beli pada layer stok produk ini.',
        technicalDetails:
            'unitCost=${activeLayer.unitCost.minorUnits}, scale=$layerScale',
      );
    }
    final materialCostPerGram = Money(
        minorUnits: costPerGramMinor, currency: activeLayer.unitCost.currency);

    // 2. Hitung Batas Maksimal Modal per Bungkus (COGS = Price * (1 - Margin))
    final maxCogsMinor =
        (targetSellingPrice.minorUnits * (1.0 - targetMarginPercentage))
            .round();

    // 3. Hitung Anggaran Bahan per Bungkus = COGS - Biaya Kemasan
    final materialBudgetMinor = maxCogsMinor - pkgCost.minorUnits;
    if (materialBudgetMinor <= 0) {
      throw const PortionCalculationException(
        'Biaya kemasan terlalu tinggi melebihi batas modal target margin.',
      );
    }

    // 4. Hitung Berat Gram per Bungkus = Anggaran Bahan / Cost per Gram
    final weightInGrams = materialBudgetMinor ~/ costPerGramMinor;
    if (weightInGrams <= 0) {
      final hargaJualRp = targetSellingPrice.minorUnits ~/ 100;
      final budgetRp = materialBudgetMinor ~/ 100;
      final perGramRp = costPerGramMinor / 100;
      throw PortionCalculationException(
        'Harga jual Rp $hargaJualRp terlalu rendah. '
        'Anggaran bahan Rp $budgetRp tidak cukup untuk membeli 1 gram '
        '(Rp ${perGramRp.toStringAsFixed(2)}/gram). '
        'Naikkan harga jual atau turunkan biaya kemasan.',
        technicalDetails:
            'budget=$materialBudgetMinor, costPerGram=$costPerGramMinor',
      );
    }

    // 5. Hitung Estimasi Bungkus per Kg (1.000 gram / weightInGrams)
    // weightInGrams sudah dalam gram (scale=0), jadi 1kg = 1000 gram
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
