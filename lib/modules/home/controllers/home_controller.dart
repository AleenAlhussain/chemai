import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/models/user_model.dart';
import '../../../data/repositories/chemai_repository.dart';
import '../../../services/auth_service.dart';

class HomeController extends GetxController {
  final _repo        = Get.find<ChemAIRepository>();
  final _authService = Get.find<AuthService>();

  final user      = Rxn<UserModel>();
  final isLoading = true.obs;

  @override
  void onReady() {
    super.onReady();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    // Show mock data immediately for fluid UX
    user.value = UserModel.mock;
    isLoading.value = false;

    // Load real name — from cache first (instant), then live API
    await _loadRealName();

    // Then try live stats
    final result = await _repo.fetchProfile();
    if (result.data != null) user.value = result.data;
  }

  Future<void> _loadRealName() async {
    final prefs = await SharedPreferences.getInstance();

    // Fast path: cached name from login
    final cached = prefs.getString('user_full_name') ?? '';
    if (cached.isNotEmpty) {
      user.value = (user.value ?? UserModel.mock).copyWith(name: cached);
    }

    // Refresh from API and update cache
    try {
      final account = await _authService.getAccount();
      if (account != null && account.fullName.isNotEmpty) {
        user.value = (user.value ?? UserModel.mock).copyWith(name: account.fullName);
        prefs.setString('user_full_name', account.fullName);
        if (account.email.isNotEmpty) prefs.setString('user_email', account.email);
      }
    } catch (_) {}
  }

  void refresh() => _loadProfile();
}
