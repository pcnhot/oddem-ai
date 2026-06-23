import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/app_image.dart';

/// "See the product in your room" placeholder. Customer-facing only — no
/// technical terms, no real camera/AR yet. Lets the user understand the value
/// (check size and color before buying) with a calm, branded screen.
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
        title: const Text('شاهد المنتج في غرفتك'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              if (product != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: AppImage(
                      path: product!.imageUrls.isNotEmpty
                          ? product!.imageUrls.first
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product!.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.title.copyWith(color: AppColors.white),
                ),
              ] else
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
              const SizedBox(height: 10),
              Text(
                'تأكد من الحجم واللون قبل الشراء',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMuted
                    .copyWith(color: AppColors.lightGrey),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    _Step(number: '1', text: 'حرّك الجوال على الأرض حتى تظهر النقطة'),
                    SizedBox(height: 12),
                    _Step(number: '2', text: 'اضغط لوضع المنتج في مكانه'),
                    SizedBox(height: 12),
                    _Step(number: '3', text: 'اسحب لتدوير المنتج وتغيير مكانه'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.white,
                    foregroundColor: AppColors.navy,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('نعمل على تجهيز المعاينة داخل غرفتك.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.center_focus_strong),
                  label: const Text('افتح المعاينة'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.16),
            shape: BoxShape.circle,
          ),
          child: Text(number,
              style: AppTextStyles.caption.copyWith(
                  color: AppColors.white, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text,
              style: AppTextStyles.body.copyWith(color: AppColors.white)),
        ),
      ],
    );
  }
}
