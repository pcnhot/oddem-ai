import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'ai_designer_providers.dart';

/// Room photo upload. Image picking requires a plugin; for the MVP we simulate
/// a successful upload so the AI flow is fully navigable.
class RoomPhotoUploadScreen extends ConsumerWidget {
  const RoomPhotoUploadScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(aiRequestProvider);
    final hasPhoto = request.roomPhotoPath != null;

    return Scaffold(
      appBar: AppBar(title: const Text('رفع صورة الغرفة')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: DottedPlaceholder(
                hasPhoto: hasPhoto,
                path: request.roomPhotoPath,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'ارفع صورة واضحة لغرفتك ليتمكن المصمم من اقتراح القطع المناسبة وتوزيعها.',
              style: AppTextStyles.bodyMuted,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ref, source: 'camera'),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('الكاميرا'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pick(ref, source: 'gallery'),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('المعرض'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: hasPhoto ? () => context.pop() : null,
              child: const Text('حفظ ومتابعة'),
            ),
          ],
        ),
      ),
    );
  }

  void _pick(WidgetRef ref, {required String source}) {
    // MVP placeholder: record a fake local path. Replace with image_picker.
    final req = ref.read(aiRequestProvider);
    ref.read(aiRequestProvider.notifier).state =
        req.copyWith(roomPhotoPath: 'mock://room_photo_from_$source.jpg');
  }
}

class DottedPlaceholder extends StatelessWidget {
  const DottedPlaceholder({super.key, required this.hasPhoto, this.path});
  final bool hasPhoto;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.scaffold,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasPhoto ? AppColors.primary : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasPhoto ? Icons.check_circle : Icons.image_outlined,
              size: 64,
              color: hasPhoto ? AppColors.success : AppColors.midGrey,
            ),
            const SizedBox(height: 12),
            Text(
              hasPhoto ? 'تم اختيار صورة الغرفة' : 'لم يتم اختيار صورة بعد',
              style: AppTextStyles.bodyMuted,
            ),
          ],
        ),
      ),
    );
  }
}
