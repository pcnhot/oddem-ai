import 'package:flutter/material.dart';

/// Odem brand palette (from the Odem furniture brand book).
///
/// Brand colors:
///  - Sage green (main)  : #737B4D
///  - Rust (accent only) : #A25033
///  - Beige cream        : #EAD7CB
///  - White              : #FFFFFF
///
/// Token names are kept stable so the whole app re-skins from this one file.
/// Mood: calm, natural, furniture-focused, premium but warm.
class AppColors {
  AppColors._();

  /// Main brand color — sage green.
  static const Color primary = Color(0xFF737B4D);

  /// Accent — rust. Use sparingly (highlights only), never as a base surface.
  static const Color accent = Color(0xFFA25033);

  /// Deep earthy green used for dark surfaces, headings and emphasis.
  /// (Name kept as `navy` for source compatibility; value is now deep sage.)
  static const Color navy = Color(0xFF3F4630);

  /// Soft beige cream for warm backgrounds/surfaces where appropriate.
  static const Color beige = Color(0xFFEAD7CB);

  static const Color white = Color(0xFFFFFFFF);

  /// Warm light neutral for borders/dividers.
  static const Color lightGrey = Color(0xFFE3DCD0);

  /// Warm taupe for secondary text/icons.
  static const Color midGrey = Color(0xFF8C8674);

  // Derived / semantic tokens.
  static const Color background = white;
  static const Color surface = white;

  /// Warm, light page background (calm beige tint, not cold grey).
  static const Color scaffold = Color(0xFFF4EEE5);

  static const Color textPrimary = navy;
  static const Color textSecondary = midGrey;
  static const Color border = lightGrey;
  static const Color divider = lightGrey;

  static const Color success = Color(0xFF5E7B3E);
  static const Color error = Color(0xFFB23A48);
  static const Color warning = Color(0xFFC9883A);

  static const Color onPrimary = white;
}
