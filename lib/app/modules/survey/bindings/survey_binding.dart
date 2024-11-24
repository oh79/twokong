import 'package:get/get.dart';
import '../controllers/survey_controller.dart';
import '../../user/controllers/user_controller.dart';

class SurveyBinding extends Bindings {
  @override
  void dependencies() {
    // UserController 먼저 초기화
    Get.lazyPut<UserController>(() => UserController());

    // SurveyController 초기화
    Get.lazyPut<SurveyController>(() => SurveyController());
  }
}
