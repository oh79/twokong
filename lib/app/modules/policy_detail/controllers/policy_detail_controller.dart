import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/policy_model.dart';

class PolicyDetailController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final policy = Rx<Policy?>(null);
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get에서 전달받은 정책 데이터 설정
    if (Get.arguments is Policy) {
      policy.value = Get.arguments as Policy;
      _checkFavoriteStatus();
    }
  }

  Future<void> _checkFavoriteStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && policy.value != null) {
      isFavorite.value = await _firebaseService.isPolicyFavorite(
        user.uid,
        policy.value!.id,
      );
    }
  }

  Future<void> toggleFavorite() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || policy.value == null) return;

    try {
      if (isFavorite.value) {
        await _firebaseService.removeFromFavorites(
          user.uid,
          policy.value!.id,
        );
      } else {
        await _firebaseService.savePolicyToFavorites(
          user.uid,
          policy.value!.id,
        );
      }
      isFavorite.toggle();
    } catch (e) {
      Get.snackbar('오류', '즐겨찾기 처리 중 오류가 발생했습니다.');
    }
  }

  void applyPolicy() {
    // 정책 신청 로직 구현
    Get.toNamed('/apply-policy', arguments: policy.value);
  }
}
