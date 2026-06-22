import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../shared/models/cart_item.dart';
import '../../../shared/models/order.dart';
import '../../cart/presentation/cart_providers.dart';
import '../data/checkout_repository.dart';

final checkoutRepositoryProvider = Provider<CheckoutRepository>(
  (ref) => const MockCheckoutRepository(),
);

/// Selected delivery/installation city.
final checkoutCityProvider =
    StateProvider<String>((ref) => AppConstants.saudiCities.first);

/// Flat shipping fee for the MVP.
final shippingFeeProvider = Provider<double>((ref) => 150);

/// Installation estimate for the selected city + current cart. Recomputes when
/// either changes. This is the ONLY place an ETA is surfaced.
final installationEstimateProvider =
    FutureProvider<InstallationEstimate>((ref) {
  final city = ref.watch(checkoutCityProvider);
  final items = ref.watch(cartProvider);
  return ref
      .watch(checkoutRepositoryProvider)
      .estimateInstallation(city: city, items: items);
});

/// Holds the placed order after a successful checkout.
class OrderController extends StateNotifier<AsyncValue<Order?>> {
  OrderController(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;

  Future<Order?> place({required String address}) async {
    state = const AsyncValue.loading();
    final repo = _ref.read(checkoutRepositoryProvider);
    final items = _ref.read(cartProvider);
    final city = _ref.read(checkoutCityProvider);
    final subtotal = _ref.read(cartSubtotalProvider);
    final shipping = _ref.read(shippingFeeProvider);

    state = await AsyncValue.guard(() => repo.placeOrder(
          items: List<CartItem>.from(items),
          city: city,
          address: address,
          subtotal: subtotal,
          shipping: shipping,
        ));

    final order = state.valueOrNull;
    if (order != null) {
      _ref.read(cartProvider.notifier).clear();
    }
    return order;
  }
}

final orderControllerProvider =
    StateNotifierProvider<OrderController, AsyncValue<Order?>>(
  (ref) => OrderController(ref),
);
