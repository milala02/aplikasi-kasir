import 'package:flutter/material.dart';
import '../../features/products/application/product_use_cases.dart';
import '../../features/sales/application/sales_use_cases.dart';
import '../../features/cart/application/cart_use_cases.dart';
import '../../features/products/domain/product.dart';
import '../../features/cart/domain/cart.dart';
import '../../features/sales/domain/sale.dart';

class POSController extends ChangeNotifier {
  final ProductUseCases _productUseCases;
  final SalesUseCases _salesUseCases;
  final CartUseCases _cartUseCases;

  POSController({
    required ProductUseCases productUseCases,
    required SalesUseCases salesUseCases,
    required CartUseCases cartUseCases,
  })
      : _productUseCases = productUseCases,
        _salesUseCases = salesUseCases,
        _cartUseCases = cartUseCases;

  // State
  List<Product> _products = [];
  Cart _cart = Cart(items: []);
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Product> get products => _products;
  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all products
  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _productUseCases.getAllProducts();
    result.fold(
      (failure) {
        _error = failure.toString();
        _isLoading = false;
        notifyListeners();
      },
      (products) {
        _products = products;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Add product to cart
  void addToCart(Product product, int quantity) {
    _cart = _cartUseCases.addItem(_cart, product, quantity);
    notifyListeners();
  }

  // Remove product from cart
  void removeFromCart(String productId) {
    _cart = _cartUseCases.removeItem(_cart, productId);
    notifyListeners();
  }

  // Clear cart
  void clearCart() {
    _cart = Cart(items: []);
    notifyListeners();
  }

  // Process checkout
  Future<bool> checkout(String paymentMethod) async {
    if (_cart.items.isEmpty) return false;

    final result = await _salesUseCases.processSale(
      cartItems: _cart.items,
      paymentMethod: paymentMethod,
    );

    return result.fold(
      (failure) {
        _error = failure.toString();
        notifyListeners();
        return false;
      },
      (sale) {
        _cart = Cart(items: []);
        notifyListeners();
        return true;
      },
    );
  }
}
