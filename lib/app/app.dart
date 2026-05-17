import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/controllers/language_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'theme/app_theme.dart';
import 'translations/app_translations.dart';

class ChemAIApp extends StatelessWidget {
  const ChemAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lc = Get.find<LanguageController>();
    return GetMaterialApp(
      title: 'CHEMAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      // Theme updates are applied via Get.changeThemeMode() in ThemeController.
      // Locale updates are applied via Get.updateLocale() in LanguageController.
      // GetMaterialApp's internal GetBuilder handles both without a wrapper.
      translations: AppTranslations(),
      locale: lc.locale.value,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      defaultTransition: Transition.fadeIn,
    );
  }
}
