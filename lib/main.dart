import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'core/controllers/explanation_style_controller.dart';
import 'core/controllers/language_controller.dart';
import 'core/controllers/theme_controller.dart';
import 'core/network/dio_client.dart';
import 'data/providers/chemai_provider.dart';
import 'data/repositories/chemai_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  bootstrap();
  runApp(const ChemAIApp());
}

void bootstrap() {
  Get.put(ThemeController(), permanent: true);
  Get.put(LanguageController(), permanent: true);
  Get.put(ExplanationStyleController(), permanent: true);
  final dio = DioClient();
  Get.put(dio, permanent: true);
  Get.put(ChemAIProvider(dio), permanent: true);
  Get.put(ChemAIRepository(Get.find<ChemAIProvider>()), permanent: true);
}