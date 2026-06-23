import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../features/favorites/presentation/favorites_providers.dart';
import '../models/product.dart';
import 'app_image.dart';

/// Catalog/grid product card with favorite toggle and price.
class ProductCard extends ConsumerWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFav = ref.watch(favoritesProvider).contains(product.id);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.2,
                  child: AppImage(
                    path: product.imageUrls.isNotEmpty
                        ? product.imageUrls.first
                        : null,
                  ),
                ),
                if (product.hasDiscount)
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: _badge('خصم', AppColors.navy),
                  ),
                if (!product.inStock)
                  PositionedDirectional(
                    top: 8,
                    end: 8,
                    child: _badge('غير متوفر', AppColors.midGrey),
                  ),
                PositionedDirectional(
                  bottom: 6,
                  end: 6,
                  child: Material(
                    color: AppColors.white,
                    shape: const CircleBorder(),
                    elevation: 1,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => ref
                          .read(favoritesProvider.notifier)
                          .toggle(product.id),
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          size: 20,
                          color: isFav ? AppColors.error : AppColors.midGrey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 14, color: AppColors.warning),
                      const SizedBox(width: 2),
                      Text('${product.rating}', style: AppTextStyles.caption),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          Formatters.price(product.effectivePrice),
                          style: AppTextStyles.price.copyWith(fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: 6),
                        Text(
                          Formatters.price(product.price),
                          style: AppTextStyles.caption.copyWith(
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
