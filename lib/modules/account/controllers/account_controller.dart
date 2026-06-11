
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/auth_model.dart';
import '../../../data/models/student_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/student_service.dart';

class AccountController extends GetxController {
  final AuthService   _authService    = Get.find<AuthService>();
  final StudentService _studentService = Get.find<StudentService>();

  // ── State ──────────────────────────────────────────────────────────────────
  final user              = Rxn<UserAuth>();
  final studentProfile    = Rxn<StudentProfile>();
  final studentPrefs      = Rxn<StudentPreferences>();
  final isLoading         = false.obs;
  final selectedGender    = 'male'.obs;
  final selectedGrade     = 9.obs;
  final selectedLanguage  = 'ar'.obs;
  final selectedTeachingStyle = 'beginner'.obs;
  final selectedLearningMode  = 'text'.obs;

  // ── Form controllers ───────────────────────────────────────────────────────
  final nameController        = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isOldPassVisible  = false.obs;
  final isNewPassVisible  = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    try {
      await Future.wait([fetchAccount(), fetchStudentProfile(), fetchStudentPrefs()]);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ── GET /auth/account ─────────────────────────────────────────────────────

  Future<void> fetchAccount() async {
    // Fast path: pre-populate from cache so the screen isn't blank
    final prefs = await SharedPreferences.getInstance();
    if (user.value == null) {
      final cachedName  = prefs.getString('user_full_name') ?? '';
      final cachedEmail = prefs.getString('user_email') ?? '';
      if (cachedName.isNotEmpty) {
        user.value = UserAuth(id: '', fullName: cachedName, email: cachedEmail, gender: '');
        nameController.text = cachedName;
      }
    }

    try {
      final res = await _authService.getAccount();
      if (res != null) {
        user.value = res;
        nameController.text = res.fullName;
        selectedGender.value = res.gender.isNotEmpty ? res.gender : 'male';
        if (res.fullName.isNotEmpty) prefs.setString('user_full_name', res.fullName);
        if (res.email.isNotEmpty)    prefs.setString('user_email', res.email);
      }
    } catch (e) {
      if (user.value == null) _snack('error'.tr, e.toString());
    }
  }

  // ── GET /students/me ──────────────────────────────────────────────────────

  Future<void> fetchStudentProfile() async {
    try {
      final res = await _studentService.getProfile();
      if (res != null) {
        studentProfile.value = res;
        selectedGrade.value = res.grade;
        selectedLanguage.value = res.preferredLanguage;
      }
    } catch (_) {}
  }

  // ── GET /students/preferences ─────────────────────────────────────────────

  Future<void> fetchStudentPrefs() async {
    try {
      final res = await _studentService.getPreferences();
      if (res != null) {
        studentPrefs.value = res;
        selectedTeachingStyle.value = res.teachingStyle;
        selectedLearningMode.value = res.learningMode;
      }
    } catch (_) {}
  }

  // ── PATCH /auth/profile ───────────────────────────────────────────────────

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;
    try {
      // Update auth profile (name + gender)
      final authRes = await _authService.updateProfile(
        UpdateProfileRequest(fullName: name, gender: selectedGender.value),
      );
      // Update student profile (grade + language)
      final studentRes = await _studentService.updateProfile(
        UpdateStudentRequest(
          grade: selectedGrade.value,
          preferredLanguage: selectedLanguage.value,
        ),
      );
      if (authRes != null || studentRes != null) {
        await fetchAll();
        _snack('profile_updated'.tr, authRes?.message ?? 'OK');
      } else {
        _snack('error'.tr, 'try_again_later'.tr);
      }
    } on Exception catch (e) {
      _snack('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── PATCH /students/preferences ───────────────────────────────────────────

  Future<void> updatePreferences() async {
    isLoading.value = true;
    try {
      final res = await _studentService.updatePreferences(
        UpdatePreferencesRequest(
          teachingStyle: selectedTeachingStyle.value,
          learningMode: selectedLearningMode.value,
        ),
      );
      if (res != null) {
        studentPrefs.value = res;
        _snack('profile_updated'.tr, 'account_preferences_saved'.tr);
      } else {
        _snack('error'.tr, 'try_again_later'.tr);
      }
    } on Exception catch (e) {
      _snack('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── DELETE /auth/account ──────────────────────────────────────────────────

  Future<void> deleteAccount() async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: Text('account_delete_title'.tr,
            style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
        content: Text('account_delete_confirm'.tr,
            style: TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr, style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('account_delete_confirm_btn'.tr,
                style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    isLoading.value = true;
    try {
      final res = await _authService.deleteAccount();
      if (res != null) {
        _snack('account_deleted'.tr, res.message);
        await Future.delayed(const Duration(milliseconds: 800));
        Get.offAllNamed(AppRoutes.auth);
      } else {
        _snack('error'.tr, 'try_again_later'.tr);
      }
    } on Exception catch (e) {
      _snack('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── POST /auth/change-password ────────────────────────────────────────────

  Future<void> changePassword() async {
    final oldPass    = oldPasswordController.text;
    final newPass    = newPasswordController.text;
    final confirmPass = confirmPasswordController.text;

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    if (newPass != confirmPass) {
      _snack('error'.tr, 'passwords_not_match'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final res = await _authService.changePassword(
        ChangePasswordRequest(oldPassword: oldPass, newPassword: newPass),
      );
      if (res != null) {
        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
        _snack('auth_password_changed'.tr, res.message);
      } else {
        _snack('error'.tr, 'try_again_later'.tr);
      }
    } on Exception catch (e) {
      _snack('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleOldPassVisibility() => isOldPassVisible.value = !isOldPassVisible.value;
  void toggleNewPassVisibility() => isNewPassVisible.value = !isNewPassVisible.value;

  void _snack(String title, String msg) =>
      Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);
}