import 'package:equatable/equatable.dart';

/// Physical dimensions in centimeters.
class Dimensions extends Equatable {
  const Dimensions({
    required this.widthCm,
    required this.depthCm,
    required this.heightCm,
  });

  final double widthCm;
  final double depthCm;
  final double heightCm;

  factory Dimensions.fromJson(Map<String, dynamic> json) => Dimensions(
        widthCm: (json['widthCm'] as num).toDouble(),
        depthCm: (json['depthCm'] as num).toDouble(),
        heightCm: (json['heightCm'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'widthCm': widthCm,
        'depthCm': depthCm,
        'heightCm': heightCm,
      };

  @override
  List<Object?> get props => [widthCm, depthCm, heightCm];
}

/// A selectable color variant for a product.
class ProductColor extends Equatable {
  const ProductColor({
    required this.name,
    required this.hex,
  });

  final String name;

  /// Hex string e.g. `#34404C`.
  final String hex;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        name: json['name'] as String,
        hex: json['hex'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'hex': hex};

  @override
  List<Object?> get props => [name, hex];
}

/// Core product entity. Backend-ready: supports SKU, supplier, price,
/// dimensions, colors, material, stock and AR model URLs (GLB/USDZ).
class Product extends Equatable {
  const Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.supplierId,
    required this.price,
    required this.dimensions,
    required this.material,
    required this.colors,
    required this.stock,
    required this.imageUrls,
    this.discountPrice,
    this.rating = 0,
    this.reviewCount = 0,
    this.style,
    this.roomType,
    this.glbUrl,
    this.usdzUrl,
  });

  final String id;
  final String sku;
  final String name;
  final String description;
  final String categoryId;
  final String supplierId;

  /// Base price in SAR.
  final double price;

  /// Optional promotional price in SAR.
  final double? discountPrice;

  final Dimensions dimensions;
  final String material;
  final List<ProductColor> colors;

  /// Available units in stock.
  final int stock;

  final List<String> imageUrls;
  final double rating;
  final int reviewCount;

  /// Design style tag (e.g. حديث / كلاسيكي) used by the AI designer.
  final String? style;

  /// Suitable room type (e.g. مجلس) used by the AI designer.
  final String? roomType;

  /// AR model assets.
  final String? glbUrl; // Android (glTF)
  final String? usdzUrl; // iOS (USDZ)

  bool get inStock => stock > 0;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  double get effectivePrice => hasDiscount ? discountPrice! : price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        sku: json['sku'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        categoryId: json['categoryId'] as String,
        supplierId: json['supplierId'] as String,
        price: (json['price'] as num).toDouble(),
        discountPrice: (json['discountPrice'] as num?)?.toDouble(),
        dimensions:
            Dimensions.fromJson(json['dimensions'] as Map<String, dynamic>),
        material: json['material'] as String? ?? '',
        colors: (json['colors'] as List? ?? [])
            .map((e) => ProductColor.fromJson(e as Map<String, dynamic>))
            .toList(),
        stock: json['stock'] as int? ?? 0,
        imageUrls: (json['imageUrls'] as List? ?? []).cast<String>(),
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        style: json['style'] as String?,
        roomType: json['roomType'] as String?,
        glbUrl: json['glbUrl'] as String?,
        usdzUrl: json['usdzUrl'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'sku': sku,
        'name': name,
        'description': description,
        'categoryId': categoryId,
        'supplierId': supplierId,
        'price': price,
        'discountPrice': discountPrice,
        'dimensions': dimensions.toJson(),
        'material': material,
        'colors': colors.map((e) => e.toJson()).toList(),
        'stock': stock,
        'imageUrls': imageUrls,
        'rating': rating,
        'reviewCount': reviewCount,
        'style': style,
        'roomType': roomType,
        'glbUrl': glbUrl,
        'usdzUrl': usdzUrl,
      };

  @override
  List<Object?> get props => [id, sku];
}
