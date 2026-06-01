import 'package:get/get.dart';
import '../controllers/molar_mass_controller.dart';

class MolarMassBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<MolarMassController>(MolarMassController.new);
}
