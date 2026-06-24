import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/data/product_loader.dart';
import '../../../shared/models/product.dart';

/// Favorites stored as a set of product ids.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(<String>{'liv_01'}); // one seeded favorite

  void toggle(String productId) {
    final next = {...state};
    if (!next.add(productId)) next.remove(productId);
    state = next;
  }

  bool isFavorite(String productId) => state.contains(productId);
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

/// Favorite products resolved from the static product pipeline.
final favoriteProductsProvider = FutureProvider<List<Product>>((ref) async {
  final ids = ref.watch(favoritesProvider);
  final all = await ProductLoader.instance.load();
  return all.where((p) => ids.contains(p.id)).toList();
});
