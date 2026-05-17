import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/language_controller.dart';
import '../core/controllers/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';

class ChemAIApp extends StatelessWidget {
  const ChemAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ThemeController>(
      builder: (tc) => GetX<LanguageController>(
        builder: (lc) => GetMaterialApp(
          title: 'CHEMAI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: tc.isDark.value ? ThemeMode.dark : ThemeMode.light,
          translations: AppTranslations(),
          locale: lc.locale.value,
          fallbackLocale: const Locale('en'),
          supportedLocales: const [Locale('en'), Locale('ar')],
          initialRoute: AppRoutes.splash,
          getPages: AppPages.routes,
          defaultTransition: Transition.fadeIn,
        ),
      ),
    );
  }
}
