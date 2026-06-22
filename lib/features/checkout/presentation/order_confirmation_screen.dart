import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import 'checkout_providers.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderControllerProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: order == null
            ? const Center(child: Text('لا يوجد طلب'))
            : ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 96,
                      height: 96,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          color: AppColors.white, size: 56),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('تم استلام طلبك بنجاح',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.headline),
                  const SizedBox(height: 8),
                  Text('رقم الطلب: ${order.id}',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMuted),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.scaffold,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _row('المدينة', order.city),
                        const SizedBox(height: 8),
                        _row('عدد القطع',
                            '${order.items.fold<int>(0, (s, i) => s + i.quantity)}'),
                        const SizedBox(height: 8),
                        _row('الإجمالي', Formatters.price(order.total)),
                        if (order.installation != null) ...[
                          const Divider(height: 24),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.handyman_outlined,
                                  size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(order.installation!.message,
                                    style: AppTextStyles.caption),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => context.go(AppRoutes.home),
                    child: const Text('العودة للرئيسية'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.catalog),
                    child: const Text('متابعة التسوّق'),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMuted),
        Text(value, style: AppTextStyles.body),
      ],
    );
  }
}
