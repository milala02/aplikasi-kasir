import 'package:flutter/material.dart';
import '../data/pos_repository.dart';

class PosProvider with ChangeNotifier {
  final PosRepository _repository = PosRepository();

  // State Katalog & Keranjang
  List<Map<String, dynamic>> _products = [];
  final List<Map<String, dynamic>> _cart = [];
  bool _isLoading = false;

  // State Shift & Keamanan Dual-PIN
  bool _isShiftActive = false;
  String? _activeUserId;
  double _currentFloat = 0.0;

  // Getters
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get cart => _cart;
  bool get isLoading => _isLoading;
  bool get isShiftActive => _isShiftActive;
  String? get activeUserId => _activeUserId;
  double get currentFloat => _currentFloat;

  // Subtotal & Calculations
  double get subtotal => _cart.fold(0.0, (sum, item) => sum + (item['subtotal'] as double));
  double get tax => subtotal * 0.11; // PPN 11%
  double get grandTotal => subtotal + tax;

  // --- 1. OTORISASI DUAL-PIN KEAMANAN ---

  Future<bool> loginKasirWithPin(String userId, String inputPinHash) async {
    bool isValid = await _repository.verifyAppPin(userId, inputPinHash);
    if (isValid) {
      _activeUserId = userId;
      notifyListeners();
    }
    return isValid;
  }

  Future<bool> validateSupervisorOverridePin(String pinHash) async {
    return await _repository.verifySupervisorPin(pinHash);
  }

  // --- 2. MANAJEMEN PRODUK & STOK ---

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    _products = await _repository.getAllProducts();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addNewProduct({
    required String id,
    required String barcode,
    required String name,
    required double basePrice,
    required double costPrice,
    required int stock,
    required String category,
  }) async {
    final newProd = {
      'id': id,
      'barcode': barcode,
      'name': name,
      'base_price': basePrice,
      'cost_price': costPrice,
      'stock': stock,
      'category': category,
      'created_at': DateTime.now().toIso8601String(),
    };

    int result = await _repository.insertProduct(newProd);
    if (result > 0) {
      await loadProducts(); // Refresh katalog
      return true;
    }
    return false;
  }

  // --- 3. MANAJEMEN KERANJANG (CART) ---

  void addToCart(Map<String, dynamic> product, {int qty = 1}) {
    int index = _cart.indexWhere((item) => item['id'] == product['id']);
    double price = (product['base_price'] as num).toDouble();

    if (index >= 0) {
      int newQty = (_cart[index]['qty'] as int) + qty;
      _cart[index]['qty'] = newQty;
      _cart[index]['subtotal'] = newQty * price;
    } else {
      _cart.add({
        'id': product['id'],
        'name': product['name'],
        'price': price,
        'qty': qty,
        'subtotal': qty * price,
      });
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item['id'] == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // --- 4. MANAJEMEN SHIFT KASIR ---

  void openShift(double initialFloat) {
    _isShiftActive = true;
    _currentFloat = initialFloat;
    notifyListeners();
  }

  void closeShift() {
    _isShiftActive = false;
    _currentFloat = 0.0;
    _cart.clear();
    notifyListeners();
  }

  
  List<dynamic> _historyTransactions = [];
  List<dynamic> get historyTransactions => _historyTransactions;

  Future<void> fetchTransactionsByDate(DateTime date) async {
    // Fallback logic jika metode ini juga ikut terhapus sebelumnya
    _historyTransactions = []; 
    _filteredTransactions = [];
    notifyListeners();
  }

  List<dynamic> _filteredTransactions = [];
  List<dynamic> get filteredTransactions => _filteredTransactions.isEmpty ? _historyTransactions : _filteredTransactions;

  void filterTransactions({DateTime? date, String query = ""}) {
    _filteredTransactions = _historyTransactions.where((trx) {
      final matchesQuery = trx.id.toString().contains(query) || 
                           (trx.paymentMethod != null && trx.paymentMethod.toString().toLowerCase().contains(query.toLowerCase()));
      return matchesQuery;
    }).toList();
    notifyListeners();
  }

}
