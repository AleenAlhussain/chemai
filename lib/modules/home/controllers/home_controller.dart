import 'package:get/get.dart';

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

    // Load real name from auth API (overrides mock name)
    await _loadRealName();

    // Then try live stats
    final result = await _repo.fetchProfile();
    if (result.data != null) user.value = result.data;
  }

  Future<void> _loadRealName() async {
    try {
      final account = await _authService.getAccount();
      if (account != null && account.fullName.isNotEmpty) {
        final current = user.value ?? UserModel.mock;
        user.value = current.copyWith(name: account.fullName);
      }
    } catch (_) {}
  }

  void refresh() => _loadProfile();
}
