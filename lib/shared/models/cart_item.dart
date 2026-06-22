import 'package:equatable/equatable.dart';

import 'product.dart';

/// A single line in the cart: a product + selected options + quantity.
class CartItem extends Equatable {
  const CartItem({
    required this.product,
    required this.quantity,
    this.selectedColor,
  });

  final Product product;
  final int quantity;
  final ProductColor? selectedColor;

  double get lineTotal => product.effectivePrice * quantity;

  CartItem copyWith({int? quantity, ProductColor? selectedColor}) => CartItem(
        product: product,
        quantity: quantity ?? this.quantity,
        selectedColor: selectedColor ?? this.selectedColor,
      );

  @override
  List<Object?> get props => [product.id, selectedColor, quantity];
}
