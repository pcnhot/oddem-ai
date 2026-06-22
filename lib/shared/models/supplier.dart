import 'package:equatable/equatable.dart';

/// A furniture supplier / vendor. Backend-ready shape.
class Supplier extends Equatable {
  const Supplier({
    required this.id,
    required this.name,
    required this.city,
    this.logoUrl,
    this.rating = 0,
    this.isVerified = false,
    this.servedCities = const <String>[],
  });

  final String id;
  final String name;
  final String city;
  final String? logoUrl;
  final double rating;
  final bool isVerified;

  /// Cities this supplier can deliver / install in. Used for installation
  /// availability at checkout.
  final List<String> servedCities;

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: json['id'] as String,
        name: json['name'] as String,
        city: json['city'] as String,
        logoUrl: json['logoUrl'] as String?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        isVerified: json['isVerified'] as bool? ?? false,
        servedCities: (json['servedCities'] as List?)?.cast<String>() ??
            const <String>[],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'city': city,
        'logoUrl': logoUrl,
        'rating': rating,
        'isVerified': isVerified,
        'servedCities': servedCities,
      };

  @override
  List<Object?> get props => [id, name, city, rating, isVerified];
}
