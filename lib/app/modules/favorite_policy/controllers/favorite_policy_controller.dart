import 'package:get/get.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/policy_model.dart';

class FavoritePolicyController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  final AuthService _authService = Get.find();

  final favoritePolicies = <Policy>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavoritePolicies();
  }

  Future<void> loadFavoritePolicies() async {
    try {
      isLoading(true);
      final user = _authService.user.value;
      if (user != null) {
        final policies = await _firebaseService.getFavoritePolicies(user.uid);
        favoritePolicies.value = policies;
      }
    } catch (e) {
      Get.snackbar('오류', '관심 정책을 불러오는데 실패했습니다');
    } finally {
      isLoading(false);
    }
  }
}
