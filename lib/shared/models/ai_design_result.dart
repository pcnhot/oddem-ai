import 'package:equatable/equatable.dart';

import 'product.dart';

/// The result returned by the AI designer: a curated set of recommended
/// products plus a short rationale and an estimated total.
class AiDesignResult extends Equatable {
  const AiDesignResult({
    required this.title,
    required this.summary,
    required this.recommendedProducts,
    required this.estimatedTotal,
    required this.style,
    required this.roomType,
    this.strictMode = false,
    this.strictReplaceItem,
  });

  final String title;
  final String summary;
  final List<Product> recommendedProducts;
  final double estimatedTotal;
  final String style;
  final String roomType;

  /// True when only a single item was changed (StrictMode).
  final bool strictMode;
  final String? strictReplaceItem;

  @override
  List<Object?> get props => [
        title,
        recommendedProducts,
        estimatedTotal,
        style,
        roomType,
        strictMode,
      ];
}
