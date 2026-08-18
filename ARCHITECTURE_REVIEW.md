# APLIKASI KASIR — ARCHITECTURE REVIEW BUNDLE

## PROJECT STRUCTURE
lib/core/errors/domain_error.dart
lib/core/money/money.dart
lib/core/quantity/quantity.dart
lib/core/result/result.dart
lib/core/unit/unit.dart
lib/features/cart/application/cart_use_cases.dart
lib/features/cart/domain/cart.dart
lib/features/cart/domain/cart_item.dart
lib/features/cart/domain/cart_repository.dart
lib/features/cart/infrastructure/in_memory_cart_repository.dart
lib/features/inventory/application/inventory_use_cases.dart
lib/features/inventory/domain/inventory_repository.dart
lib/features/inventory/domain/inventory_service.dart
lib/features/inventory/domain/stock_ledger.dart
lib/features/inventory/domain/stock_movement.dart
lib/features/inventory/infrastructure/in_memory_inventory_repository.dart
lib/features/products/application/product_use_cases.dart
lib/features/products/domain/product.dart
lib/features/products/domain/product_repository.dart
lib/features/products/domain/product_service.dart
lib/features/products/domain/unit_conversion.dart
lib/features/products/infrastructure/in_memory_product_repository.dart
lib/features/purchasing/domain/cost_layer.dart
lib/features/purchasing/domain/cost_layer_repository.dart
lib/features/purchasing/domain/cost_layer_service.dart
lib/features/purchasing/domain/purchase.dart
lib/features/purchasing/domain/purchase_item.dart
lib/features/purchasing/domain/purchase_repository.dart
lib/features/purchasing/infrastructure/in_memory_cost_layer_repository.dart
lib/features/purchasing/infrastructure/in_memory_purchase_repository.dart
lib/features/sales/application/sale_use_cases.dart
lib/features/sales/domain/sale.dart
lib/features/sales/domain/sale_item.dart
lib/features/sales/domain/sale_repository.dart
lib/features/sales/domain/sale_service.dart
lib/features/sales/infrastructure/in_memory_sale_repository.dart
lib/main.dart

## PUBSPEC
name: aplikasi_kasir

description: >
  Warung Pintar - aplikasi manajemen warung,
  kasir, inventory, keuangan, budgeting,
  accounting, dan analytics.

publish_to: "none"

version: 0.1.0+1

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true


============================================================
FILE: lib/core/money/money.dart
============================================================
class Money {
  final int minorUnits;
  final String currency;

  const Money({
    required this.minorUnits,
    required this.currency,
  });

  Money add(Money other) {
    _ensureSameCurrency(other);

    return Money(
      minorUnits: minorUnits + other.minorUnits,
      currency: currency,
    );
  }

  Money subtract(Money other) {
    _ensureSameCurrency(other);

    return Money(
      minorUnits: minorUnits - other.minorUnits,
      currency: currency,
    );
  }

  Money multiply(int multiplier) {
    return Money(
      minorUnits: minorUnits * multiplier,
      currency: currency,
    );
  }

  bool get isNegative => minorUnits < 0;

  bool get isZero => minorUnits == 0;

  bool get isPositive => minorUnits > 0;

  void _ensureSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Currency mismatch: $currency vs ${other.currency}',
      );
    }
  }

  @override
  bool operator ==(Object other) {
    return other is Money &&
        other.minorUnits == minorUnits &&
        other.currency == currency;
  }

  @override
  int get hashCode => Object.hash(minorUnits, currency);

  @override
  String toString() {
    return '$currency $minorUnits';
  }
}

============================================================
FILE: lib/core/quantity/quantity.dart
============================================================
class Quantity {
  final int value;
  final int scale;

  const Quantity._({
    required this.value,
    required this.scale,
  });

  factory Quantity({
    required int value,
    int scale = 0,
  }) {
    if (scale < 0) {
      throw ArgumentError.value(
        scale,
        'scale',
        'Scale cannot be negative.',
      );
    }

    if (value < 0) {
      throw ArgumentError.value(
        value,
        'value',
        'Quantity cannot be negative.',
      );
    }

    return Quantity._(
      value: value,
      scale: scale,
    );
  }

  static Quantity zero({int scale = 0}) {
    return Quantity(
      value: 0,
      scale: scale,
    );
  }

  double get asDouble => value / _factor(scale);

  bool get isZero => value == 0;

  bool get isPositive => value > 0;

  Quantity add(Quantity other) {
    final commonScale = scale > other.scale ? scale : other.scale;

    final left = _scaleTo(commonScale);
    final right = other._scaleTo(commonScale);

    return Quantity._(
      value: left + right,
      scale: commonScale,
    );
  }

  Quantity subtract(Quantity other) {
    final commonScale = scale > other.scale ? scale : other.scale;

    final left = _scaleTo(commonScale);
    final right = other._scaleTo(commonScale);

    final result = left - right;

    if (result < 0) {
      throw ArgumentError(
        'Quantity cannot become negative.',
      );
    }

    return Quantity._(
      value: result,
      scale: commonScale,
    );
  }

  Quantity multiply(int multiplier) {
    if (multiplier < 0) {
      throw ArgumentError.value(
        multiplier,
        'multiplier',
        'Multiplier cannot be negative.',
      );
    }

    return Quantity._(
      value: value * multiplier,
      scale: scale,
    );
  }

  int _scaleTo(int targetScale) {
    if (targetScale == scale) {
      return value;
    }

    final difference = targetScale - scale;

    return value * _factor(difference);
  }

  static int _factor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }

  @override
  bool operator ==(Object other) {
    return other is Quantity &&
        other.value == value &&
        other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(value, scale);

  @override
  String toString() {
    return 'Quantity(value: $value, scale: $scale)';
  }
}

