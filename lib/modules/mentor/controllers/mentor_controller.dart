import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../data/models/mentor_model.dart';
import '../../../data/repositories/chemai_repository.dart';

class MentorController extends GetxController {
  final _repo = Get.find<ChemAIRepository>();

  final mentors = <MentorModel>[].obs;
  final selectedId = RxnString();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMentors();
  }

  Future<void> _loadMentors() async {
    // Seed with local data immediately for instant UI, then try API
    mentors.value = MentorModel.defaults;

    final result = await _repo.fetchMentors();
    if (result.data != null && result.data!.isNotEmpty) {
      mentors.value = result.data!;
    }
  }

  void select(String id) => selectedId.value = id;

  bool isSelected(String id) => selectedId.value == id;

  Future<void> initializeSession() async {
    if (selectedId.value == null) {
      Get.snackbar('Select a Mentor',
          'Please choose a teaching style to continue.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    await _repo.selectMentor(selectedId.value!);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mentor_id', selectedId.value!);
    isLoading.value = false;

    Get.offAllNamed(AppRoutes.mainNav);
  }
}
