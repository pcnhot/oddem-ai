import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/product_card.dart';
import 'favorites_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoriteProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('المفضلة')),
      body: favorites.isEmpty
          ? EmptyState(
              icon: Icons.favorite_border,
              title: 'قائمة المفضلة فارغة',
              message: 'أضف المنتجات التي تعجبك لتجدها هنا بسهولة.',
              actionLabel: 'تصفّح المنتجات',
              onAction: () => context.go(AppRoutes.catalog),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) => ProductCard(
                product: favorites[i],
                onTap: () => context
                    .push('${AppRoutes.productDetail}/${favorites[i].id}'),
              ),
            ),
    );
  }
}
