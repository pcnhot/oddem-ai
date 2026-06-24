import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/category.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/supplier.dart';
import '../data/catalog_repository.dart';

/// Single source for the catalog repository. Override in tests or when the
/// real API client is ready.
final catalogRepositoryProvider = Provider<CatalogRepository>(
  (ref) => const MockCatalogRepository(),
);

final categoriesProvider = FutureProvider<List<Category>>((ref) {
  return ref.watch(catalogRepositoryProvider).getCategories();
});

final featuredProductsProvider = FutureProvider<List<Product>>((ref) {
  return ref.watch(catalogRepositoryProvider).getFeatured();
});

/// Currently selected category id (null = all). Drives the catalog list.
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Free-text search query.
final searchQueryProvider = StateProvider<String>((ref) => '');

final productListProvider = FutureProvider<List<Product>>((ref) {
  final categoryId = ref.watch(selectedCategoryProvider);
  final query = ref.watch(searchQueryProvider);
  return ref
      .watch(catalogRepositoryProvider)
      .getProducts(categoryId: categoryId, query: query);
});

final productByIdProvider = FutureProvider.family<Product?, String>((ref, id) {
  return ref.watch(catalogRepositoryProvider).getProductById(id);
});

final supplierByIdProvider =
    FutureProvider.family<Supplier?, String>((ref, id) {
  return ref.watch(catalogRepositoryProvider).getSupplierById(id);
});
