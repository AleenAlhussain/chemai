import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/controllers/explanation_style_controller.dart';
import '../../../core/controllers/theme_controller.dart';
import '../../../data/models/auth_model.dart';
import '../../../data/models/student_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/student_service.dart';
import '../../../widgets/explanation_style_picker_sheet.dart';
import '../../mentor/controllers/mentor_controller.dart';

class PilotProfileController extends GetxController {
  final AuthService    _authService    = Get.find<AuthService>();
  final StudentService _studentService = Get.find<StudentService>();

  // ── Observable user data ───────────────────────────────────────────────────
  final name     = ''.obs;
  final email    = ''.obs;
  final grade    = 0.obs;
  final language = ''.obs;

  // Static display fields
  final rank      = 'QUANTUM VOYAGER';
  final level     = 6;
  final planName  = 'Professional Plan (Pro)';
  final planExpiry = 'Auto-renews on October 24';
  final version   = 'Version 4.9.2-Quantum';

  final notifications = true.obs;
  final mentorSubtitle = ''.obs;

  ExplanationStyleController get _explanationStyle =>
      Get.find<ExplanationStyleController>();

  ThemeController get _theme => Get.find<ThemeController>();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    loadMentorDisplay();
  }

  Future<void> _loadUserData() async {
    try {
      final results = await Future.wait([
        _authService.getAccount(),
        _studentService.getProfile(),
      ]);
      final user    = results[0] as UserAuth?;
      final student = results[1];
      if (user != null) {
        name.value  = user.fullName;
        email.value = user.email;
      }
      if (student != null) {
        final sp = student as StudentProfile;
        grade.value    = sp.grade;
        language.value = sp.preferredLanguage;
      }
    } catch (_) {}
  }

  void toggleNotifications() => notifications.value = !notifications.value;

  Future<void> loadMentorDisplay() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('mentor_id');
    if (id == null) {
      mentorSubtitle.value = 'pilot_mentor_not_set'.tr;
      return;
    }
    mentorSubtitle.value = mentorNameForId(id);
  }

  Future<void> openMentorPicker() async {
    await Get.toNamed(AppRoutes.mentor, arguments: {'editMode': true});
    await loadMentorDisplay();
  }

  Future<void> openExplanationStylePicker() async {
    await ExplanationStylePickerSheet.show(
      selectedId: _explanationStyle.selectedId.value,
    );
  }

  void handleSettingTap(String icon) {
    switch (icon) {
      case 'account':
        Get.toNamed(AppRoutes.profile);
      case 'theme':
        _theme.toggleDark();
      case 'mentor':
        openMentorPicker();
    }
  }

  Future<void> disconnect() async {
    // Call server logout first (best-effort — ignore failures)
    try {
      await _authService.logout();
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    await prefs.remove('access_token');
    await prefs.remove('onboarding_done');
    await prefs.remove('mentor_id');
    await prefs.remove('explanation_style');
    Get.offAllNamed(AppRoutes.auth);
  }
}
