import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/theme_controller.dart';

class PilotProfileController extends GetxController {
  final name = 'Commander Alex Vance';
  final rank = 'QUANTUM VOYAGER';
  final level = 42;
  final planName = 'ChemAI Pro';
  final planExpiry = 'Elite access until Oct 2025';
  final version = 'Version 4.9.2-Quantum';

  ThemeController get _theme => Get.find<ThemeController>();

  List<({String icon, String label, String trailing})> get settings => [
    (icon: 'account', label: 'Account Details', trailing: ''),
    (icon: 'privacy', label: 'Privacy & Security', trailing: ''),
    (icon: 'alerts', label: 'Transmission Alerts', trailing: 'Active'),
    (icon: 'theme', label: 'Interface Theme', trailing: _theme.label),
    (icon: 'support', label: 'Navigation Support', trailing: ''),
  ];

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
