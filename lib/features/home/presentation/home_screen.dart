import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/category_icon.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../catalog/presentation/catalog_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final featured = ref.watch(featuredProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Image.asset(
              'assets/images/odem_mark_transparent.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(AppConstants.appName,
                style: AppTextStyles.title.copyWith(letterSpacing: 2)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => context.push(AppRoutes.favorites),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.push(AppRoutes.help),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _SearchBar(onTap: () => context.go(AppRoutes.catalog)),
          const SizedBox(height: 16),
          _AiBanner(onTap: () => context.go(AppRoutes.aiDesigner)),
          const SizedBox(height: 16),
          const SectionHeader(title: 'التصنيفات'),
          SizedBox(
            height: 96,
            child: categories.when(
              data: (items) => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) {
                  final c = items[i];
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedCategoryProvider.notifier).state = c.id;
                      context.go(AppRoutes.catalog);
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(categoryIcon(c.iconName),
                              color: AppColors.primary),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 72,
                          child: Text(
                            c.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) => const SizedBox(),
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(
            title: 'عروض مختارة',
            actionLabel: 'الكل',
            onAction: () => context.go(AppRoutes.catalog),
          ),
          featured.when(
            data: (items) => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.62,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) => ProductCard(
                product: items[i],
                onTap: () =>
                    context.push('${AppRoutes.productDetail}/${items[i].id}'),
              ),
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.midGrey),
            const SizedBox(width: 10),
            Text('ابحث عن أثاث، كنب، طاولات...',
                style: AppTextStyles.bodyMuted),
          ],
        ),
      ),
    );
  }
}

class _AiBanner extends StatelessWidget {
  const _AiBanner({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.navy],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('صمّم غرفتك بالذكاء الاصطناعي',
                      style: AppTextStyles.title
                          .copyWith(color: AppColors.white)),
                  const SizedBox(height: 6),
                  Text(
                    'اختر النوع، الميزانية والطراز ودعنا نقترح القطع المناسبة.',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.lightGrey),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: AppColors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
