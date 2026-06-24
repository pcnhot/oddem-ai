import 'package:flutter_test/flutter_test.dart';
import 'package:oddem/features/cart/presentation/cart_providers.dart';
import 'package:oddem/shared/data/mock_data.dart';

void main() {
  group('CartNotifier', () {
    test('adds a product and accumulates quantity', () {
      final cart = CartNotifier();
      final product = MockData.products.first;

      cart.add(product);
      cart.add(product);

      expect(cart.state.length, 1);
      expect(cart.state.first.quantity, 2);
      expect(cart.state.first.lineTotal, product.effectivePrice * 2);
    });

    test('decrement removes line when reaching zero', () {
      final cart = CartNotifier();
      final product = MockData.products.first;

      cart.add(product);
      cart.decrement(product.id);

      expect(cart.state, isEmpty);
    });

    test('effective price honours discount', () {
      final discounted = MockData.products.firstWhere((p) => p.hasDiscount);
      expect(discounted.effectivePrice, discounted.discountPrice);
    });
  });
}
