
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auth_model.dart';
import '../../../services/auth_service.dart';

class AccountController extends GetxController {
  final AuthService _service = Get.find<AuthService>();

  // ── State ──────────────────────────────────────────────────────────────────
  final user      = Rxn<UserAuth>();
  final isLoading = false.obs;

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
    fetchAccount();
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
    isLoading.value = true;
    try {
      final res = await _service.getAccount();
      if (res != null) {
        user.value = res;
        nameController.text = res.fullName;
      }
    } catch (e) {
      _snack('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── PUT /auth/profile ─────────────────────────────────────────────────────

  Future<void> updateProfile() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final res = await _service.updateProfile(UpdateProfileRequest(fullName: name));
      if (res != null) {
        user.value = res;
        _snack('profile_updated'.tr, 'profile_update_success'.tr);
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
      final res = await _service.changePassword(
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