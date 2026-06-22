import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/mock_data.dart';
import '../../../shared/models/product.dart';

/// Favorites stored as a set of product ids.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{'p_1'}); // one seeded favorite

  void toggle(String productId) {
    final next = {...state};
    if (!next.add(productId)) next.remove(productId);
    state = next;
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

final favoriteProductsProvider = Provider<List<Product>>((ref) {
  final ids = ref.watch(favoritesProvider);
  return MockData.products.where((p) => ids.contains(p.id)).toList();
});
