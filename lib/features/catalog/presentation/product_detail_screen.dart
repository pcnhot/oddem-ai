import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/app_image.dart';
import '../../cart/presentation/cart_providers.dart';
import '../../favorites/presentation/favorites_providers.dart';
import 'catalog_providers.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(productByIdProvider(widget.productId));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text('تفاصيل المنتج')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('تعذّر تحميل المنتج')),
        data: (product) {
          if (product == null) {
            return const Center(child: Text('المنتج غير موجود'));
          }
          return _buildBody(product);
        },
      ),
    );
  }

  Widget _buildBody(Product product) {
    final supplier = ref.watch(supplierByIdProvider(product.supplierId));
    final isFav = ref.watch(favoritesProvider).contains(product.id);
    final color =
        product.colors.isNotEmpty ? product.colors[_colorIndex] : null;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1,
                    child: AppImage(
                      path: product.imageUrls.isNotEmpty
                          ? product.imageUrls.first
                          : null,
                    ),
                  ),
                  PositionedDirectional(
                    top: 12,
                    end: 12,
                    child: CircleAvatar(
                      backgroundColor: AppColors.white,
                      child: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? AppColors.error : AppColors.navy,
                        ),
                        onPressed: () => ref
                            .read(favoritesProvider.notifier)
                            .toggle(product.id),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name, style: AppTextStyles.headline),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text('${product.rating} (${product.reviewCount})',
                            style: AppTextStyles.caption),
                        const SizedBox(width: 12),
                        Text('SKU: ${product.sku}',
                            style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(Formatters.price(product.effectivePrice),
                            style: AppTextStyles.price.copyWith(fontSize: 24)),
                        if (product.hasDiscount) ...[
                          const SizedBox(width: 10),
                          Text(
                            Formatters.price(product.price),
                            style: AppTextStyles.bodyMuted.copyWith(
                                decoration: TextDecoration.lineThrough),
                          ),
                        ],
                        const Spacer(),
                        _stockChip(product),
                      ],
                    ),
                    const Divider(height: 32),
                    supplier.when(
                      data: (s) => s == null
                          ? const SizedBox()
                          : Row(
                              children: [
                                const Icon(Icons.storefront_outlined,
                                    size: 18, color: AppColors.midGrey),
                                const SizedBox(width: 8),
                                Text(s.name, style: AppTextStyles.body),
                                if (s.isVerified) ...[
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified,
                                      size: 16, color: AppColors.navy),
                                ],
                              ],
                            ),
                      loading: () => const SizedBox(),
                      error: (_, __) => const SizedBox(),
                    ),
                    const SizedBox(height: 16),
                    Text('الوصف', style: AppTextStyles.subtitle),
                    const SizedBox(height: 6),
                    Text(product.description, style: AppTextStyles.bodyMuted),
                    const SizedBox(height: 20),
                    if (product.colors.isNotEmpty) ...[
                      Text('اللون: ${color?.name ?? ''}',
                          style: AppTextStyles.subtitle),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          for (var i = 0; i < product.colors.length; i++)
                            _colorDot(product, i),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                    Text('المواصفات', style: AppTextStyles.subtitle),
                    const SizedBox(height: 10),
                    _spec('الأبعاد', Formatters.dimensions(
                      widthCm: product.dimensions.widthCm,
                      depthCm: product.dimensions.depthCm,
                      heightCm: product.dimensions.heightCm,
                    )),
                    _spec('الخامة', product.material),
                    _spec('المخزون', '${product.stock} قطعة'),
                    const SizedBox(height: 20),
                    _arRow(context, product),
                  ],
                ),
              ),
            ],
          ),
        ),
        _bottomBar(product, color),
      ],
    );
  }

  Widget _stockChip(Product p) {
    final ok = p.inStock;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: (ok ? AppColors.success : AppColors.midGrey)
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        ok ? 'متوفر' : 'غير متوفر',
        style: AppTextStyles.caption.copyWith(
          color: ok ? AppColors.success : AppColors.midGrey,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _colorDot(Product product, int i) {
    final c = product.colors[i];
    final hex = int.parse('FF${c.hex.replaceAll('#', '')}', radix: 16);
    final selected = i == _colorIndex;
    return GestureDetector(
      onTap: () => setState(() => _colorIndex = i),
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 12),
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: 2,
          ),
        ),
        child: CircleAvatar(radius: 14, backgroundColor: Color(hex)),
      ),
    );
  }

  Widget _spec(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(label, style: AppTextStyles.bodyMuted),
          ),
          Expanded(child: Text(value, style: AppTextStyles.body)),
        ],
      ),
    );
  }

  Widget _arRow(BuildContext context, Product product) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.arPreview, extra: product),
            icon: const Icon(Icons.view_in_ar),
            label: const Text('معاينة AR'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push(AppRoutes.planner2d, extra: product),
            icon: const Icon(Icons.grid_on),
            label: const Text('مخطط 2D'),
          ),
        ),
      ],
    );
  }

  Widget _bottomBar(Product product, dynamic color) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: product.inStock
                    ? () {
                        ref.read(cartProvider.notifier).add(
                              product as Product,
                              color: color,
                            );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('تمت الإضافة إلى السلة')),
                        );
                      }
                    : null,
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('أضف إلى السلة'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
