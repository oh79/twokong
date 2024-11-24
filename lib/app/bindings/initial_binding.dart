import 'package:get/get.dart';
import '../modules/home/controllers/home_controller.dart';
import '../core/services/ai_service.dart';
import '../core/services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthService());
    Get.put(AiService());
    Get.put(HomeController());
  }
}
