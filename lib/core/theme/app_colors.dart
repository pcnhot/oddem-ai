import 'package:flutter/material.dart';

/// ODDEM brand palette.
///
/// Brand colors:
///  - Primary dark slate  : #34404C
///  - Deep navy           : #1E3246
///  - White               : #FFFFFF
///  - Light grey          : #DCDCDC
///  - Mid grey            : #969696
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF34404C);
  static const Color navy = Color(0xFF1E3246);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFDCDCDC);
  static const Color midGrey = Color(0xFF969696);

  // Derived / semantic tokens (kept within brand range).
  static const Color background = white;
  static const Color surface = white;
  static const Color scaffold = Color(0xFFF7F8F9);
  static const Color textPrimary = navy;
  static const Color textSecondary = midGrey;
  static const Color border = lightGrey;
  static const Color divider = lightGrey;

  static const Color success = Color(0xFF2E7D5B);
  static const Color error = Color(0xFFB23A48);
  static const Color warning = Color(0xFFC9883A);

  static const Color onPrimary = white;
}
