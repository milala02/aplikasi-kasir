/// Payload master data hasil pull dari backend (`GET /api/v1/sync/pull`),
/// sesuai `domain.SyncPullPayload` backend Go (camelCase).
class MasterDataPull {
  final List<PulledProduct> products;
  final List<PulledCategory> categories;
  final List<PulledUom> uoms;

  const MasterDataPull({
    required this.products,
    required this.categories,
    required this.uoms,
  });

  factory MasterDataPull.fromJson(Map<String, dynamic> json) {
    if (json['products'] is! List ||
        json['categories'] is! List ||
        json['uoms'] is! List) {
      throw const FormatException(
          'Payload pull tidak valid: wajib memuat products, categories, uoms.');
    }
    return MasterDataPull(
      products: [
        for (final item in json['products'] as List)
          PulledProduct.fromJson(item as Map<String, dynamic>),
      ],
      categories: [
        for (final item in json['categories'] as List)
          PulledCategory.fromJson(item as Map<String, dynamic>),
      ],
      uoms: [
        for (final item in json['uoms'] as List)
          PulledUom.fromJson(item as Map<String, dynamic>),
      ],
    );
  }
}

class PulledProduct {
  final String id;
  final String sku;
  final String name;
  final String stockUomId;
  final String? categoryId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PulledProduct({
    required this.id,
    required this.sku,
    required this.name,
    required this.stockUomId,
    required this.categoryId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PulledProduct.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final sku = json['sku'];
    final name = json['name'];
    final stockUomId = json['stockUomId'];
    if (id is! String ||
        sku is! String ||
        name is! String ||
        stockUomId is! String) {
      throw const FormatException('Payload product pull tidak valid.');
    }
    return PulledProduct(
      id: id,
      sku: sku,
      name: name,
      stockUomId: stockUomId,
      categoryId: json['categoryId'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class PulledCategory {
  final String id;
  final String name;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PulledCategory({
    required this.id,
    required this.name,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PulledCategory.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! String || name is! String) {
      throw const FormatException('Payload category pull tidak valid.');
    }
    return PulledCategory(
      id: id,
      name: name,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class PulledUom {
  final String id;
  final String name;
  final String symbol;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PulledUom({
    required this.id,
    required this.name,
    required this.symbol,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PulledUom.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final symbol = json['symbol'];
    if (id is! String || name is! String || symbol is! String) {
      throw const FormatException('Payload uom pull tidak valid.');
    }
    return PulledUom(
      id: id,
      name: name,
      symbol: symbol,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
