import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/auth_model.dart';
import '../../../data/repositories/chemai_repository.dart';

class AuthController extends GetxController {
  final _repo = Get.find<ChemAIRepository>();

  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final nameController     = TextEditingController();

  // 'male' | 'female'  — default female to match your test payload
  final gender              = 'female'.obs;
  final isPasswordVisible   = false.obs;
  final rememberMe          = false.obs;
  final isLoading           = false.obs;
  final isLoginTab          = true.obs;

  void toggleTab()              => isLoginTab.value = !isLoginTab.value;
  void setGender(String g)      => gender.value = g;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleRememberMe()         => rememberMe.value = !rememberMe.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> register() async {
    final name  = nameController.text.trim();
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      _snack('Missing Fields', 'Please fill in all fields.');
      return;
    }

    isLoading.value = true;

    final result = await _repo.register(RegisterRequest(
      fullName: name,
      email:    email,
      password: pass,
      gender:   gender.value,
    ));

    isLoading.value = false;

    if (result.failure != null) {
      _snack('Registration Failed', result.failure!.message);
      return;
    }

    await _saveToken(result.data!.accessToken);
    Get.offAllNamed(AppRoutes.onboarding);
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    if (email.isEmpty || pass.isEmpty) {
      _snack('Missing Fields', 'Please fill in all fields.');
      return;
    }

    isLoading.value = true;

    final result = await _repo.login(LoginRequest(email: email, password: pass));

    isLoading.value = false;

    if (result.failure != null) {
      _snack('Login Failed', result.failure!.message);
      return;
    }

    await _saveToken(result.data!.accessToken);
    Get.offAllNamed(AppRoutes.onboarding);
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    await prefs.setString('access_token', token);
  }

  void _snack(String title, String message) {
    Get.snackbar(title, message, snackPosition: SnackPosition.BOTTOM);
  }
}
