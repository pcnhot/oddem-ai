import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/cart_item.dart';
import '../../../shared/models/product.dart';

/// In-memory cart state. Backend-ready: persistence/sync can be layered on
/// top of this notifier without changing the UI contract.
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const <CartItem>[]);

  void add(Product product, {ProductColor? color, int quantity = 1}) {
    final index = state.indexWhere(
      (i) => i.product.id == product.id && i.selectedColor == color,
    );
    if (index >= 0) {
      final updated = [...state];
      updated[index] =
          updated[index].copyWith(quantity: updated[index].quantity + quantity);
      state = updated;
    } else {
      state = [
        ...state,
        CartItem(product: product, quantity: quantity, selectedColor: color),
      ];
    }
  }

  void setQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      remove(productId);
      return;
    }
    state = [
      for (final i in state)
        if (i.product.id == productId) i.copyWith(quantity: quantity) else i,
    ];
  }

  void increment(String productId) {
    final item = state.firstWhere((i) => i.product.id == productId);
    setQuantity(productId, item.quantity + 1);
  }

  void decrement(String productId) {
    final item = state.firstWhere((i) => i.product.id == productId);
    setQuantity(productId, item.quantity - 1);
  }

  void remove(String productId) {
    state = state.where((i) => i.product.id != productId).toList();
  }

  void clear() => state = const <CartItem>[];
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
    (ref) => CartNotifier());

final cartCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).fold<int>(0, (sum, i) => sum + i.quantity);
});

final cartSubtotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).fold<double>(0, (sum, i) => sum + i.lineTotal);
});
