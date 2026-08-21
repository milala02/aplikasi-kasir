import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
    
    saveCartToStorage();
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item['id'] == productId);
    
    saveCartToStorage();
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    
    saveCartToStorage();
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


  // =========================================================================
  // SECURE CART PERSISTENCE (Anti-Ghost Cart Implementation)
  // =========================================================================
  Future<void> saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Hanya menyimpan ID dan Qty untuk mencegah celah harga manipulatif
      final List<Map<String, dynamic>> minimalCart = _cart.map((item) => {
        'id': item['id'],
        'qty': item['qty']
      }).toList();
      
      await prefs.setString('pos_secure_cart', json.encode(minimalCart));
    } catch (e) {
      debugPrint("Gagal menyimpan keranjang: $e");
    }
  }

  Future<void> loadSavedCart(List<Map<String, dynamic>> masterCatalog) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString('pos_secure_cart');
      
      if (cartJson != null) {
        final List<dynamic> decoded = json.decode(cartJson);
        _cart.clear();
        
        for (var savedItem in decoded) {
          // Prinsip Zero-Trust: Cocokkan ID dengan katalog asli untuk mendapatkan harga terbaru!
          final String targetId = savedItem['id'].toString();
          final int qty = savedItem['qty'] ?? 1;
          
          final realProduct = masterCatalog.firstWhere(
            (p) => p['id'].toString() == targetId,
            orElse: () => <String, dynamic>{}, // Kembalikan map kosong jika produk sudah dihapus dari DB
          );
          
          if (realProduct.isNotEmpty) {
            _cart.add({
              ...realProduct,
              'qty': qty,
            });
          }
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Gagal memuat keranjang, mereset: $e");
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('pos_secure_cart');
    }
  }


  // =========================================================================
  // ATOMIC CHECKOUT ENGINE
  // =========================================================================
  Future<bool> processCheckout({required String paymentMethod, double taxRate = 0.11}) async {
    if (_cart.isEmpty) {
      debugPrint("Keranjang kosong, batalkan checkout.");
      return false;
    }

    try {
      // 1. Hitung Subtotal, Pajak, dan Total 
      // (Catatan Audit P0: Penggunaan double ini ke depannya harus dimigrasi ke objek Money)
      double subtotal = 0.0;
      for (var item in _cart) {
        // Parsing aman untuk mencegah error tipe data dynamic
        final price = double.tryParse(item['base_price']?.toString() ?? item['price']?.toString() ?? '0') ?? 0.0;
        final qty = int.tryParse(item['qty']?.toString() ?? '1') ?? 1;
        subtotal += (price * qty);
      }
      
      double tax = subtotal * taxRate;
      double total = subtotal + tax;

      // 2. Siapkan Data Transaksi
      final String trxId = 'TRX-${DateTime.now().millisecondsSinceEpoch}';
      final transactionData = {
        'id': trxId,
        'timestamp': DateTime.now().toIso8601String(),
        'subtotal': subtotal,
        'tax': tax,
        'total': total,
        'payment_method': paymentMethod,
        'status': 'COMPLETED'
      };

      // 3. Eksekusi Transaksi Atomik ke Database
      // Menggunakan _repository yang sudah ada di PosProvider
      bool isSuccess = await _repository.processSaleAtomically(transactionData, _cart);

      if (isSuccess) {
        // 4. Bersihkan keranjang jika sukses (otomatis tersimpan ke SharedPreferences kosong)
        clearCart(); 
        debugPrint("✅ Checkout Sukses: Transaksi $trxId tersimpan secara atomik!");
        return true;
      } else {
        debugPrint("❌ Checkout Gagal: Rollback database terjadi.");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error sistem saat checkout: $e");
      return false;
    }
  }

}
