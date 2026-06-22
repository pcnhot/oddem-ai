import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../auth/presentation/auth_providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('حسابي'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.navy,
                  child: Text(
                    (user?.name.isNotEmpty == true ? user!.name[0] : 'ض'),
                    style: AppTextStyles.title.copyWith(color: AppColors.white),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.name ?? 'زائر', style: AppTextStyles.title),
                      const SizedBox(height: 4),
                      Text(user?.email ?? 'لم يتم تسجيل الدخول',
                          style: AppTextStyles.bodyMuted),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _tile(Icons.receipt_long_outlined, 'طلباتي', () {}),
          _tile(Icons.favorite_border, 'المفضلة',
              () => context.push(AppRoutes.favorites)),
          _tile(Icons.location_on_outlined, 'العناوين', () {}),
          _tile(Icons.auto_awesome_outlined, 'تصاميمي', () {}),
          const SizedBox(height: 12),
          _tile(Icons.help_outline, 'المساعدة والسياسات',
              () => context.push(AppRoutes.help)),
          _tile(Icons.info_outline, 'عن ${AppConstants.appName}', () {}),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) context.go(AppRoutes.login);
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(user == null ? 'تسجيل الدخول' : 'تسجيل الخروج',
                  style: const TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text('الإصدار 0.1.0 — السعودية',
                style: AppTextStyles.caption),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _tile(IconData icon, String label, VoidCallback onTap) {
    return Container(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 1),
      child: ListTile(
        leading: Icon(icon, color: AppColors.navy),
        title: Text(label, style: AppTextStyles.body),
        trailing: const Icon(Icons.chevron_left, color: AppColors.midGrey),
        onTap: onTap,
      ),
    );
  }
}
