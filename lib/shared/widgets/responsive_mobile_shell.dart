import 'package:flutter/material.dart';

/// Constrains the app to a mobile width and centers it horizontally on wide
/// (web / tablet) viewports, with a light neutral backdrop outside the frame.
///
/// Sizes the outer shell to the REAL viewport via [MediaQuery.sizeOf] instead
/// of relying on incoming box constraints (which can already be narrow and
/// leave the frame stuck to one edge on iPad Safari). A max [maxWidth] mobile
/// frame is centered inside the full viewport.
///
/// The outer layout is forced to LTR so the app's Arabic RTL direction never
/// pushes the frame off-center; RTL is re-applied only inside the frame around
/// the app content. Layout-only — no branding/feature/chat changes.
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
    // Real viewport size — full width/height of the browser window.
    final size = MediaQuery.sizeOf(context);
    final frameWidth = size.width < maxWidth ? size.width : maxWidth;

    return Directionality(
      // Neutral outer direction so centering is never affected by RTL.
      textDirection: TextDirection.ltr,
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: ColoredBox(
          color: _backdrop,
          child: Align(
            // Horizontally centered, top-aligned mobile frame.
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: frameWidth,
              height: size.height,
              child: ClipRect(
                // Arabic RTL applies only inside the app content.
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
