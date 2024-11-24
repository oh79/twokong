import 'package:get/get.dart';
import '../../../data/models/policy_model.dart';
import '../../../core/services/firebase_service.dart';

class PolicyDetailController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final policy = Rx<Policy>(Get.arguments);
  final isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    isFavorite.value = await _firebaseService.isPolicyFavorite(policy.value.id);
  }

  Future<void> toggleFavorite() async {
    try {
      if (isFavorite.value) {
        await _firebaseService.removeFromFavorites(policy.value.id);
      } else {
        await _firebaseService.savePolicyToFavorites(policy.value);
      }
      isFavorite.toggle();
    } catch (e) {
      Get.snackbar('오류', '즐겨찾기 처리 중 문제가 발생했습니다');
    }
  }

  void applyPolicy() {
    // 정책 신청 로직 구현
    Get.toNamed('/apply-policy', arguments: policy.value);
  }
}
