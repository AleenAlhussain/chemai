import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/auth_model.dart';
import '../../../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _service = Get.find<AuthService>();

  // ── Form controllers ───────────────────────────────────────────────────────
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final nameController     = TextEditingController();

  // Forgot / reset password
  final resetTokenController   = TextEditingController();
  final newPasswordController  = TextEditingController();

  // ── State ──────────────────────────────────────────────────────────────────
  final gender            = 'female'.obs;
  final isPasswordVisible = false.obs;
  final rememberMe        = false.obs;
  final isLoading         = false.obs;
  final isLoginTab        = true.obs;

  void toggleTab()               => isLoginTab.value = !isLoginTab.value;
  void setGender(String g)       => gender.value = g;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void toggleRememberMe()         => rememberMe.value = !rememberMe.value;

  @override
  void onClose() => super.onClose();

  // ── Register ────────────────────────────────────────────────────────────────

  Future<void> register() async {
    final name  = nameController.text.trim();
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    debugPrint('📝 REGISTER attempt — name: $name, email: $email, gender: ${gender.value}');

    if (name.isEmpty || email.isEmpty || pass.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final res = await _service.register(RegisterRequest(
        fullName: name,
        email:    email,
        password: pass,
        gender:   gender.value,
      ));

      debugPrint('📝 REGISTER response: ${res?.message}');

      if (res == null) {
        _snack('register_failed'.tr, 'try_again_later'.tr);
        return;
      }

      // Cache name + email immediately from the form — we know them right now.
      // The register API doesn't return a token so we can't call getAccount yet,
      // but we already have the user's name from what they typed.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_full_name', name);
      await prefs.setString('user_email', email);
      debugPrint('✅ REGISTER — cached name: $name, email: $email');

      _snack('register_success'.tr, res.message);
      nameController.clear();
      await login(); // email + password still in the fields → goes to app
    } on Exception catch (e) {
      debugPrint('❌ REGISTER error: $e');
      _snack('register_failed'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Login ────────────────────────────────────────────────────────────────

  Future<void> login() async {
    final email = emailController.text.trim();
    final pass  = passwordController.text;

    debugPrint('🔑 LOGIN attempt — email: $email');

    if (email.isEmpty || pass.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final res = await _service.login(LoginRequest(email: email, password: pass));

      debugPrint('🔑 LOGIN response — accessToken: ${res?.accessToken.isEmpty == false ? res!.accessToken.substring(0, 20) + '...' : 'null'}');
      debugPrint('🔑 LOGIN user in response: ${res?.user?.fullName ?? 'none'}');

      if (res == null) {
        _snack('login_failed'.tr, 'try_again_later'.tr);
        return;
      }
      await _saveToken(res.accessToken);
      await _cacheUserData(res);

      final prefs = await SharedPreferences.getInstance();
      debugPrint('✅ LOGIN — cached name: ${prefs.getString('user_full_name')}, email: ${prefs.getString('user_email')}');

      // Route based on onboarding status
      if (prefs.getBool('onboarding_done') == true) {
        if (prefs.getString('mentor_id') == null) {
          debugPrint('🚀 LOGIN → mentor picker');
          Get.offAllNamed(AppRoutes.mentor);
        } else {
          debugPrint('🚀 LOGIN → main nav');
          Get.offAllNamed(AppRoutes.mainNav);
        }
      } else {
        debugPrint('🚀 LOGIN → onboarding');
        Get.offAllNamed(AppRoutes.onboarding);
      }
    } on Exception catch (e) {
      debugPrint('❌ LOGIN error: $e');
      _snack('login_failed'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────

  Future<void> logout() async {
    isLoading.value = true;
    await _service.logout();
    await _clearSession();
    isLoading.value = false;
    Get.offAllNamed(AppRoutes.auth);
  }

  // ── Forgot password ───────────────────────────────────────────────────────

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final res = await _service.forgotPassword(ForgotPasswordRequest(email: email));
      if (res != null) {
        _snack('auth_email_sent'.tr, res.message);
        Get.back();
      } else {
        _snack('error'.tr, 'try_again_later'.tr);
      }
    } on Exception catch (e) {
      _snack('error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ── Reset password ─────────────────────────────────────────────────────────

  Future<void> resetPassword() async {
    final token   = resetTokenController.text.trim();
    final newPass = newPasswordController.text;

    if (token.isEmpty || newPass.isEmpty) {
      _snack('missing_fields'.tr, 'fill_all_fields'.tr);
      return;
    }

    isLoading.value = true;

    try {
      final res = await _service.resetPassword(
        ResetPasswordRequest(token: token, newPassword: newPass),
      );
      if (res != null) {
        _snack('auth_password_reset'.tr, res.message);
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', true);
    await prefs.setString('access_token', token);
    debugPrint('💾 Token saved (first 20 chars): ${token.length > 20 ? token.substring(0, 20) : token}...');
  }

  /// Caches the user's name + email so screens load instantly without an API call.
  /// Priority: login response user object → GET /auth/account → existing cache (unchanged).
  Future<void> _cacheUserData(AuthResponse res) async {
    final prefs = await SharedPreferences.getInstance();

    if (res.user != null && res.user!.fullName.isNotEmpty) {
      await prefs.setString('user_full_name', res.user!.fullName);
      await prefs.setString('user_email', res.user!.email);
      debugPrint('👤 User data from login response: ${res.user!.fullName}');
      return;
    }

    debugPrint('👤 Login response has no user — trying GET /auth/account');
    try {
      final account = await _service.getAccount();
      debugPrint('👤 GET /auth/account → fullName: ${account?.fullName}, email: ${account?.email}');
      if (account != null && account.fullName.isNotEmpty) {
        await prefs.setString('user_full_name', account.fullName);
        await prefs.setString('user_email', account.email);
      } else {
        debugPrint('⚠️ getAccount returned null or empty name — keeping cached value');
      }
    } catch (e) {
      debugPrint('⚠️ getAccount failed: $e — keeping cached value');
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in');
    await prefs.remove('access_token');
    await prefs.remove('user_full_name');
    await prefs.remove('user_email');
  }

  void _snack(String title, String msg) =>
      Get.snackbar(title, msg, snackPosition: SnackPosition.BOTTOM);
}
