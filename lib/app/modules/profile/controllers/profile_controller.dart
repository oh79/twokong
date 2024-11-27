import 'package:get/get.dart';
import 'package:twokong/app/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firebase_service.dart';
import '../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find();
  final FirebaseService _firebaseService = Get.find();

  final userInfo = Rx<UserModel?>(null);
  final favoritePolicies = [].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    loadFavoritePolicies();
  }

  Future<void> loadUserInfo() async {
    try {
      isLoading(true);
      final user = _authService.user.value;
      if (user != null) {
        final userData = await _firebaseService.getUserInfo(user.uid);
        userInfo.value = userData;
      }
    } catch (e) {
      Get.snackbar('오류', '사용자 정보를 불러오는데 실패했습니다');
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadFavoritePolicies() async {
    try {
      final user = _authService.user.value;
      if (user != null) {
        final policies = await _firebaseService.getFavoritePolicies(user.uid);
        favoritePolicies.value = policies;
      }
    } catch (e) {
      Get.snackbar('오류', '즐겨찾기를 불러오는데 실패했습니다');
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.auth);
    } catch (e) {
      Get.snackbar('오류', '로그아웃 중 오류가 발생했습니다');
    }
  }
}
