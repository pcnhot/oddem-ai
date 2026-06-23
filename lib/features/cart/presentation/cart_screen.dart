import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/models/cart_item.dart';
import '../../../shared/widgets/app_image.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/quantity_selector.dart';
import 'cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final subtotal = ref.watch(cartSubtotalProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('سلة التسوّق'),
        automaticallyImplyLeading: false,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => ref.read(cartProvider.notifier).clear(),
              child: const Text('تفريغ'),
            ),
        ],
      ),
      body: items.isEmpty
          ? EmptyState(
              icon: Icons.shopping_bag_outlined,
              title: 'سلتك فارغة',
              message: 'أضف بعض المنتجات لتبدأ الطلب.',
              actionLabel: 'تصفّح المنتجات',
              onAction: () => context.go(AppRoutes.catalog),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _CartTile(item: items[i]),
                  ),
                ),
                _Summary(subtotal: subtotal),
              ],
            ),
    );
  }
}

class _CartTile extends ConsumerWidget {
  const _CartTile({required this.item});
  final CartItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(cartProvider.notifier);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            height: 84,
            child: AppImage(
              path: item.product.imageUrls.isNotEmpty
                  ? item.product.imageUrls.first
                  : null,
              radius: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(item.product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body
                              .copyWith(fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 20,
                        icon: const Icon(Icons.delete_outline,
                            color: AppColors.midGrey),
                        onPressed: () => notifier.remove(item.product.id),
                      ),
                    ),
                  ],
                ),
                if (item.selectedColor != null) ...[
                  const SizedBox(height: 2),
                  Text('اللون: ${item.selectedColor!.name}',
                      style: AppTextStyles.caption),
                ],
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    QuantitySelector(
                      quantity: item.quantity,
                      onIncrement: () => notifier.increment(item.product.id),
                      onDecrement: () => notifier.decrement(item.product.id),
                    ),
                    const Spacer(),
                    Flexible(
                      child: Text(
                        Formatters.price(item.lineTotal),
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.price.copyWith(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.subtotal});
  final double subtotal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الإجمالي الفرعي', style: AppTextStyles.body),
                Text(Formatters.price(subtotal), style: AppTextStyles.price),
              ],
            ),
            const SizedBox(height: 4),
            // NOTE: installation ETA is intentionally NOT shown here — only at
            // checkout, based on city + availability.
            Text(
              'يتم احتساب الشحن وتقدير التركيب عند إتمام الطلب.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push(AppRoutes.checkout),
              child: const Text('إتمام الطلب'),
            ),
          ],
        ),
      ),
    );
  }
}
