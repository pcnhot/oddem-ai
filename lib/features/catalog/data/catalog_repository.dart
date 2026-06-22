import '../../../shared/data/mock_data.dart';
import '../../../shared/models/category.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/supplier.dart';

/// Abstraction over the catalog data source. Swap [MockCatalogRepository]
/// for an API-backed implementation without touching the UI.
abstract class CatalogRepository {
  Future<List<Category>> getCategories();
  Future<List<Product>> getProducts({String? categoryId, String? query});
  Future<Product?> getProductById(String id);
  Future<Supplier?> getSupplierById(String id);
  Future<List<Product>> getFeatured();
}

/// Mock implementation backed by [MockData]. Simulates small network latency.
class MockCatalogRepository implements CatalogRepository {
  const MockCatalogRepository();

  Future<void> _delay() =>
      Future<void>.delayed(const Duration(milliseconds: 250));

  @override
  Future<List<Category>> getCategories() async {
    await _delay();
    return MockData.categories;
  }

  @override
  Future<List<Product>> getProducts({String? categoryId, String? query}) async {
    await _delay();
    var items = MockData.products;
    if (categoryId != null && categoryId.isNotEmpty) {
      items = items.where((p) => p.categoryId == categoryId).toList();
    }
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim();
      items = items
          .where((p) =>
              p.name.contains(q) ||
              p.material.contains(q) ||
              (p.style?.contains(q) ?? false))
          .toList();
    }
    return items;
  }

  @override
  Future<Product?> getProductById(String id) async {
    await _delay();
    for (final p in MockData.products) {
      if (p.id == id) return p;
    }
    return null;
  }

  @override
  Future<Supplier?> getSupplierById(String id) async {
    for (final s in MockData.suppliers) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<List<Product>> getFeatured() async {
    await _delay();
    return MockData.products.where((p) => p.hasDiscount).toList();
  }
}
