import 'package:get/get.dart';
import '../controllers/cbt_controller.dart';

class CBTBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CBTController>(
      () => CBTController(),
    );
  }
}
