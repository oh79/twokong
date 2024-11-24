import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../core/services/ai_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiService());
    Get.lazyPut(() => HomeController());
  }
}
