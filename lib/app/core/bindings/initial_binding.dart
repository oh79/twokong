import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../services/ai_service.dart';
import '../services/notification_service.dart';
import '../../data/repositories/policy_repository.dart';
import '../services/auth_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Firebase 초기화
    final firebaseService = FirebaseService();
    Get.put(firebaseService);

    // 기본 서비스들 초기화
    Get.put(AuthService(), permanent: true);
    Get.put(NotificationService(), permanent: true);

    // 나머지 서비스들 lazy 초기화
    Get.lazyPut(() => PolicyRepository());
    Get.lazyPut(() => AiService());

    // Firebase 컬렉션 초기화
    firebaseService.initializePolicyCollection();
  }
}
