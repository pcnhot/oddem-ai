/// App-wide constants for ODDEM.
class AppConstants {
  AppConstants._();

  static const String appName = 'ODDEM';
  static const String appNameAr = 'أوديم';

  /// Saudi Arabia first. Currency is Saudi Riyal.
  static const String currencyCode = 'SAR';
  static const String currencySymbolAr = 'ر.س';
  static const String defaultCountry = 'SA';

  /// Cities used for installation availability / ETA at checkout.
  static const List<String> saudiCities = <String>[
    'الرياض',
    'جدة',
    'مكة المكرمة',
    'المدينة المنورة',
    'الدمام',
    'الخبر',
    'الطائف',
    'تبوك',
    'بريدة',
    'أبها',
  ];

  /// Supported room types for the AI designer.
  static const List<String> roomTypes = <String>[
    'مجلس',
    'غرفة معيشة',
    'غرفة نوم',
    'غرفة طعام',
    'مكتب منزلي',
    'مدخل',
  ];

  /// Supported design styles for the AI designer.
  static const List<String> designStyles = <String>[
    'حديث',
    'كلاسيكي',
    'نيو كلاسيك',
    'بسيط (مينيمال)',
    'صناعي',
    'بوهيمي',
  ];
}

/// Centralized route path names. Kept as plain strings so they can be reused
/// by the router and by navigation calls.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String catalog = '/catalog';
  static const String productDetail = '/product'; // /product/:id
  static const String aiDesigner = '/ai-designer';
  static const String roomPhotoUpload = '/ai-designer/photo';
  static const String roomDimensions = '/ai-designer/dimensions';
  static const String planner2d = '/planner';
  static const String arPreview = '/ar-preview';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderConfirmation = '/order-confirmation';
  static const String account = '/account';
  static const String help = '/help';
}
