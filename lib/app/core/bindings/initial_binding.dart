import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';
import '../../data/repositories/policy_repository.dart';

class InitialBinding extends GetxService {
  Future<void> dependencies() async {
    Get.put(PolicyRepository(), permanent: true);
    await Get.putAsync(() => FirebaseService.init());
    Get.put(AuthService(), permanent: true);
    Get.put(AiService(), permanent: true);
  }
}
