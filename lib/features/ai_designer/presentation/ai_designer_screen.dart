import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/product_card.dart';
import '../../../shared/widgets/section_header.dart';
import 'ai_designer_providers.dart';

class AiDesignerScreen extends ConsumerWidget {
  const AiDesignerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(aiRequestProvider);
    final result = ref.watch(aiDesignControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      appBar: AppBar(
        title: const Text('المصمم بالذكاء الاصطناعي'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'محادثة مع المصمم',
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () => context.push(AppRoutes.aiChat),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('أخبرنا عن غرفتك وسنقترح لك تصميمًا متكاملاً',
              style: AppTextStyles.bodyMuted),
          const SizedBox(height: 16),

          _ChatEntryCard(onTap: () => context.push(AppRoutes.aiChat)),
          const SizedBox(height: 16),

          Text('نوع الغرفة', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          _wrapChoices(
            options: AppConstants.roomTypes,
            value: request.roomType,
            onSelected: (v) => ref.read(aiRequestProvider.notifier).state =
                request.copyWith(roomType: v),
          ),
          const SizedBox(height: 16),

          Text('الطراز', style: AppTextStyles.subtitle),
          const SizedBox(height: 8),
          _wrapChoices(
            options: AppConstants.designStyles,
            value: request.style,
            onSelected: (v) => ref.read(aiRequestProvider.notifier).state =
                request.copyWith(style: v),
          ),
          const SizedBox(height: 20),

          Text('الميزانية: ${request.budget.toStringAsFixed(0)} ر.س',
              style: AppTextStyles.subtitle),
          Slider(
            value: request.budget,
            min: 3000,
            max: 60000,
            divisions: 57,
            activeColor: AppColors.primary,
            label: request.budget.toStringAsFixed(0),
            onChanged: (v) => ref.read(aiRequestProvider.notifier).state =
                request.copyWith(budget: v),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.roomPhotoUpload),
                  icon: const Icon(Icons.add_a_photo_outlined),
                  label: Text(request.roomPhotoPath == null
                      ? 'رفع صورة'
                      : 'تم رفع صورة'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push(AppRoutes.roomDimensions),
                  icon: const Icon(Icons.straighten),
                  label: Text(request.dimensions == null
                      ? 'إدخال الأبعاد'
                      : 'تم إدخال الأبعاد'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          _StrictModeCard(),
          const SizedBox(height: 16),

          ElevatedButton.icon(
            onPressed: result.isLoading
                ? null
                : () => ref
                    .read(aiDesignControllerProvider.notifier)
                    .generate(request),
            icon: result.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.2, color: AppColors.white),
                  )
                : const Icon(Icons.auto_awesome),
            label: Text(result.isLoading ? 'جارٍ التصميم...' : 'أنشئ التصميم'),
          ),
          const SizedBox(height: 24),

          result.when(
            data: (data) {
              if (data == null) return const SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.auto_awesome,
                                color: AppColors.primary, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(data.title,
                                  style: AppTextStyles.subtitle),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(data.summary, style: AppTextStyles.bodyMuted),
                        const SizedBox(height: 12),
                        Text(
                          'التكلفة التقديرية: ${data.estimatedTotal.toStringAsFixed(0)} ر.س',
                          style: AppTextStyles.price.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SectionHeader(title: 'القطع المقترحة'),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.recommendedProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (_, i) => ProductCard(
                      product: data.recommendedProducts[i],
                      onTap: () => context.push(
                          '${AppRoutes.productDetail}/${data.recommendedProducts[i].id}'),
                    ),
                  ),
                ],
              );
            },
            loading: () => const SizedBox(),
            error: (_, __) => Text('تعذّر إنشاء التصميم، حاول مجددًا',
                style: AppTextStyles.caption
                    .copyWith(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  Widget _wrapChoices({
    required List<String> options,
    required String value,
    required ValueChanged<String> onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          ChoiceChip(
            label: Text(o),
            selected: o == value,
            onSelected: (_) => onSelected(o),
          ),
      ],
    );
  }
}

/// Entry point to the local mock chat with the ODDEM designer.
class _ChatEntryCard extends StatelessWidget {
  const _ChatEntryCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.chat_bubble_outline,
                  color: AppColors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('محادثة مع مصمم ODDEM', style: AppTextStyles.subtitle),
                  const SizedBox(height: 2),
                  Text('اسأل المصمم واحصل على اقتراحات فورية',
                      style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_left, color: AppColors.midGrey),
          ],
        ),
      ),
    );
  }
}

/// StrictMode: change only ONE item in the room while keeping the rest
/// exactly the same.
class _StrictModeCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(aiRequestProvider);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeColor: AppColors.primary,
            title: const Text('الوضع الصارم (StrictMode)'),
            subtitle: const Text(
                'تغيير عنصر واحد فقط في الغرفة مع الإبقاء على كل شيء آخر كما هو.'),
            value: request.strictMode,
            onChanged: (v) => ref.read(aiRequestProvider.notifier).state =
                request.copyWith(strictMode: v),
          ),
          if (request.strictMode)
            TextField(
              decoration: const InputDecoration(
                labelText: 'العنصر المراد تغييره (مثال: الكنبة)',
                prefixIcon: Icon(Icons.swap_horiz),
              ),
              onChanged: (v) => ref.read(aiRequestProvider.notifier).state =
                  request.copyWith(strictReplaceItem: v),
            ),
        ],
      ),
    );
  }
}
