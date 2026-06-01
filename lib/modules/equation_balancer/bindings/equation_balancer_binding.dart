import 'package:get/get.dart';
import '../controllers/equation_balancer_controller.dart';

class EquationBalancerBinding extends Bindings {
  @override
  void dependencies() => Get.lazyPut<EquationBalancerController>(EquationBalancerController.new);
}
