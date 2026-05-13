import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/theme/app_colors.dart';

class ThemeController extends GetxController {
  final isDark = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void toggle() {
    isDark.toggle();
    AppColors.isDark = isDark.value;
    Get.changeThemeMode(isDark.value ? ThemeMode.dark : ThemeMode.light);
    _save(isDark.value);
  }

  String get label => isDark.value ? 'DARK' : 'LIGHT';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool('theme_is_dark') ?? true;
    isDark.value = dark;
    AppColors.isDark = dark;
    Get.changeThemeMode(dark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _save(bool dark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_is_dark', dark);
  }
}
