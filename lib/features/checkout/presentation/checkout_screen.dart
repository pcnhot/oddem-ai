import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../cart/presentation/cart_providers.dart';
import 'checkout_providers.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final _address = TextEditingController();

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final order = await ref
        .read(orderControllerProvider.notifier)
        .place(address: _address.text.trim());
    if (order != null && mounted) {
      context.go(AppRoutes.orderConfirmation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final city = ref.watch(checkoutCityProvider);
    final subtotal = ref.watch(cartSubtotalProvider);
    final shipping = ref.watch(shippingFeeProvider);
    final estimate = ref.watch(installationEstimateProvider);
    final placing = ref.watch(orderControllerProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('إتمام الطلب')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        children: [
          const Text('مدينة التوصيل والتركيب', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: city,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            items: [
              for (final c in AppConstants.saudiCities)
                DropdownMenuItem(value: c, child: Text(c)),
            ],
            onChanged: (v) {
              if (v != null) {
                ref.read(checkoutCityProvider.notifier).state = v;
              }
            },
          ),
          const SizedBox(height: 16),
          const Text('العنوان', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          TextField(
            controller: _address,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'الحي، الشارع، رقم المبنى...',
              prefixIcon: Icon(Icons.home_outlined),
            ),
          ),
          const SizedBox(height: 20),

          // Installation ETA — shown ONLY here, computed from city + availability.
          _InstallationCard(estimate: estimate),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _row('الإجمالي الفرعي', Formatters.price(subtotal)),
                const SizedBox(height: 8),
                _row('الشحن', Formatters.price(shipping)),
                const Divider(height: 24),
                _row('الإجمالي', Formatters.price(subtotal + shipping),
                    bold: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('طريقة الدفع: الدفع عند الاستلام (تجريبي)',
              style: AppTextStyles.caption),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: placing ? null : _placeOrder,
            child: placing
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.4, color: AppColors.white),
                  )
                : const Text('تأكيد الطلب'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: bold ? AppTextStyles.subtitle : AppTextStyles.bodyMuted),
        Text(value, style: bold ? AppTextStyles.price : AppTextStyles.body),
      ],
    );
  }
}

class _InstallationCard extends StatelessWidget {
  const _InstallationCard({required this.estimate});
  final AsyncValue estimate;

  @override
  Widget build(BuildContext context) {
    final available = estimate.valueOrNull?.available ?? true;
    final accent = available ? AppColors.primary : AppColors.warning;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.handyman_outlined, color: accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: estimate.when(
              data: (est) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('تقدير التركيب',
                          style: AppTextStyles.subtitle),
                      const SizedBox(width: 8),
                      _StatusPill(available: est.available),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(est.message,
                      style: AppTextStyles.bodyMuted.copyWith(height: 1.6)),
                ],
              ),
              loading: () => const Row(
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 10),
                  Text('جارٍ حساب تقدير التركيب...',
                      style: AppTextStyles.bodyMuted),
                ],
              ),
              error: (_, __) => const Text('تعذّر حساب تقدير التركيب حاليًا.',
                  style: AppTextStyles.bodyMuted),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.available});
  final bool available;

  @override
  Widget build(BuildContext context) {
    final color = available ? AppColors.success : AppColors.warning;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        available ? 'متاح' : 'يُنسّق لاحقًا',
        style: AppTextStyles.caption
            .copyWith(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}
