import 'package:get/get.dart';

import '../../ask_ai/controllers/ask_ai_controller.dart';
import '../../pilot_profile/controllers/pilot_profile_controller.dart';
import '../../schedule/controllers/schedule_controller.dart';
import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(MainNavController.new);
    Get.lazyPut<AskAiController>(AskAiController.new);
    Get.lazyPut<ScheduleController>(ScheduleController.new);
    Get.lazyPut<PilotProfileController>(PilotProfileController.new);
  }
}
