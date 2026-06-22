import '../../../shared/data/mock_data.dart';
import '../../../shared/models/cart_item.dart';
import '../../../shared/models/order.dart';

/// Handles installation estimation and order placement.
///
/// IMPORTANT ODDEM RULE: installation ETA is computed ONLY here (at checkout)
/// based on the selected city and supplier availability — never shown as a
/// fixed promise and never surfaced on product or catalog screens.
abstract class CheckoutRepository {
  /// Computes installation availability + an ETA *range* for [city] given the
  /// suppliers in the cart.
  Future<InstallationEstimate> estimateInstallation({
    required String city,
    required List<CartItem> items,
  });

  Future<Order> placeOrder({
    required List<CartItem> items,
    required String city,
    required String address,
    required double subtotal,
    required double shipping,
  });
}

class MockCheckoutRepository implements CheckoutRepository {
  const MockCheckoutRepository();

  @override
  Future<InstallationEstimate> estimateInstallation({
    required String city,
    required List<CartItem> items,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Installation is available only if every supplier in the cart serves the
    // selected city.
    final supplierIds = items.map((i) => i.product.supplierId).toSet();
    final suppliers =
        MockData.suppliers.where((s) => supplierIds.contains(s.id));

    final allServe = suppliers.isNotEmpty &&
        suppliers.every((s) => s.servedCities.contains(city));

    if (!allServe) {
      return InstallationEstimate(
        city: city,
        available: false,
        message:
            'خدمة التركيب غير متوفرة حاليًا في $city لبعض المنتجات. سيتم التواصل معك لتنسيق التركيب.',
      );
    }

    // ETA range varies by city tier (purely illustrative for the MVP).
    final tier1 = {'الرياض', 'جدة', 'الدمام', 'الخبر'};
    final min = tier1.contains(city) ? 3 : 5;
    final max = tier1.contains(city) ? 6 : 10;

    return InstallationEstimate(
      city: city,
      available: true,
      minDays: min,
      maxDays: max,
      message:
          'التركيب متاح في $city خلال $min إلى $max أيام عمل تقريبًا بعد تأكيد الطلب (تقدير تقريبي وليس وعدًا ثابتًا).',
    );
  }

  @override
  Future<Order> placeOrder({
    required List<CartItem> items,
    required String city,
    required String address,
    required double subtotal,
    required double shipping,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    final estimate = await estimateInstallation(city: city, items: items);
    return Order(
      id: 'ODM-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
      items: items,
      subtotal: subtotal,
      shipping: shipping,
      total: subtotal + shipping,
      city: city,
      address: address,
      placedAt: DateTime.now(),
      installation: estimate,
    );
  }
}
