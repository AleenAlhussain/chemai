import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;
  final isLoginTab = true.obs;

  void toggleTab() => isLoginTab.value = !isLoginTab.value;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Missing Fields', 'Please fill in all fields.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.onboarding);
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleRememberMe() => rememberMe.value = !rememberMe.value;
}
