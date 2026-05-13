import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;
  final statusText = 'INITIALIZING NEURAL CORE...'.obs;

  static const _steps = [
    (pct: 0.20, msg: 'LOADING QUANTUM MODULES...'),
    (pct: 0.45, msg: 'CALIBRATING AI MATRIX...'),
    (pct: 0.65, msg: 'INITIALIZING NEURAL CORE...'),
    (pct: 0.85, msg: 'SYNCING MOLECULAR DATABASE...'),
    (pct: 1.00, msg: 'SYSTEMS ONLINE'),
  ];

  @override
  void onReady() {
    super.onReady();
    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 600));

    for (final step in _steps) {
      await _animateTo(step.pct, step.msg);
    }

    await Future.delayed(const Duration(milliseconds: 500));
    _navigate();
  }

  Future<void> _animateTo(double target, String msg) async {
    statusText.value = msg;
    const steps = 30;
    final start = progress.value;
    final delta = target - start;
    for (int i = 1; i <= steps; i++) {
      progress.value = start + delta * (i / steps);
      await Future.delayed(const Duration(milliseconds: 35));
    }
    await Future.delayed(const Duration(milliseconds: 250));
  }

  Future<void> _navigate() async {
    final prefs = await SharedPreferences.getInstance();
    final loggedIn  = prefs.getBool('logged_in') ?? false;
    final onboarded = prefs.getBool('onboarding_done') ?? false;
    final mentorSet = prefs.getString('mentor_id') != null;

    if (!loggedIn) {
      Get.offAllNamed(AppRoutes.auth);
    } else if (!onboarded) {
      Get.offAllNamed(AppRoutes.onboarding);
    } else if (!mentorSet) {
      Get.offAllNamed(AppRoutes.mentor);
    } else {
      Get.offAllNamed(AppRoutes.mainNav);
    }
  }
}
