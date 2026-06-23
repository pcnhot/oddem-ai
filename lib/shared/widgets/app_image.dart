import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Renders a product/asset image with a graceful branded fallback.
///
/// Image assets aren't bundled in the MVP, so this widget always falls back to
/// a tasteful placeholder. When real assets/URLs are added, the
/// [Image.asset]/[Image.network] error builders keep the UI resilient.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.path,
    this.icon = Icons.chair_outlined,
    this.fit = BoxFit.cover,
    this.radius = 0,
  });

  final String? path;
  final IconData icon;
  final BoxFit fit;
  final double radius;

  bool get _isNetwork => path != null && path!.startsWith('http');

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (path == null || path!.isEmpty) {
      child = _placeholder();
    } else if (_isNetwork) {
      child = Image.network(
        path!,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
        loadingBuilder: (_, w, p) => p == null ? w : _placeholder(),
      );
    } else {
      child = Image.asset(
        path!,
        fit: fit,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return radius > 0
        ? ClipRRect(borderRadius: BorderRadius.circular(radius), child: child)
        : child;
  }

  Widget _placeholder() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF2F4F6), Color(0xFFE7EAED)],
        ),
      ),
      child: Center(
        child: LayoutBuilder(
          builder: (context, c) {
            final s = c.maxHeight.isFinite ? c.maxHeight : 120.0;
            final box = (s * 0.34).clamp(28.0, 56.0);
            return Container(
              width: box,
              height: box,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(box * 0.28),
              ),
              child: Icon(icon, size: box * 0.56, color: AppColors.midGrey),
            );
          },
        ),
      ),
    );
  }
}
