import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class MaterialCostAllocation {
  final String costLayerId;
  final String productId;
  final Quantity quantityConsumed;
  final Money unitCost;

  MaterialCostAllocation({
    required this.costLayerId,
    required this.productId,
    required this.quantityConsumed,
    required this.unitCost,
  }) {
    if (costLayerId.isEmpty) throw ArgumentError('Cost layer ID cannot be empty.');
    if (productId.isEmpty) throw ArgumentError('Product ID cannot be empty.');
    if (quantityConsumed.isZero) throw ArgumentError('Quantity consumed cannot be zero.');
  }

  Money get totalCost => Money(
        minorUnits: (unitCost.minorUnits * quantityConsumed.value) ~/
            _scaleFactor(quantityConsumed.scale),
        currency: unitCost.currency,
      );

  static int _scaleFactor(int scale) {
    var result = 1;
    for (var i = 0; i < scale; i++) result *= 10;
    return result;
  }
}

class ProductionBatch {
  final String id;
  final String recipeId;
  final String batchNumber;
  final DateTime producedAt;
  final List<MaterialCostAllocation> allocations;
  final Money additionalProductionCost;
  final Quantity actualOutputQuantity;

  ProductionBatch({
    required this.id,
    required this.recipeId,
    required this.batchNumber,
    required this.producedAt,
    required this.allocations,
    Money? additionalProductionCost,
    required this.actualOutputQuantity,
  })  : additionalProductionCost = additionalProductionCost ??
            const Money(minorUnits: 0, currency: 'IDR') {
    if (id.isEmpty) throw ArgumentError('Batch ID cannot be empty.');
    if (recipeId.isEmpty) throw ArgumentError('Recipe ID cannot be empty.');
    if (batchNumber.isEmpty) throw ArgumentError('Batch number cannot be empty.');
    if (allocations.isEmpty) throw ArgumentError('Allocations cannot be empty.');
    if (actualOutputQuantity.isZero) {
      throw ArgumentError('Actual output quantity cannot be zero.');
    }
  }

  /// Total Material Cost dari seluruh konsumsi FIFO Layer
  Money get totalMaterialCost {
    var totalMinor = 0;
    final currency = allocations.first.unitCost.currency;
    for (final alloc in allocations) {
      totalMinor += alloc.totalCost.minorUnits;
    }
    return Money(minorUnits: totalMinor, currency: currency);
  }

  /// Total HPP Batch = Material Cost + Biaya Tambahan
  Money get totalBatchCost => Money(
        minorUnits: totalMaterialCost.minorUnits + additionalProductionCost.minorUnits,
        currency: totalMaterialCost.currency,
      );

  /// HPP per Satuan Hasil Produksi (per kg/gram)
  Money get unitCost {
    final scaleDiv = _scaleFactor(actualOutputQuantity.scale);
    final totalMinor = totalBatchCost.minorUnits;
    final unitMinor = (totalMinor * scaleDiv) ~/ actualOutputQuantity.value;
    return Money(minorUnits: unitMinor, currency: totalBatchCost.currency);
  }

  static int _scaleFactor(int scale) {
    var result = 1;
    for (var i = 0; i < scale; i++) result *= 10;
    return result;
  }
}
