import 'package:equatable/equatable.dart';

/// Authenticated user. Backend-ready minimal shape for the MVP.
class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.city,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? city;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String?,
        city: json['city'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
      };

  @override
  List<Object?> get props => [id, email];
}
