import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

/// Constrains the app to a mobile width and centers it horizontally on wide
/// (web / tablet) viewports, with a light neutral backdrop outside the frame.
///
/// On narrow phone screens the app simply fills the full width. This keeps
/// ODDEM a mobile-first experience and prevents the stretched/off-center look
/// on iPad Safari and desktop browsers. Layout-only — it changes nothing about
/// branding, features or routing.
class ResponsiveMobileShell extends StatelessWidget {
  const ResponsiveMobileShell({
    super.key,
    required this.child,
    this.maxWidth = 480,
  });

  final Widget child;

  /// Maximum mobile width on large screens.
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      // Neutral backdrop visible only on screens wider than [maxWidth].
      color: AppColors.lightGrey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Full width on small phones; clamped + centered on wide screens.
          final width = constraints.maxWidth < maxWidth
              ? constraints.maxWidth
              : maxWidth;
          return Center(
            child: SizedBox(
              width: width,
              height: constraints.maxHeight,
              // Clip so nothing bleeds past the mobile frame.
              child: ClipRect(child: child),
            ),
          );
        },
      ),
    );
  }
}
