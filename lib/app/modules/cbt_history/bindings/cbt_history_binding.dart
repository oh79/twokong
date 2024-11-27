import 'package:get/get.dart';
import '../controllers/cbt_history_controller.dart';

class CBTHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CBTHistoryController>(
      () => CBTHistoryController(),
    );
  }
}
