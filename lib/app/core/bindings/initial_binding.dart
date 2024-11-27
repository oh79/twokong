import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';
import '../../data/repositories/policy_repository.dart';
import '../../modules/home/controllers/home_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // 1. 레포지토리 레이어
    Get.put(PolicyRepository(), permanent: true);

    // 2. 서비스 레이어
    Get.put(FirebaseService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(AiService(), permanent: true);

    // 3. 컨트롤러 레이어
    Get.put(HomeController(), permanent: true);
  }
}
