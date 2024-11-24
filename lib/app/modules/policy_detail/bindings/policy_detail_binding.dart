import 'package:get/get.dart';
import '../controllers/policy_detail_controller.dart';

class PolicyDetailBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PolicyDetailController>(() => PolicyDetailController());
  }
}
