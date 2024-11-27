import 'package:get/get.dart';
import '../controllers/favorite_policy_controller.dart';

class FavoritePolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritePolicyController>(
      () => FavoritePolicyController(),
    );
  }
}
