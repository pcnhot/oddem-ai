import 'package:equatable/equatable.dart';

import 'cart_item.dart';

/// Installation availability + ETA computed at checkout based on city and
/// supplier availability. ETA is intentionally a range and is only ever shown
/// at checkout — never elsewhere, and never as a fixed promise.
class InstallationEstimate extends Equatable {
  const InstallationEstimate({
    required this.city,
    required this.available,
    required this.message,
    this.minDays,
    this.maxDays,
  });

  final String city;
  final bool available;

  /// Human-readable Arabic message shown at checkout.
  final String message;

  final int? minDays;
  final int? maxDays;

  @override
  List<Object?> get props => [city, available, minDays, maxDays];
}

/// A placed order.
class Order extends Equatable {
  const Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.shipping,
    required this.total,
    required this.city,
    required this.address,
    required this.placedAt,
    this.installation,
  });

  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double shipping;
  final double total;
  final String city;
  final String address;
  final DateTime placedAt;
  final InstallationEstimate? installation;

  @override
  List<Object?> get props => [id, total, placedAt];
}
