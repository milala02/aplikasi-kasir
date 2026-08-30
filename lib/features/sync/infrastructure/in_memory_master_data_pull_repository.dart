import '../domain/master_data_pull.dart';
import '../domain/master_data_pull_repository.dart';

/// Implementasi in-memory untuk unit test (mencatat pull terakhir).
class InMemoryMasterDataPullRepository implements MasterDataPullRepository {
  MasterDataPull? lastUpsert;

  @override
  Future<MasterDataUpsertResult> upsert(MasterDataPull pull) async {
    lastUpsert = pull;
    return MasterDataUpsertResult(
      uomsUpserted: pull.uoms.length,
      categoriesUpserted: pull.categories.length,
      productsUpserted: pull.products.length,
      productsSkipped: 0,
    );
  }
}
