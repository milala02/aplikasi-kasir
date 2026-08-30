import '../domain/product.dart';
import '../domain/product_repository.dart';
import '../domain/product_service.dart';
import '../../../core/money/money.dart';
import '../../sync/application/sync_enqueue_service.dart';

class ProductUseCases {
  final ProductRepository repository;
  final ProductService service;
  final SyncEnqueueService? syncEnqueueService;

  const ProductUseCases({
    required this.repository,
    this.service = const ProductService(),
    this.syncEnqueueService,
  });

  Product? getById(String id) {
    return repository.getById(id);
  }

  Product? getBySku(String sku) {
    return repository.getBySku(sku);
  }

  List<Product> getAll() {
    return repository.getAll();
  }

  List<Product> getActive() {
    return repository.getActive();
  }

  Future<void> create(Product product) async {
    if (repository.getById(product.id) != null) {
      throw ArgumentError('Product ID already exists.');
    }

    if (repository.getBySku(product.sku) != null) {
      throw ArgumentError('Product SKU already exists.');
    }

    await repository.save(product);

    await syncEnqueueService?.enqueue(
      referenceId: product.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'product',
      payload: SyncEnqueueService.productPayload(product),
    );
  }

  Future<void> updatePrices({
    required String productId,
    required Money purchasePrice,
    required Money sellingPrice,
  }) async {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    final updated = service.updatePrices(
      product: product,
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
    );
    await repository.update(updated);

    await syncEnqueueService?.enqueue(
      referenceId: product.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'product',
      payload: SyncEnqueueService.productPayload(updated),
    );
  }

  Future<void> activate(String productId) async {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    final updated = service.activate(product);
    await repository.update(updated);

    await syncEnqueueService?.enqueue(
      referenceId: product.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'product',
      payload: SyncEnqueueService.productPayload(updated),
    );
  }

  Future<void> deactivate(String productId) async {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    final updated = service.deactivate(product);
    await repository.update(updated);

    await syncEnqueueService?.enqueue(
      referenceId: product.id,
      endpoint: '/api/v1/sync/push',
      sourceTable: 'product',
      payload: SyncEnqueueService.productPayload(updated),
    );
  }

  Future<void> delete(String productId) async {
    if (repository.getById(productId) == null) {
      throw ArgumentError('Product not found.');
    }

    await repository.deleteById(productId);
  }
}
