import 'package:get/get.dart';

import '../controllers/mentor_controller.dart';

class MentorBinding extends Bindings {
  @override
  void dependencies() =>
      Get.lazyPut<MentorController>(MentorController.new);
}
