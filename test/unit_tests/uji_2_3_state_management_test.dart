import 'package:flutter_test/flutter_test.dart';

// State Representation
abstract class CartState {}
class CartInitial extends CartState {}
class CartLoading extends CartState {}
class CartSuccess extends CartState {
  final List<String> items;
  final double total;
  CartSuccess(this.items, this.total);
}
class CartError extends CartState {
  final String message;
  CartError(this.message);
}

// Simulated State Notifier / Logic Controller
class CartController {
  CartState _state = CartInitial();
  CartState get state => _state;

  Future<void> checkout(List<String> items, double total) async {
    if (items.isEmpty) {
      _state = CartError('Keranjang tidak boleh kosong');
      return;
    }

    _state = CartLoading();
    // Simulasi pemrosesan async
    await Future.delayed(const Duration(milliseconds: 50));

    if (total <= 0) {
      _state = CartError('Total transaksi tidak valid');
    } else {
      _state = CartSuccess(items, total);
    }
  }
}

void main() {
  group('Uji 2.3 - State Management & Business Logic Validation', () {
    late CartController controller;

    setUp(() {
      controller = CartController();
    });

    test('2.3.1 - State awal harus CartInitial', () {
      expect(controller.state, isA<CartInitial>());
    });

    test('2.3.2 - Checkout berhasil mengubah state dari Loading ke CartSuccess', () async {
      final future = controller.checkout(['Kopi Susu'], 15000.0);
      
      // Verifikasi transisi ke CartLoading
      expect(controller.state, isA<CartLoading>());

      await future;

      // Verifikasi state akhir CartSuccess
      expect(controller.state, isA<CartSuccess>());
      final successState = controller.state as CartSuccess;
      expect(successState.items.length, 1);
      expect(successState.total, 15000.0);
    });

    test('2.3.3 - Checkout keranjang kosong menghasilkan CartError', () async {
      await controller.checkout([], 0.0);

      expect(controller.state, isA<CartError>());
      final errorState = controller.state as CartError;
      expect(errorState.message, 'Keranjang tidak boleh kosong');
    });
  });
}
