import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/product.dart';

/// 2D Planner placeholder. The real version will let users drag furniture on a
/// to-scale floor plan. For the MVP this is a non-interactive preview.
class Planner2DScreen extends StatelessWidget {
  const Planner2DScreen({super.key, this.product});

  final Product? product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(title: const Text('المخطط ثنائي الأبعاد')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: CustomPaint(
                  painter: _GridPainter(),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.grid_on,
                            size: 64, color: AppColors.midGrey),
                        const SizedBox(height: 12),
                        Text('مخطط ثنائي الأبعاد — قريبًا',
                            style: AppTextStyles.subtitle),
                        const SizedBox(height: 6),
                        Text(
                          product == null
                              ? 'وزّع قطع الأثاث على مخطط غرفتك حسب الأبعاد.'
                              : 'ضع «${product!.name}» داخل مخطط الغرفة.',
                          style: AppTextStyles.bodyMuted,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const _ComingSoonNote(),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.lightGrey
      ..strokeWidth = 1;
    const step = 28.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ComingSoonNote extends StatelessWidget {
  const _ComingSoonNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.navy),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'هذه ميزة تجريبية ضمن النسخة الأولى وسيتم تفعيل السحب والإفلات لاحقًا.',
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
