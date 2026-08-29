import '../../../core/errors/domain_error.dart';
import '../../../core/money/money.dart';
import '../../../core/result/result.dart';
import '../../products/domain/product_repository.dart';
import '../../recipes/domain/recipe.dart';
import '../domain/production_batch.dart';
import 'process_production_batch_use_case.dart';
import 'record_production_output_use_case.dart';

/// Orchestrasi produksi: Recipe → konsumsi bahan FIFO (HPP) → catat output.
///
/// Guard SEBELUM konsumsi apa pun:
/// - recipe wajib punya outputProductId (Product nyata);
/// - output hanya dicatat setelah ProcessProductionBatchUseCase sukses.
/// Setiap pemanggilan = satu batch baru (batchId unik per eksekusi);
/// double-tap dicegah oleh UI (busy) — batch tidak dipersist.
class ExecuteProductionUseCase {
  final ProcessProductionBatchUseCase processBatchUseCase;
  final RecordProductionOutputUseCase recordOutputUseCase;
  final ProductRepository productRepository;

  ExecuteProductionUseCase({
    required this.processBatchUseCase,
    required this.recordOutputUseCase,
    required this.productRepository,
  });

  Future<Result<ProductionBatch>> execute({
    required Recipe recipe,
    required String batchNumber,
    Money? additionalProductionCost,
  }) async {
    final outputProductId = recipe.outputProductId;
    if (outputProductId == null || outputProductId.isEmpty) {
      return const Failure(
        DomainError(
          code: 'RECIPE_NO_OUTPUT',
          message: 'Resep tidak memiliki produk hasil; tidak dapat '
              'diproduksi.',
        ),
      );
    }

    if (productRepository.getById(outputProductId) == null) {
      return Failure(
        DomainError(
          code: 'INVALID_OUTPUT_PRODUCT',
          message: 'Produk hasil tidak ditemukan: $outputProductId.',
        ),
      );
    }

    final batchId = 'batch_${DateTime.now().millisecondsSinceEpoch}';
    final batchResult = await processBatchUseCase.execute(
      batchId: batchId,
      batchNumber: batchNumber,
      recipe: recipe,
      producedAt: DateTime.now(),
      additionalProductionCost: additionalProductionCost,
    );

    if (batchResult is Failure<ProductionBatch>) {
      // Bahan tidak dikonsumsi sepenuhnya (validation-before-mutation) —
      // tidak ada output yang dicatat.
      return batchResult;
    }

    final batch = (batchResult as Success<ProductionBatch>).value;

    final outputResult = await recordOutputUseCase.execute(
      batch: batch,
      productId: outputProductId,
    );
    if (outputResult is Failure) {
      return Failure(outputResult.error);
    }

    return Success(batch);
  }
}
