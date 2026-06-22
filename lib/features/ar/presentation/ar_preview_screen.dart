import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/product.dart';

/// AR Preview placeholder. The real version will load the product's GLB (Android)
/// or USDZ (iOS) model into an AR scene. For the MVP this shows the model URLs
/// and a placeholder viewport.
class ArPreviewScreen extends StatelessWidget {
  const ArPreviewScreen({super.key, this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      appBar: AppBar(
        backgroundColor: AppColors.navy,
        foregroundColor: AppColors.white,
        title: const Text('معاينة بالواقع المعزز'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(Icons.view_in_ar,
                      size: 64, color: AppColors.white),
                ),
                const SizedBox(height: 20),
                Text('معاينة AR — قريبًا',
                    style: AppTextStyles.title
                        .copyWith(color: AppColors.white)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    product == null
                        ? 'وجّه الكاميرا نحو غرفتك لمعاينة الأثاث بالحجم الحقيقي.'
                        : 'سيتم عرض «${product!.name}» بالحجم الحقيقي داخل غرفتك.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMuted
                        .copyWith(color: AppColors.lightGrey),
                  ),
                ),
              ],
            ),
          ),
          if (product != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _row('GLB (Android)', product!.glbUrl ?? '—'),
                    const SizedBox(height: 6),
                    _row('USDZ (iOS)', product!.usdzUrl ?? '—'),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: AppTextStyles.caption
                  .copyWith(color: AppColors.lightGrey)),
        ),
        Expanded(
          child: Text(value,
              style: AppTextStyles.caption.copyWith(color: AppColors.white),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
