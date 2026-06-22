import 'package:equatable/equatable.dart';

/// A product category (e.g. Sofas, Beds, Dining).
class Category extends Equatable {
  const Category({
    required this.id,
    required this.name,
    required this.iconName,
    this.imageUrl,
  });

  final String id;
  final String name;

  /// Material icon name resolved in the UI layer (keeps the model UI-agnostic).
  final String iconName;
  final String? imageUrl;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        iconName: json['iconName'] as String? ?? 'chair',
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'iconName': iconName,
        'imageUrl': imageUrl,
      };

  @override
  List<Object?> get props => [id, name, iconName, imageUrl];
}
