import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/theme_controller.dart';

class PilotProfileController extends GetxController {
  final name = 'Ahmad Kamal';
  final rank = 'QUANTUM VOYAGER';
  final level = 6;
  final planName = 'Professional Plan (Pro)';
  final planExpiry = 'Auto-renews on October 24';
  final version = 'Version 4.9.2-Quantum';

  final notifications = true.obs;

  ThemeController get _theme => Get.find<ThemeController>();

  void toggleNotifications() => notifications.value = !notifications.value;

  void handleSettingTap(String icon) {
    switch (icon) {
      case 'account':
        Get.toNamed(AppRoutes.profile);
      case 'theme':
        _theme.toggle();
    }
  }

  Future<void> disconnect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    await prefs.remove('onboarding_done');
    await prefs.remove('mentor_id');
    Get.offAllNamed(AppRoutes.splash);
  }
}
