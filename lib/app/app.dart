import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../shared/widgets/responsive_mobile_shell.dart';
import 'router.dart';

/// Root widget. Forces Arabic locale + RTL directionality across the app.
class OddemApp extends StatelessWidget {
  const OddemApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,

      // Arabic-first, RTL.
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Constrain the whole app (Scaffolds, bottom nav, all tabs) to a
      // centered mobile-width frame on wide web/tablet viewports. The shell
      // owns directionality: neutral LTR outside for centering, RTL inside.
      builder: (context, child) => ResponsiveMobileShell(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
