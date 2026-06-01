import 'package:get/get.dart';
import '../controllers/mission_map_controller.dart';

class MissionMapBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<MissionMapController>(MissionMapController.new);
}
