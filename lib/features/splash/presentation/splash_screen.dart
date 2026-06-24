import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart' show AppRoutes;
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

/// Branded splash. Navigates to onboarding after a short delay.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) context.go(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Full Odem logo on a clean white card for contrast on the
            // deep-sage background.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Image.asset(
                'assets/images/odem_logo_transparent.png',
                width: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'تصميم يناسب غرفتك',
              style:
                  AppTextStyles.bodyMuted.copyWith(color: AppColors.lightGrey),
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation(AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
