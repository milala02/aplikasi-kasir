import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class PortionCalculationResult {
  final String productId;
  final Money targetSellingPrice;
  final double targetMarginPercentage;
  final Money packagingCostPerUnit;
  final Money materialUnitCostPerGram;
  
  /// Berat takaran bahan per bungkus dalam Gram
  final Quantity recommendedWeightPerPortionInGrams;
  
  /// Estimasi jumlah bungkus yang dihasilkan per kg bahan
  final int totalPortionsPerKg;

  PortionCalculationResult({
    required this.productId,
    required this.targetSellingPrice,
    required this.targetMarginPercentage,
    required this.packagingCostPerUnit,
    required this.materialUnitCostPerGram,
    required this.recommendedWeightPerPortionInGrams,
    required this.totalPortionsPerKg,
  });

  /// Modal aktual per bungkus (Bahan + Plastik)
  Money get cogsPerPortion {
    final matCostMinor = materialUnitCostPerGram.minorUnits * recommendedWeightPerPortionInGrams.value;
    return Money(
      minorUnits: matCostMinor + packagingCostPerUnit.minorUnits,
      currency: targetSellingPrice.currency,
    );
  }

  /// Estimasi keuntungan kotor per bungkus
  Money get profitPerPortion => Money(
        minorUnits: targetSellingPrice.minorUnits - cogsPerPortion.minorUnits,
        currency: targetSellingPrice.currency,
      );
}