============================================================
FILE: lib/features/products/domain/product.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/unit/unit.dart';

class Product {
  final String id;
  final String sku;
  final String name;
  final Unit baseUnit;
  final Money purchasePrice;
  final Money sellingPrice;
  final bool active;

  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.baseUnit,
    required this.purchasePrice,
    required this.sellingPrice,
    this.active = true,
  });

  Product copyWith({
    String? id,
    String? sku,
    String? name,
    Unit? baseUnit,
    Money? purchasePrice,
    Money? sellingPrice,
    bool? active,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      baseUnit: baseUnit ?? this.baseUnit,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      active: active ?? this.active,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Product('
        'id: $id, '
        'sku: $sku, '
        'name: $name, '
        'baseUnit: $baseUnit, '
        'purchasePrice: $purchasePrice, '
        'sellingPrice: $sellingPrice, '
        'active: $active'
        ')';
  }
}

============================================================
FILE: lib/features/products/domain/product_repository.dart
============================================================
import 'product.dart';

abstract interface class ProductRepository {
  Product? getById(String id);

  Product? getBySku(String sku);

  List<Product> getAll();

  List<Product> getActive();

  void save(Product product);

  void update(Product product);

  void deleteById(String id);
}

============================================================
FILE: lib/features/products/domain/product_service.dart
============================================================
import '../../../core/money/money.dart';
import 'product.dart';

class ProductService {
  const ProductService();

  Product updatePrices({
    required Product product,
    required Money purchasePrice,
    required Money sellingPrice,
  }) {
    return product.copyWith(
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
    );
  }

  Product activate(Product product) {
    return product.copyWith(active: true);
  }

  Product deactivate(Product product) {
    return product.copyWith(active: false);
  }
}

============================================================
FILE: lib/features/products/domain/unit_conversion.dart
============================================================
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';

class UnitConversion {
  final Unit from;
  final Unit to;
  final int multiplier;
  final int divisor;

  UnitConversion({
    required this.from,
    required this.to,
    this.multiplier = 1,
    this.divisor = 1,
  }) {
    if (from == to) {
      throw ArgumentError(
        'Source and target units must be different.',
      );
    }

    if (multiplier <= 0) {
      throw ArgumentError.value(
        multiplier,
        'multiplier',
        'Multiplier must be greater than zero.',
      );
    }

    if (divisor <= 0) {
      throw ArgumentError.value(
        divisor,
        'divisor',
        'Divisor must be greater than zero.',
      );
    }
  }

  Quantity convert(Quantity quantity) {
    if (quantity.isZero) {
      return Quantity.zero(
        scale: quantity.scale,
      );
    }

    final numerator = quantity.value * multiplier;

    if (numerator % divisor != 0) {
      throw ArgumentError(
        'Conversion produces a non-exact quantity.',
      );
    }

    return Quantity(
      value: numerator ~/ divisor,
      scale: quantity.scale,
    );
  }

  UnitConversion reverse() {
    return UnitConversion(
      from: to,
      to: from,
      multiplier: divisor,
      divisor: multiplier,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UnitConversion &&
        other.from == from &&
        other.to == to &&
        other.multiplier == multiplier &&
        other.divisor == divisor;
  }

  @override
  int get hashCode {
    return Object.hash(
      from,
      to,
      multiplier,
      divisor,
    );
  }

  @override
  String toString() {
    return 'UnitConversion('
        'from: $from, '
        'to: $to, '
        'multiplier: $multiplier, '
        'divisor: $divisor'
        ')';
  }
}

============================================================
FILE: lib/features/products/application/product_use_cases.dart
============================================================
import '../domain/product.dart';
import '../domain/product_repository.dart';
import '../domain/product_service.dart';
import '../../../core/money/money.dart';

class ProductUseCases {
  final ProductRepository repository;
  final ProductService service;

  const ProductUseCases({
    required this.repository,
    this.service = const ProductService(),
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

  void create(Product product) {
    if (repository.getById(product.id) != null) {
      throw ArgumentError('Product ID already exists.');
    }

    if (repository.getBySku(product.sku) != null) {
      throw ArgumentError('Product SKU already exists.');
    }

    repository.save(product);
  }

  void updatePrices({
    required String productId,
    required Money purchasePrice,
    required Money sellingPrice,
  }) {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    repository.update(
      service.updatePrices(
        product: product,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
      ),
    );
  }

  void activate(String productId) {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    repository.update(service.activate(product));
  }

  void deactivate(String productId) {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    repository.update(service.deactivate(product));
  }

  void delete(String productId) {
    if (repository.getById(productId) == null) {
      throw ArgumentError('Product not found.');
    }

    repository.deleteById(productId);
  }
}

============================================================
FILE: lib/features/products/infrastructure/in_memory_product_repository.dart
============================================================
import '../domain/product.dart';
import '../domain/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  final Map<String, Product> _products = {};

  @override
  Product? getById(String id) => _products[id];

  @override
  Product? getBySku(String sku) {
    for (final product in _products.values) {
      if (product.sku == sku) {
        return product;
      }
    }

    return null;
  }

  @override
  List<Product> getAll() {
    return List.unmodifiable(_products.values);
  }

  @override
  List<Product> getActive() {
    return List.unmodifiable(
      _products.values.where((product) => product.active),
    );
  }

  @override
  void save(Product product) {
    if (_products.containsKey(product.id)) {
      throw ArgumentError('Product ID already exists.');
    }

    if (getBySku(product.sku) != null) {
      throw ArgumentError('Product SKU already exists.');
    }

    _products[product.id] = product;
  }

  @override
  void update(Product product) {
    if (!_products.containsKey(product.id)) {
      throw ArgumentError('Product not found.');
    }

    final existingSkuOwner = getBySku(product.sku);

    if (existingSkuOwner != null && existingSkuOwner.id != product.id) {
      throw ArgumentError('Product SKU already exists.');
    }

    _products[product.id] = product;
  }

  @override
  void deleteById(String id) {
    _products.remove(id);
  }
}

============================================================
FILE: lib/features/cart/domain/cart.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import 'cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({
    this.items = const [],
  }) {
    final seenProductIds = <String>{};

    for (final item in items) {
      if (!seenProductIds.add(item.product.id)) {
        throw ArgumentError(
          'Cart cannot contain duplicate products.',
        );
      }
    }
  }

  Money? get subtotal {
    if (items.isEmpty) {
      return null;
    }

    var result = Money(
      minorUnits: 0,
      currency: items.first.unitPrice.currency,
    );

    for (final item in items) {
      result = result.add(item.subtotal);
    }

    return result;
  }

  Cart addItem(CartItem item) {
    final index = items.indexWhere(
      (existing) => existing.product.id == item.product.id,
    );

    if (index == -1) {
      return Cart(
        items: [
          ...items,
          item,
        ],
      );
    }

    final existing = items[index];

    final mergedQuantity = existing.quantity.add(item.quantity);

    final updatedItem = existing.copyWith(
      quantity: mergedQuantity,
    );

    final updatedItems = [
      ...items,
    ];

    updatedItems[index] = updatedItem;

    return Cart(
      items: updatedItems,
    );
  }

  Cart removeProduct(String productId) {
    return Cart(
      items: items
          .where((item) => item.product.id != productId)
          .toList(),
    );
  }

  Cart updateQuantity({
    required String productId,
    required Quantity quantity,
  }) {
    if (quantity.isZero) {
      throw ArgumentError(
        'Cart item quantity must be greater than zero.',
      );
    }

    final index = items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) {
      throw ArgumentError(
        'Product is not present in cart.',
      );
    }

    final updatedItems = [
      ...items,
    ];

    updatedItems[index] = updatedItems[index].copyWith(
      quantity: quantity,
    );

    return Cart(
      items: updatedItems,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Cart || other.items.length != items.length) {
      return false;
    }

    for (var i = 0; i < items.length; i++) {
      if (other.items[i] != items[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(items);

  @override
  String toString() => 'Cart(items: $items)';
}

============================================================
FILE: lib/features/cart/domain/cart_item.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../products/domain/product.dart';

class CartItem {
  final Product product;
  final Quantity quantity;
  final Money unitPrice;

  CartItem({
    required this.product,
    required this.quantity,
    Money? unitPrice,
  }) : unitPrice = unitPrice ?? product.sellingPrice {
    if (quantity.isZero) {
      throw ArgumentError(
        'Cart item quantity must be greater than zero.',
      );
    }

    if (unitPrice != product.sellingPrice &&
        this.unitPrice.currency != product.sellingPrice.currency) {
      throw ArgumentError(
        'Cart item price currency must match product currency.',
      );
    }

    if (this.unitPrice.isNegative) {
      throw ArgumentError(
        'Cart item unit price cannot be negative.',
      );
    }
  }

  Money get subtotal => unitPrice.multiply(quantity.value);

  CartItem copyWith({
    Product? product,
    Quantity? quantity,
    Money? unitPrice,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode => Object.hash(
        product,
        quantity,
        unitPrice,
      );

  @override
  String toString() {
    return 'CartItem('
        'product: $product, '
        'quantity: $quantity, '
        'unitPrice: $unitPrice'
        ')';
  }
}

============================================================
FILE: lib/features/cart/domain/cart_repository.dart
============================================================
import 'cart.dart';

abstract interface class CartRepository {
  Cart? getById(String id);

  List<Cart> getAll();

  void save(String id, Cart cart);

  void update(String id, Cart cart);

  void deleteById(String id);
}

============================================================
FILE: lib/features/cart/application/cart_use_cases.dart
============================================================
import '../domain/cart.dart';
import '../domain/cart_item.dart';
import '../domain/cart_repository.dart';
import '../../../core/quantity/quantity.dart';

class CartUseCases {
  final CartRepository repository;

  const CartUseCases({
    required this.repository,
  });

  Cart createCart(String cartId) {
    _validateCartId(cartId);

    final cart = Cart();

    repository.save(cartId, cart);

    return cart;
  }

  Cart? getCart(String cartId) {
    _validateCartId(cartId);

    return repository.getById(cartId);
  }

  List<Cart> getAllCarts() {
    return repository.getAll();
  }

  Cart addItem({
    required String cartId,
    required CartItem item,
  }) {
    _validateCartId(cartId);

    final cart = repository.getById(cartId);

    if (cart == null) {
      throw ArgumentError(
        'Cart is not present.',
      );
    }

    final updated = cart.addItem(item);

    repository.update(cartId, updated);

    return updated;
  }

  Cart removeProduct({
    required String cartId,
    required String productId,
  }) {
    _validateCartId(cartId);

    if (productId.isEmpty) {
      throw ArgumentError(
        'Product ID cannot be empty.',
      );
    }

    final cart = repository.getById(cartId);

    if (cart == null) {
      throw ArgumentError(
        'Cart is not present.',
      );
    }

    final updated = cart.removeProduct(productId);

    repository.update(cartId, updated);

    return updated;
  }

  Cart updateQuantity({
    required String cartId,
    required String productId,
    required Quantity quantity,
  }) {
    _validateCartId(cartId);

    if (productId.isEmpty) {
      throw ArgumentError(
        'Product ID cannot be empty.',
      );
    }

    final cart = repository.getById(cartId);

    if (cart == null) {
      throw ArgumentError(
        'Cart is not present.',
      );
    }

    final updated = cart.updateQuantity(
      productId: productId,
      quantity: quantity,
    );

    repository.update(cartId, updated);

    return updated;
  }

  void deleteCart(String cartId) {
    _validateCartId(cartId);

    repository.deleteById(cartId);
  }

  void _validateCartId(String cartId) {
    if (cartId.isEmpty) {
      throw ArgumentError(
        'Cart ID cannot be empty.',
      );
    }
  }
}

============================================================
FILE: lib/features/cart/infrastructure/in_memory_cart_repository.dart
============================================================
import '../domain/cart.dart';
import '../domain/cart_repository.dart';

class InMemoryCartRepository implements CartRepository {
  final Map<String, Cart> _carts = {};

  @override
  Cart? getById(String id) => _carts[id];

  @override
  List<Cart> getAll() {
    return List.unmodifiable(_carts.values);
  }

  @override
  void save(String id, Cart cart) {
    if (id.isEmpty) {
      throw ArgumentError('Cart ID cannot be empty.');
    }

    if (_carts.containsKey(id)) {
      throw ArgumentError('Cart ID already exists.');
    }

    _carts[id] = cart;
  }

  @override
  void update(String id, Cart cart) {
    if (id.isEmpty) {
      throw ArgumentError('Cart ID cannot be empty.');
    }

    if (!_carts.containsKey(id)) {
      throw ArgumentError('Cart not found.');
    }

    _carts[id] = cart;
  }

  @override
  void deleteById(String id) {
    _carts.remove(id);
  }
}

============================================================
FILE: lib/features/inventory/domain/inventory_repository.dart
============================================================
import 'stock_ledger.dart';
import 'stock_movement.dart';

abstract interface class InventoryRepository {
  StockLedger? getLedger(String productId);

  List<StockMovement> getMovements(String productId);

  void saveLedger(StockLedger ledger);

  void recordMovement(StockMovement movement);
}

============================================================
FILE: lib/features/inventory/domain/inventory_service.dart
============================================================
import '../../../core/quantity/quantity.dart';
import 'stock_ledger.dart';
import 'stock_movement.dart';

class InventoryService {
  final StockLedger ledger;

  const InventoryService({
    required this.ledger,
  });

  Quantity get balance => ledger.calculateBalance();

  InventoryService receiveStock({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.purchase,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService sellStock({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.sale,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService adjustStockIncrease({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.adjustmentIncrease,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService adjustStockDecrease({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.adjustmentDecrease,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService recordDamage({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.damage,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService returnStockIn({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.returnIn,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService returnStockOut({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.returnOut,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService _recordMovement({
    required String movementId,
    required Quantity quantity,
    required StockMovementType type,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final movement = StockMovement(
      id: movementId,
      productId: ledger.productId,
      quantity: quantity,
      type: type,
      referenceId: referenceId,
      occurredAt: occurredAt,
    );

    return InventoryService(
      ledger: ledger.addMovement(movement),
    );
  }
}

============================================================
FILE: lib/features/inventory/domain/stock_ledger.dart
============================================================
import '../../../core/quantity/quantity.dart';
import 'stock_movement.dart';

class StockLedger {
  final String productId;
  final List<StockMovement> movements;

  StockLedger({
    required this.productId,
    this.movements = const [],
  }) {
    if (productId.isEmpty) {
      throw ArgumentError(
        'Stock ledger product ID cannot be empty.',
      );
    }
  }

  Quantity calculateBalance() {
    if (movements.isEmpty) {
      return Quantity.zero();
    }

    var balance = Quantity.zero(
      scale: movements.first.quantity.scale,
    );

    for (final movement in movements) {
      if (movement.productId != productId) {
        throw ArgumentError(
          'Stock movement product does not match ledger product.',
        );
      }

      if (movement.isIncrease) {
        balance = balance.add(movement.quantity);
      } else {
        balance = balance.subtract(movement.quantity);
      }
    }

    return balance;
  }

  StockLedger addMovement(StockMovement movement) {
    if (movement.productId != productId) {
      throw ArgumentError(
        'Stock movement product does not match ledger product.',
      );
    }

    if (movement.quantity.isZero) {
      throw ArgumentError(
        'Stock movement quantity cannot be zero.',
      );
    }

    if (movements.any((existing) => existing.id == movement.id)) {
      throw ArgumentError(
        'Stock movement ID already exists.',
      );
    }

    if (!movement.isIncrease) {
      final currentBalance = calculateBalance();
      currentBalance.subtract(movement.quantity);
    }

    return StockLedger(
      productId: productId,
      movements: [
        ...movements,
        movement,
      ],
    );
  }
}

============================================================
FILE: lib/features/inventory/domain/stock_movement.dart
============================================================
import '../../../core/quantity/quantity.dart';

enum StockMovementType {
  purchase,
  sale,
  adjustmentIncrease,
  adjustmentDecrease,
  damage,
  returnIn,
  returnOut,
}

class StockMovement {
  final String id;
  final String productId;
  final Quantity quantity;
  final StockMovementType type;
  final String? referenceId;
  final DateTime occurredAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.type,
    required this.occurredAt,
    this.referenceId,
  }) {
    if (id.isEmpty) {
      throw ArgumentError(
        'Stock movement ID cannot be empty.',
      );
    }

    if (productId.isEmpty) {
      throw ArgumentError(
        'Stock movement product ID cannot be empty.',
      );
    }

    if (quantity.isZero) {
      throw ArgumentError(
        'Stock movement quantity cannot be zero.',
      );
    }
  }

  bool get isIncrease {
    switch (type) {
      case StockMovementType.purchase:
      case StockMovementType.adjustmentIncrease:
      case StockMovementType.returnIn:
        return true;

      case StockMovementType.sale:
      case StockMovementType.adjustmentDecrease:
      case StockMovementType.damage:
      case StockMovementType.returnOut:
        return false;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is StockMovement &&
        other.id == id &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.type == type &&
        other.referenceId == referenceId &&
        other.occurredAt == occurredAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productId,
      quantity,
      type,
      referenceId,
      occurredAt,
    );
  }
}

============================================================
FILE: lib/features/inventory/application/inventory_use_cases.dart
============================================================
import '../../../core/quantity/quantity.dart';
import '../domain/inventory_repository.dart';
import '../domain/inventory_service.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class InventoryUseCases {
  final InventoryRepository repository;

  const InventoryUseCases({
    required this.repository,
  });

  StockLedger? getLedger(String productId) {
    return repository.getLedger(productId);
  }

  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(repository.getMovements(productId));
  }

  Quantity getBalance(String productId) {
    final ledger = repository.getLedger(productId);

    if (ledger == null) {
      return Quantity.zero();
    }

    return ledger.calculateBalance();
  }

  void receiveStock({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getOrCreateLedger(productId);

    final service = InventoryService(ledger: ledger).receiveStock(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void sellStock({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).sellStock(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void adjustStockIncrease({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).adjustStockIncrease(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void adjustStockDecrease({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).adjustStockDecrease(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void recordDamage({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).recordDamage(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void returnStockIn({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).returnStockIn(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  void returnStockOut({
    required String productId,
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final ledger = _getRequiredLedger(productId);

    final service = InventoryService(ledger: ledger).returnStockOut(
      movementId: movementId,
      quantity: quantity,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );

    repository.saveLedger(service.ledger);
    repository.recordMovement(service.ledger.movements.last);
  }

  StockLedger _getRequiredLedger(String productId) {
    final ledger = repository.getLedger(productId);

    if (ledger == null) {
      throw ArgumentError(
        'Inventory ledger not found for product.',
      );
    }

    return ledger;
  }

  StockLedger _getOrCreateLedger(String productId) {
    return repository.getLedger(productId) ??
        StockLedger(productId: productId);
  }
}

============================================================
FILE: lib/features/inventory/infrastructure/in_memory_inventory_repository.dart
============================================================
import '../domain/inventory_repository.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class InMemoryInventoryRepository implements InventoryRepository {
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> _movements = [];

  @override
  StockLedger? getLedger(String productId) {
    return _ledgers[productId];
  }

  @override
  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(
      _movements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  void saveLedger(StockLedger ledger) {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  void recordMovement(StockMovement movement) {
    final alreadyRecorded = _movements.any(
      (existing) => existing.id == movement.id,
    );

    if (alreadyRecorded) {
      throw ArgumentError(
        'Stock movement ID already exists.',
      );
    }

    _movements.add(movement);
  }
}

============================================================
FILE: lib/features/purchasing/domain/cost_layer.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class CostLayer {
  final String id;
  final String productId;
  final Quantity originalQuantity;
  final Quantity remainingQuantity;
  final Money unitCost;
  final DateTime acquiredAt;
  final String? purchaseId;

  CostLayer({
    required this.id,
    required this.productId,
    required this.originalQuantity,
    required this.remainingQuantity,
    required this.unitCost,
    required this.acquiredAt,
    this.purchaseId,
  }) : assert(id != ''),
       assert(productId != ''),
       assert(originalQuantity.value > 0),
       assert(remainingQuantity.value >= 0),
       assert(_isRemainingWithinOriginal(
         originalQuantity,
         remainingQuantity,
       ));

  static bool _isRemainingWithinOriginal(
    Quantity original,
    Quantity remaining,
  ) {
    final commonScale =
        original.scale > remaining.scale
            ? original.scale
            : remaining.scale;

    final originalValue = _scaleQuantity(
      original,
      commonScale,
    );

    final remainingValue = _scaleQuantity(
      remaining,
      commonScale,
    );

    return remainingValue <= originalValue;
  }

  bool get isDepleted => remainingQuantity.isZero;

  bool get isAvailable => remainingQuantity.isPositive;

  bool get hasValidRemainingQuantity {
    final commonScale = originalQuantity.scale > remainingQuantity.scale
        ? originalQuantity.scale
        : remainingQuantity.scale;

    final original = _scaleQuantity(
      originalQuantity,
      commonScale,
    );

    final remaining = _scaleQuantity(
      remainingQuantity,
      commonScale,
    );

    return remaining <= original;
  }

  Money get originalTotalCost => Money(
        minorUnits: unitCost.minorUnits *
            originalQuantity.value ~/
            _scaleFactor(originalQuantity.scale),
        currency: unitCost.currency,
      );

  Money get remainingValue => Money(
        minorUnits: unitCost.minorUnits *
            remainingQuantity.value ~/
            _scaleFactor(remainingQuantity.scale),
        currency: unitCost.currency,
      );

  CostLayer consume(Quantity quantity) {
    if (!hasValidRemainingQuantity) {
      throw StateError(
        'Cost layer remaining quantity cannot exceed original quantity.',
      );
    }

    if (quantity.isZero) {
      throw ArgumentError('Consumed quantity must be positive.');
    }

    final commonScale = remainingQuantity.scale > quantity.scale
        ? remainingQuantity.scale
        : quantity.scale;

    final available = _scaleQuantity(
      remainingQuantity,
      commonScale,
    );
    final requested = _scaleQuantity(
      quantity,
      commonScale,
    );

    if (requested > available) {
      throw ArgumentError(
        'Cannot consume more than the remaining quantity.',
      );
    }

    return CostLayer(
      id: id,
      productId: productId,
      originalQuantity: originalQuantity,
      remainingQuantity: remainingQuantity.subtract(quantity),
      unitCost: unitCost,
      acquiredAt: acquiredAt,
      purchaseId: purchaseId,
    );
  }

  static int _scaleQuantity(
    Quantity quantity,
    int targetScale,
  ) {
    if (quantity.scale == targetScale) {
      return quantity.value;
    }

    var factor = 1;

    for (var i = 0; i < targetScale - quantity.scale; i++) {
      factor *= 10;
    }

    return quantity.value * factor;
  }

  static int _scaleFactor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }
}

============================================================
FILE: lib/features/purchasing/domain/cost_layer_repository.dart
============================================================
import 'cost_layer.dart';

abstract interface class CostLayerRepository {
  CostLayer? getById(String id);

  List<CostLayer> getByProductId(String productId);

  List<CostLayer> getAvailableByProductId(String productId);

  void save(CostLayer layer);

  void update(CostLayer layer);
}

============================================================
FILE: lib/features/purchasing/domain/cost_layer_service.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import 'cost_layer.dart';
import 'cost_layer_repository.dart';

class CostLayerService {
  final CostLayerRepository repository;

  const CostLayerService({required this.repository});

  CostConsumption consume({
    required String productId,
    required Quantity quantity,
  }) {
    if (productId.isEmpty) {
      throw ArgumentError('Product ID cannot be empty.');
    }

    if (quantity.isZero) {
      throw ArgumentError('Consumed quantity must be positive.');
    }

    final layers =
        List<CostLayer>.from(repository.getAvailableByProductId(productId))
          ..sort((a, b) {
            final acquired = a.acquiredAt.compareTo(b.acquiredAt);

            if (acquired != 0) {
              return acquired;
            }

            return a.id.compareTo(b.id);
          });

    if (layers.isEmpty) {
      throw StateError('No available cost layer for product "$productId".');
    }

    var remaining = quantity;
    Money? totalCost;
    final updates = <CostLayer>[];
    final consumptions = <CostLayerConsumption>[];

    for (final layer in layers) {
      if (remaining.isZero) {
        break;
      }

      final commonScale = _maxScale(
        remaining.scale,
        layer.remainingQuantity.scale,
      );

      final requestedValue = _scaleTo(remaining, commonScale);

      final availableValue = _scaleTo(layer.remainingQuantity, commonScale);

      final consumedValue =
          requestedValue < availableValue ? requestedValue : availableValue;

      if (consumedValue <= 0) {
        continue;
      }

      final consumedQuantity = Quantity(
        value: consumedValue,
        scale: commonScale,
      );

      final updatedLayer = layer.consume(consumedQuantity);

      final layerCost = Money(
        minorUnits: layer.unitCost.minorUnits *
            consumedQuantity.value ~/
            _scaleFactor(consumedQuantity.scale),
        currency: layer.unitCost.currency,
      );

      totalCost = totalCost == null ? layerCost : totalCost.add(layerCost);

      updates.add(updatedLayer);
      consumptions.add(
        CostLayerConsumption(
          layerId: layer.id,
          quantity: consumedQuantity,
          unitCost: layer.unitCost,
          cost: layerCost,
        ),
      );

      remaining = Quantity(
        value: requestedValue - consumedValue,
        scale: commonScale,
      );
    }

    if (!remaining.isZero) {
      throw ArgumentError(
        'Insufficient stock in cost layers for product "$productId".',
      );
    }

    // All validation and costing has completed successfully.
    // Only now mutate the repository.
    for (final updatedLayer in updates) {
      repository.update(updatedLayer);
    }

    return CostConsumption(
      quantity: quantity,
      totalCost: totalCost!,
      consumptions: List.unmodifiable(consumptions),
    );
  }

  static int _maxScale(int first, int second) {
    return first > second ? first : second;
  }

  static int _scaleTo(Quantity quantity, int targetScale) {
    if (quantity.scale == targetScale) {
      return quantity.value;
    }

    return quantity.value * _scaleFactor(targetScale - quantity.scale);
  }

  static int _scaleFactor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }
}

class CostConsumption {
  final Quantity quantity;
  final Money totalCost;
  final List<CostLayerConsumption> consumptions;

  const CostConsumption({
    required this.quantity,
    required this.totalCost,
    required this.consumptions,
  });

  List<String> get consumedLayerIds {
    return consumptions.map((item) => item.layerId).toList();
  }
}

class CostLayerConsumption {
  final String layerId;
  final Quantity quantity;
  final Money unitCost;
  final Money cost;

  const CostLayerConsumption({
    required this.layerId,
    required this.quantity,
    required this.unitCost,
    required this.cost,
  });
}

============================================================
FILE: lib/features/purchasing/domain/purchase.dart
============================================================
import '../../../core/money/money.dart';
import 'purchase_item.dart';

class Purchase {
  final String id;
  final DateTime purchasedAt;
  final String? supplierId;
  final String? referenceNumber;
  final List<PurchaseItem> items;

  const Purchase({
    required this.id,
    required this.purchasedAt,
    this.supplierId,
    this.referenceNumber,
    required this.items,
  }) : assert(id != ''),
       assert(items.length > 0);

  Money get totalCost {
    if (items.isEmpty) {
      throw StateError('Purchase must contain at least one item.');
    }

    var total = items.first.totalCost;

    for (var i = 1; i < items.length; i++) {
      total = total.add(items[i].totalCost);
    }

    return total;
  }
}

============================================================
FILE: lib/features/purchasing/domain/purchase_item.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class PurchaseItem {
  final String id;
  final String productId;
  final Quantity quantity;
  final Money unitCost;

  PurchaseItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitCost,
  })  : assert(id != ''),
        assert(productId != ''),
        assert(quantity.value > 0),
        assert(unitCost.minorUnits >= 0);

  Money get totalCost {
    final scaleFactor = _scaleFactor(quantity.scale);
    final totalMinorUnits =
        (unitCost.minorUnits * quantity.value) ~/ scaleFactor;

    return Money(
      minorUnits: totalMinorUnits,
      currency: unitCost.currency,
    );
  }

  static int _scaleFactor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }
}

============================================================
FILE: lib/features/purchasing/domain/purchase_repository.dart
============================================================
import 'purchase.dart';

abstract interface class PurchaseRepository {
  Purchase? getById(String id);

  Purchase? getByReferenceNumber(String referenceNumber);

  List<Purchase> getAll();

  void save(Purchase purchase);

  void update(Purchase purchase);

  void deleteById(String id);
}

============================================================
FILE: lib/features/purchasing/infrastructure/in_memory_cost_layer_repository.dart
============================================================
import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class InMemoryCostLayerRepository implements CostLayerRepository {
  final Map<String, CostLayer> _layers = {};

  @override
  CostLayer? getById(String id) {
    return _layers[id];
  }

  @override
  List<CostLayer> getByProductId(String productId) {
    return _layers.values
        .where((layer) => layer.productId == productId)
        .toList();
  }

  @override
  List<CostLayer> getAvailableByProductId(String productId) {
    return _layers.values
        .where(
          (layer) =>
              layer.productId == productId && layer.isAvailable,
        )
        .toList();
  }

  @override
  void save(CostLayer layer) {
    if (_layers.containsKey(layer.id)) {
      throw StateError(
        'Cost layer with id "${layer.id}" already exists.',
      );
    }

    _layers[layer.id] = layer;
  }

  @override
  void update(CostLayer layer) {
    if (!_layers.containsKey(layer.id)) {
      throw StateError(
        'Cost layer with id "${layer.id}" does not exist.',
      );
    }

    _layers[layer.id] = layer;
  }
}

============================================================
FILE: lib/features/purchasing/infrastructure/in_memory_purchase_repository.dart
============================================================
import '../domain/purchase.dart';
import '../domain/purchase_repository.dart';

class InMemoryPurchaseRepository implements PurchaseRepository {
  final Map<String, Purchase> _purchases = {};

  @override
  Purchase? getById(String id) {
    return _purchases[id];
  }

  @override
  Purchase? getByReferenceNumber(String referenceNumber) {
    for (final purchase in _purchases.values) {
      if (purchase.referenceNumber == referenceNumber) {
        return purchase;
      }
    }

    return null;
  }

  @override
  List<Purchase> getAll() {
    return _purchases.values.toList();
  }

  @override
  void save(Purchase purchase) {
    if (_purchases.containsKey(purchase.id)) {
      throw StateError(
        'Purchase with id "${purchase.id}" already exists.',
      );
    }

    _purchases[purchase.id] = purchase;
  }

  @override
  void update(Purchase purchase) {
    if (!_purchases.containsKey(purchase.id)) {
      throw StateError(
        'Purchase with id "${purchase.id}" does not exist.',
      );
    }

    _purchases[purchase.id] = purchase;
  }

  @override
  void deleteById(String id) {
    if (!_purchases.containsKey(id)) {
      throw StateError(
        'Purchase with id "$id" does not exist.',
      );
    }

    _purchases.remove(id);
  }
}

============================================================
FILE: lib/features/sales/domain/sale.dart
============================================================
import '../../../core/money/money.dart';
import 'sale_item.dart';

class Sale {
  final String id;
  final String invoiceNumber;
  final List<SaleItem> items;
  final Money discount;
  final Money tax;
  final DateTime createdAt;

  Sale({
    required this.id,
    required this.invoiceNumber,
    required this.items,
    required this.discount,
    required this.tax,
    required this.createdAt,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }

    if (invoiceNumber.isEmpty) {
      throw ArgumentError('Invoice number cannot be empty.');
    }

    if (items.isEmpty) {
      throw ArgumentError('Sale must contain at least one item.');
    }

    if (discount.isNegative) {
      throw ArgumentError('Sale discount cannot be negative.');
    }

    if (tax.isNegative) {
      throw ArgumentError('Sale tax cannot be negative.');
    }

    final currency = items.first.unitPrice.currency;

    if (discount.currency != currency) {
      throw ArgumentError('Sale discount currency must match item currency.');
    }

    if (tax.currency != currency) {
      throw ArgumentError('Sale tax currency must match item currency.');
    }

    for (final item in items) {
      if (item.unitPrice.currency != currency) {
        throw ArgumentError(
          'All sale items must use the same currency.',
        );
      }
    }
  }

  Money get subtotal {
    var result = Money(
      minorUnits: 0,
      currency: items.first.unitPrice.currency,
    );

    for (final item in items) {
      result = result.add(item.subtotal);
    }

    return result;
  }

  Money get total {
    final afterDiscount = subtotal.subtract(discount);

    if (afterDiscount.isNegative) {
      throw ArgumentError(
        'Sale discount cannot exceed subtotal.',
      );
    }

    return afterDiscount.add(tax);
  }

  @override
  bool operator ==(Object other) {
    return other is Sale &&
        other.id == id &&
        other.invoiceNumber == invoiceNumber &&
        _listEquals(other.items, items) &&
        other.discount == discount &&
        other.tax == tax &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      invoiceNumber,
      Object.hashAll(items),
      discount,
      tax,
      createdAt,
    );
  }

  bool _listEquals(List<SaleItem> other, List<SaleItem> current) {
    if (other.length != current.length) {
      return false;
    }

    for (var i = 0; i < current.length; i++) {
      if (other[i] != current[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  String toString() {
    return 'Sale('
        'id: $id, '
        'invoiceNumber: $invoiceNumber, '
        'items: $items, '
        'discount: $discount, '
        'tax: $tax, '
        'createdAt: $createdAt'
        ')';
  }
}

============================================================
FILE: lib/features/sales/domain/sale_item.dart
============================================================
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';

class SaleItem {
  final String productId;
  final String productName;
  final Unit unit;
  final Quantity quantity;
  final Money unitPrice;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
  }) {
    if (productId.isEmpty) {
      throw ArgumentError('Sale item product ID cannot be empty.');
    }

    if (productName.isEmpty) {
      throw ArgumentError('Sale item product name cannot be empty.');
    }

    if (quantity.isZero) {
      throw ArgumentError('Sale item quantity must be greater than zero.');
    }

    if (unitPrice.isNegative) {
      throw ArgumentError('Sale item unit price cannot be negative.');
    }
  }

  Money get subtotal => unitPrice.multiply(quantity.value);

  @override
  bool operator ==(Object other) {
    return other is SaleItem &&
        other.productId == productId &&
        other.productName == productName &&
        other.unit == unit &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode {
    return Object.hash(
      productId,
      productName,
      unit,
      quantity,
      unitPrice,
    );
  }

  @override
  String toString() {
    return 'SaleItem('
        'productId: $productId, '
        'productName: $productName, '
        'unit: $unit, '
        'quantity: $quantity, '
        'unitPrice: $unitPrice'
        ')';
  }
}

============================================================
FILE: lib/features/sales/domain/sale_repository.dart
============================================================
import 'sale.dart';

abstract interface class SaleRepository {
  Sale? getById(String id);

  Sale? getByInvoiceNumber(String invoiceNumber);

  List<Sale> getAll();

  void save(Sale sale);

  void update(Sale sale);

  void deleteById(String id);
}

============================================================
FILE: lib/features/sales/domain/sale_service.dart
============================================================
import '../../../core/money/money.dart';
import 'sale.dart';
import 'sale_item.dart';

class SaleService {
  final Sale sale;

  const SaleService({
    required this.sale,
  });

  Money get subtotal => sale.subtotal;

  Money get total => sale.total;

  SaleService addItem(SaleItem item) {
    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: [
          ...sale.items,
          item,
        ],
        discount: sale.discount,
        tax: sale.tax,
        createdAt: sale.createdAt,
      ),
    );
  }

  SaleService removeItemAt(int index) {
    if (index < 0 || index >= sale.items.length) {
      throw RangeError.index(
        index,
        sale.items,
        'index',
      );
    }

    final items = [
      ...sale.items,
    ]..removeAt(index);

    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: items,
        discount: sale.discount,
        tax: sale.tax,
        createdAt: sale.createdAt,
      ),
    );
  }

  SaleService withDiscount(Money discount) {
    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: sale.items,
        discount: discount,
        tax: sale.tax,
        createdAt: sale.createdAt,
      ),
    );
  }

  SaleService withTax(Money tax) {
    return SaleService(
      sale: Sale(
        id: sale.id,
        invoiceNumber: sale.invoiceNumber,
        items: sale.items,
        discount: sale.discount,
        tax: tax,
        createdAt: sale.createdAt,
      ),
    );
  }
}

============================================================
FILE: lib/features/sales/application/sale_use_cases.dart
============================================================
import '../../../core/money/money.dart';
import '../domain/sale.dart';
import '../domain/sale_item.dart';
import '../domain/sale_repository.dart';
import '../domain/sale_service.dart';

class SaleUseCases {
  final SaleRepository repository;

  const SaleUseCases({
    required this.repository,
  });

  Sale? getById(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }

    return repository.getById(id);
  }

  List<Sale> getAll() {
    return List.unmodifiable(repository.getAll());
  }

  void create(Sale sale) {
    repository.save(sale);
  }

  void addItem({
    required String saleId,
    required SaleItem item,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).addItem(item);
    repository.update(updated.sale);
  }

  void removeItemAt({
    required String saleId,
    required int index,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).removeItemAt(index);
    repository.update(updated.sale);
  }

  void applyDiscount({
    required String saleId,
    required Money discount,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).withDiscount(discount);
    repository.update(updated.sale);
  }

  void applyTax({
    required String saleId,
    required Money tax,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).withTax(tax);
    repository.update(updated.sale);
  }

  void delete(String saleId) {
    _getRequiredSale(saleId);
    repository.deleteById(saleId);
  }

  Sale _getRequiredSale(String saleId) {
    if (saleId.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }

    final sale = repository.getById(saleId);

    if (sale == null) {
      throw ArgumentError('Sale not found.');
    }

    return sale;
  }
}

============================================================
FILE: lib/features/sales/infrastructure/in_memory_sale_repository.dart
============================================================
import '../domain/sale.dart';
import '../domain/sale_repository.dart';

class InMemorySaleRepository implements SaleRepository {
  final Map<String, Sale> _sales = {};

  @override
  Sale? getById(String id) => _sales[id];

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) {
    for (final sale in _sales.values) {
      if (sale.invoiceNumber == invoiceNumber) {
        return sale;
      }
    }

    return null;
  }

  @override
  List<Sale> getAll() {
    return List.unmodifiable(_sales.values);
  }

  @override
  void save(Sale sale) {
    if (_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale ID already exists.');
    }

    if (getByInvoiceNumber(sale.invoiceNumber) != null) {
      throw ArgumentError('Invoice number already exists.');
    }

    _sales[sale.id] = sale;
  }

  @override
  void update(Sale sale) {
    if (!_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale not found.');
    }

    final existingInvoiceOwner = getByInvoiceNumber(
      sale.invoiceNumber,
    );

    if (existingInvoiceOwner != null &&
        existingInvoiceOwner.id != sale.id) {
      throw ArgumentError('Invoice number already exists.');
    }

    _sales[sale.id] = sale;
  }

  @override
  void deleteById(String id) {
    _sales.remove(id);
  }
}
