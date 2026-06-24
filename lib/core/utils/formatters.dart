import '../constants/app_constants.dart';

/// Lightweight formatting helpers (no external locale data required).
class Formatters {
  Formatters._();

  /// Formats a price in SAR, e.g. `1٬250 ر.س` style → `1,250 ر.س`.
  static String price(num value) {
    final whole = value.round();
    final str = whole.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(',');
      buffer.write(str[i]);
    }
    return '$buffer ${AppConstants.currencySymbolAr}';
  }

  /// Formats room/product dimensions as `W × D × H سم`.
  static String dimensions({
    required double widthCm,
    required double depthCm,
    required double heightCm,
  }) {
    String n(double v) =>
        v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(1);
    return '${n(widthCm)} × ${n(depthCm)} × ${n(heightCm)} سم';
  }
}
