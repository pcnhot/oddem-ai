import 'package:flutter/material.dart';

/// Constrains the app to a mobile width and centers it horizontally on wide
/// (web / tablet) viewports, with a light neutral backdrop outside the frame.
///
/// IMPORTANT: the outer centering layout is forced to LTR + [Alignment.center]
/// so the app's Arabic RTL direction never pushes the mobile frame to the left
/// or right edge. RTL is re-applied only *inside* the constrained frame, around
/// the actual app content. Layout-only — no branding/feature/chat changes.
class ResponsiveMobileShell extends StatelessWidget {
  const ResponsiveMobileShell({
    super.key,
    required this.child,
    this.maxWidth = 480,
  });

  final Widget child;

  /// Maximum mobile width on large screens.
  final double maxWidth;

  /// Neutral letterbox color shown outside the mobile frame (web/tablet
  /// chrome only — not an app surface).
  static const Color _backdrop = Color(0xFFF3F4F6);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // Neutral outer direction so centering is never affected by RTL.
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: _backdrop,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Full width on small phones; clamped + centered on wide screens.
            final width = constraints.maxWidth < maxWidth
                ? constraints.maxWidth
                : maxWidth;
            return Center(
              // Alignment.center (direction-agnostic) — exact horizontal center.
              child: SizedBox(
                width: width,
                height: constraints.maxHeight,
                child: ClipRect(
                  // Arabic RTL applies only inside the app content.
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
