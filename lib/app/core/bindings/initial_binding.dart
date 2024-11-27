import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';
import '../../data/repositories/policy_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FirebaseService(), permanent: true);
    Get.put(AuthService(), permanent: true);
    Get.put(PolicyRepository(), permanent: true);
    Get.put(AiService(), permanent: true);
  }
}
