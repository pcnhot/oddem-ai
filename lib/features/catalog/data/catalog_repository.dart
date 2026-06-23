import '../../../shared/data/mock_data.dart';
import '../../../shared/data/product_loader.dart';
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

/// Products are loaded from the bundled static JSON (assets/data/products.json)
/// via [ProductLoader]; categories and suppliers still come from [MockData].
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
    var items = await ProductLoader.instance.load();
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
    final items = await ProductLoader.instance.load();
    for (final p in items) {
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
    final items = await ProductLoader.instance.load();
    return items.where((p) => p.hasDiscount).toList();
  }
}
