import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/auth_model.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  // Service resolved from GetX — registered as permanent singleton in bootstrap()
  final AuthService _service = Get.find<AuthService>();

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final nameController     = TextEditingController();

  final gender            = 'female'.obs; // 'male' | 'female'
  final isPasswordVisible = false.obs;
  final rememberMe        = false.obs;
  final isLoading         = false.obs;
  final isLoginTab        = true.obs;

  void toggleTab()               => isLoginTab.value = !isLoginTab.value;
  void setGender(String g)       => gender.value = g;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleRememberMe()         => rememberMe.value = !rememberMe.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  // ── Register ────────────────────────────────────────────────────────────

  Future<void> register() async {
    final name  = nameController.text.trim();
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;

    final res = await _service.register(
      RegisterRequest(
        fullName: name,
        email:    email,
        password: pass,
        gender:   gender.value,
      ),
    );

    isLoading.value = false;

    if (res == null) {
      _snack('register_failed'.tr, 'try_again_later'.tr);
      return;
    }

    await _saveToken(res.accessToken);
    Get.offAllNamed(AppRoutes.onboarding);
  }

  // ── Login ────────────────────────────────────────────────────────────────

  Future<void> login() async {
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;

    final res = await _service.login(
      LoginRequest(email: email, password: pass),
    );

    isLoading.value = false;

    if (res == null) {
      _snack('login_failed'.tr, 'try_again_later'.tr);
      return;
    }

    await _saveToken(res.accessToken);
    Get.offAllNamed(AppRoutes.onboarding);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    await prefs.setString('access_token', token);
  }

  void _snack(String title, String message) =>
      Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
}
