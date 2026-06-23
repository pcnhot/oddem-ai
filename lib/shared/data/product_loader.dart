import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Loads Odem products from the bundled static JSON (`assets/data/products.json`)
/// and maps the ingestion schema onto the app's [Product] model.
///
/// No backend, no database, no packages — just `rootBundle` + `dart:convert`.
/// The JSON schema is "IKEA-ready": curated retailer data (same fields) can be
/// dropped in later with no code changes. Provenance fields (`source`,
/// `productUrl`, `titleEn`, `currency`) are intentionally NOT surfaced to users.
class ProductLoader {
  ProductLoader._();
  static final ProductLoader instance = ProductLoader._();

  static const String _assetPath = 'assets/data/products.json';

  List<Product>? _cache;

  /// Loads and caches the product list. Safe to call repeatedly.
  Future<List<Product>> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final items = (decoded['products'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(_map)
        .toList();
    _cache = items;
    return items;
  }

  /// Maps one ingestion JSON entry to a [Product].
  Product _map(Map<String, dynamic> j) {
    final priceNew = (j['price'] as num?)?.toDouble() ?? 0;
    final oldPrice = (j['oldPrice'] as num?)?.toDouble();
    final hasDiscount = oldPrice != null && oldPrice > priceNew;

    return Product(
      id: (j['id'] as String?) ?? (j['sku'] as String?) ?? UniqueId.next(),
      sku: (j['sku'] as String?) ?? (j['id'] as String?) ?? '',
      name: (j['titleAr'] as String?) ??
          (j['titleEn'] as String?) ??
          (j['name'] as String?) ??
          '',
      description: (j['descriptionAr'] as String?) ??
          (j['description'] as String?) ??
          '',
      categoryId: _categoryId(j['category']) ??
          (j['categoryId'] as String?) ??
          'cat_sofa',
      supplierId: _supplierId(j['source']) ??
          (j['supplierId'] as String?) ??
          'sup_seed',
      // Model price = the original (higher) price; discountPrice = the lower
      // current selling price when an oldPrice is present.
      price: hasDiscount ? oldPrice : priceNew,
      discountPrice: hasDiscount ? priceNew : null,
      dimensions: _dimensions(j['dimensions']),
      material: (j['material'] as String?) ?? '',
      colors: _colors(j),
      stock: _stock(j['availability']),
      imageUrls: _images(j['images'] ?? j['imageUrl']),
      rating: (j['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (j['reviewCount'] as num?)?.toInt() ?? 0,
      style: j['style'] as String?,
      roomType: j['roomType'] as String?,
      // AR model fields are never sourced/shown in the MVP.
      glbUrl: null,
      usdzUrl: null,
    );
  }

  Dimensions _dimensions(dynamic d) {
    if (d is Map<String, dynamic>) {
      return Dimensions(
        widthCm: (d['widthCm'] as num?)?.toDouble() ?? 0,
        depthCm: (d['depthCm'] as num?)?.toDouble() ?? 0,
        heightCm: (d['heightCm'] as num?)?.toDouble() ?? 0,
      );
    }
    return const Dimensions(widthCm: 0, depthCm: 0, heightCm: 0);
  }

  List<ProductColor> _colors(Map<String, dynamic> j) {
    final out = <ProductColor>[];
    final list = j['colors'];
    if (list is List) {
      for (final c in list) {
        if (c is Map<String, dynamic>) {
          out.add(ProductColor(
            name: (c['name'] as String?) ?? '',
            hex: (c['hex'] as String?) ?? '#8C8674',
          ));
        }
      }
    } else if (j['color'] is String && (j['color'] as String).isNotEmpty) {
      out.add(ProductColor(
        name: j['color'] as String,
        hex: (j['colorHex'] as String?) ?? '#8C8674',
      ));
    }
    return out;
  }

  /// availability → stock count. Strings map to in/out of stock; numbers pass
  /// through as a unit count.
  int _stock(dynamic availability) {
    if (availability is num) return availability.toInt();
    if (availability is String) {
      final v = availability.trim().toLowerCase();
      const outValues = {'out_of_stock', 'out', 'unavailable', 'غير متوفر'};
      return outValues.contains(v) ? 0 : 12;
    }
    return 12;
  }

  /// Resolves image references to asset paths. Bare filenames are assumed to
  /// live directly in `assets/images/`. Empty/missing → [] (Odem placeholder).
  List<String> _images(dynamic raw) {
    final out = <String>[];
    void add(String? s) {
      if (s == null || s.trim().isEmpty) return;
      final v = s.trim();
      if (v.startsWith('assets/') || v.startsWith('http')) {
        out.add(v);
      } else {
        out.add('assets/images/$v');
      }
    }

    if (raw is List) {
      for (final s in raw) {
        if (s is String) add(s);
      }
    } else if (raw is String) {
      add(raw);
    }
    return out;
  }

  /// Maps a category slug to an existing Odem category id.
  String? _categoryId(dynamic category) {
    if (category is! String) return null;
    switch (category.trim().toLowerCase()) {
      case 'sofas':
      case 'sofa':
      case 'sectional':
      case 'corner_sofa':
        return 'cat_sofa';
      case 'armchair':
      case 'chair':
      case 'chairs':
        return 'cat_chair';
      case 'coffee_table':
      case 'side_table':
      case 'table':
      case 'tables':
        return 'cat_table';
      case 'tv_unit':
      case 'storage':
      case 'cabinet':
        return 'cat_storage';
      case 'lighting':
      case 'lamp':
        return 'cat_lighting';
      case 'rug':
      case 'decor':
        return 'cat_decor';
      case 'bed':
      case 'beds':
        return 'cat_bed';
      case 'dining':
        return 'cat_dining';
      default:
        return null;
    }
  }

  /// Maps a retailer source to an Odem supplier id (see MockData.suppliers).
  String? _supplierId(dynamic source) {
    if (source is! String) return null;
    switch (source.trim().toLowerCase()) {
      case 'ikea_sa':
      case 'ikea':
        return 'sup_ikea';
      case 'odem_seed':
        return 'sup_seed';
      default:
        return null;
    }
  }
}

/// Tiny fallback id generator for entries missing an id/sku.
class UniqueId {
  UniqueId._();
  static int _n = 0;
  static String next() => 'p_auto_${_n++}';
}
