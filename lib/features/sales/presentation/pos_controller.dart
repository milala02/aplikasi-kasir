import 'package:flutter/foundation.dart';

import '../../../core/quantity/quantity.dart';
import '../../../core/result/result.dart';
import '../../cart/domain/cart.dart';
import '../../cart/domain/cart_item.dart';
import '../../customers/domain/customer.dart';
import '../../customers/domain/customer_repository.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../application/process_sale_use_case.dart';
import '../application/receipt_service.dart';
import '../domain/sale.dart';
import '../domain/sale_item.dart';

class POSController extends ChangeNotifier {
  final ProductRepository productRepository;
  final CustomerRepository customerRepository;
  final ProcessSaleUseCase processSaleUseCase;
  final ReceiptService receiptService;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  Cart _cart = Cart(items: []);
  Customer? _selectedCustomer;
  String _searchQuery = '';
  Sale? _lastCompletedSale;

  POSController({
    required this.productRepository,
    required this.customerRepository,
    required this.processSaleUseCase,
    ReceiptService? receiptService,
  }) : receiptService = receiptService ?? ReceiptService();

  List<Product> get products => _filteredProducts;
  Cart get cart => _cart;
  Customer? get selectedCustomer => _selectedCustomer;
  String get searchQuery => _searchQuery;

  /// Transaksi terakhir yang berhasil diproses (untuk cetak/share struk).
  Sale? get lastCompletedSale => _lastCompletedSale;

  void init() {
    _allProducts = productRepository.getActive();
    _filteredProducts = List.from(_allProducts);
    notifyListeners();
  }

  void searchProduct(String query) {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.sku.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  void addToCart(Product product) {
    _cart = _cart.addItem(
      CartItem(
        product: product,
        quantity: Quantity(value: 1, scale: 0),
      ),
    );
    notifyListeners();
  }

  void updateCartQuantity(String productId, int quantityValue) {
    if (quantityValue <= 0) {
      removeFromCart(productId);
      return;
    }
    _cart = _cart.updateQuantity(
      productId: productId,
      quantity: Quantity(value: quantityValue, scale: 0),
    );
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart = _cart.removeProduct(productId);
    notifyListeners();
  }

  void selectCustomer(Customer? customer) {
    _selectedCustomer = customer;
    notifyListeners();
  }

  /// Proses checkout. Kembalikan `true` jika berhasil, `false` jika gagal.
  /// Transaksi yang berhasil tersimpan di [lastCompletedSale].
  bool checkout({required String invoiceNumber}) {
    if (_cart.items.isEmpty) return false;

    final saleItems = _cart.items.map((cartItem) {
      return SaleItem(
        productId: cartItem.product.id,
        productName: cartItem.product.name,
        unit: cartItem.product.baseUnit,
        quantity: cartItem.quantity,
        unitPrice: cartItem.product.sellingPrice,
      );
    }).toList();

    final sale = Sale(
      id: 'sale_${DateTime.now().millisecondsSinceEpoch}',
      invoiceNumber: invoiceNumber,
      items: saleItems,
      createdAt: DateTime.now(),
    );

    final result = processSaleUseCase.execute(sale);
    if (result is Success) {
      _lastCompletedSale = sale;
      _cart = Cart(items: []);
      _selectedCustomer = null;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Hasilkan teks struk untuk WhatsApp dari transaksi terakhir.
  String? generateWhatsAppReceipt({Customer? customer}) {
    if (_lastCompletedSale == null) return null;
    return receiptService.generateWhatsAppReceipt(
      _lastCompletedSale!,
      customer: customer ?? _selectedCustomer,
    );
  }
}
