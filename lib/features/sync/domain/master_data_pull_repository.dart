import 'master_data_pull.dart';

/// Hasil upsert master data pull.
class MasterDataUpsertResult {
  final int uomsUpserted;
  final int categoriesUpserted;
  final int productsUpserted;

  /// Produk yang dilewati karena UoM-nya tidak dikenal (tidak ada
  /// padanan Unit lokal).
  final int productsSkipped;

  const MasterDataUpsertResult({
    required this.uomsUpserted,
    required this.categoriesUpserted,
    required this.productsUpserted,
    required this.productsSkipped,
  });
}

/// Persistensi master data hasil pull ke database lokal (upsert).
abstract interface class MasterDataPullRepository {
  Future<MasterDataUpsertResult> upsert(MasterDataPull pull);
}
