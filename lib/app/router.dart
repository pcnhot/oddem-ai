import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_constants.dart';
import '../features/account/presentation/account_screen.dart';
import '../features/ai_designer/presentation/ai_chat_screen.dart';
import '../features/ai_designer/presentation/ai_designer_screen.dart';
import '../features/ai_designer/presentation/room_dimensions_screen.dart';
import '../features/ai_designer/presentation/room_photo_upload_screen.dart';
import '../features/ar/presentation/ar_preview_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/catalog/presentation/catalog_screen.dart';
import '../features/catalog/presentation/product_detail_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/checkout/presentation/order_confirmation_screen.dart';
import '../features/favorites/presentation/favorites_screen.dart';
import '../features/help/presentation/help_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/planner/presentation/planner_2d_screen.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../shared/models/product.dart';
import 'main_shell.dart';

final _rootKey = GlobalKey<NavigatorState>();
final _shellKey = GlobalKey<NavigatorState>();

/// Application router. The five primary destinations live inside a
/// [StatefulShellRoute] (bottom nav); everything else is pushed full-screen.
final appRouter = GoRouter(
  navigatorKey: _rootKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (_, __) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (_, __) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (_, __) => const RegisterScreen(),
    ),

    // ---- Main bottom-navigation shell ----
    StatefulShellRoute.indexedStack(
      builder: (_, __, shell) => MainShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (_, __) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.catalog,
            builder: (_, __) => const CatalogScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.aiDesigner,
            builder: (_, __) => const AiDesignerScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.cart,
            builder: (_, __) => const CartScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: AppRoutes.account,
            builder: (_, __) => const AccountScreen(),
          ),
        ]),
      ],
    ),

    // ---- Full-screen pushed routes ----
    GoRoute(
      path: '${AppRoutes.productDetail}/:id',
      parentNavigatorKey: _rootKey,
      builder: (_, state) =>
          ProductDetailScreen(productId: state.pathParameters['id']!),
    ),
    GoRoute(
      path: AppRoutes.aiChat,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const AiChatScreen(),
    ),
    GoRoute(
      path: AppRoutes.roomPhotoUpload,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const RoomPhotoUploadScreen(),
    ),
    GoRoute(
      path: AppRoutes.roomDimensions,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const RoomDimensionsScreen(),
    ),
    GoRoute(
      path: AppRoutes.planner2d,
      parentNavigatorKey: _rootKey,
      builder: (_, state) => Planner2DScreen(product: state.extra as Product?),
    ),
    GoRoute(
      path: AppRoutes.arPreview,
      parentNavigatorKey: _rootKey,
      builder: (_, state) => ArPreviewScreen(product: state.extra as Product?),
    ),
    GoRoute(
      path: AppRoutes.favorites,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const FavoritesScreen(),
    ),
    GoRoute(
      path: AppRoutes.checkout,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const CheckoutScreen(),
    ),
    GoRoute(
      path: AppRoutes.orderConfirmation,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const OrderConfirmationScreen(),
    ),
    GoRoute(
      path: AppRoutes.help,
      parentNavigatorKey: _rootKey,
      builder: (_, __) => const HelpScreen(),
    ),
  ],
);
