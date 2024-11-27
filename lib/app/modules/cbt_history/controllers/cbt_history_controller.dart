import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/cbt_model.dart';

class CBTHistoryController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final AuthService _authService = Get.find();

  final cbtSessions = <CBTSession>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCBTSessions();
  }

  Future<void> loadCBTSessions() async {
    try {
      isLoading(true);
      final user = _authService.user.value;
      if (user != null) {
        final sessions = await _firebaseService.getCBTSessions(user.uid);
        cbtSessions.value = sessions;
      }
    } catch (e) {
      Get.snackbar('오류', 'CBT 기록을 불러오는데 실패했습니다');
    } finally {
      isLoading(false);
    }
  }
}
