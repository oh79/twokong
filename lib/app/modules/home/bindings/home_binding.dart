import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../data/repositories/policy_repository.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<PolicyRepository>()) {
      Get.put(PolicyRepository());
    }

    Get.lazyPut<HomeController>(() => HomeController());
  }
}
