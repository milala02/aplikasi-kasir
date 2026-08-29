import 'package:flutter/foundation.dart';

import '../../../core/quantity/quantity.dart';
import '../../../core/result/result.dart';
import '../../cart/domain/cart.dart';
import '../../cart/domain/cart_item.dart';
import '../../customers/domain/customer.dart';
import '../../customers/domain/customer_repository.dart';
import '../../orders/application/fulfill_order_use_case.dart';
import '../../orders/application/order_payment_use_case.dart';
import '../../orders/application/submit_order_use_case.dart';
import '../../orders/domain/order.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../application/receipt_service.dart';
import '../domain/sale.dart';
import '../domain/sale_item.dart';
import '../domain/sale_repository.dart';

class POSController extends ChangeNotifier {
  final ProductRepository productRepository;
  final CustomerRepository customerRepository;
  final SubmitOrderUseCase submitOrderUseCase;
  final OrderPaymentUseCase orderPaymentUseCase;
  final FulfillOrderUseCase fulfillOrderUseCase;
  final SaleRepository saleRepository;
  final ReceiptService receiptService;

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  Cart _cart = Cart(items: []);
  Customer? _selectedCustomer;
  String _searchQuery = '';
  Sale? _lastCompletedSale;
  Order? _lastOrder;

  POSController({
    required this.productRepository,
    required this.customerRepository,
    required this.submitOrderUseCase,
    required this.orderPaymentUseCase,
    required this.fulfillOrderUseCase,
    required this.saleRepository,
    ReceiptService? receiptService,
  }) : receiptService = receiptService ?? ReceiptService();

  List<Product> get products => _filteredProducts;
  Cart get cart => _cart;
  Customer? get selectedCustomer => _selectedCustomer;
  String get searchQuery => _searchQuery;

  /// Sale (financial record) dari order terakhir, untuk preview struk.
  Sale? get lastCompletedSale => _lastCompletedSale;

  /// Order terakhir dari checkout (lifecycle payment/fulfillment).
  Order? get lastOrder => _lastOrder;

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

  /// Checkout onsite: submit order (PENDING_PAYMENT) + catat sale.
  /// TIDAK menyentuh stok — stock-out terjadi saat handover.
  /// Tunai: langsung PAID (kasir menerima pembayaran).
  Future<bool> checkout({
    required String invoiceNumber,
    required OrderPaymentMethod paymentMethod,
  }) async {
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

    final now = DateTime.now();
    final result = await submitOrderUseCase.submit(
      orderId: 'ord_${now.millisecondsSinceEpoch}',
      saleId: 'sale_${now.millisecondsSinceEpoch}',
      invoiceNumber: invoiceNumber,
      source: OrderSource.onsite,
      paymentMethod: paymentMethod,
      items: saleItems,
      submittedAt: now,
    );
    if (result is! Success<Order>) return false;

    var order = result.value;

    if (paymentMethod == OrderPaymentMethod.cash) {
      final payResult = await orderPaymentUseCase.confirm(order);
      if (payResult is Success<Order>) {
        order = payResult.value;
      }
    }

    _lastOrder = order;
    _lastCompletedSale = saleRepository.getById(order.saleId);
    _cart = Cart(items: []);
    _selectedCustomer = null;
    notifyListeners();
    return true;
  }

  /// Konfirmasi pembayaran QRIS untuk order terakhir (retry diizinkan).
  Future<bool> confirmPaymentForLastOrder() async {
    final order = _lastOrder;
    if (order == null) return false;
    final result = await orderPaymentUseCase.confirm(order);
    if (result is! Success<Order>) return false;
    _lastOrder = result.value;
    notifyListeners();
    return true;
  }

  /// Handover onsite: stock-out FIFO + movement + kunci HPP.
  Future<bool> completeHandover() async {
    final order = _lastOrder;
    if (order == null) return false;
    final result = await fulfillOrderUseCase.handover(order);
    if (result is! Success<Order>) return false;
    _lastOrder = result.value;
    _lastCompletedSale = saleRepository.getById(order.saleId);
    notifyListeners();
    return true;
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
