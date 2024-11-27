import 'package:get/get.dart';

class UserController extends GetxController {
  final age = 0.obs;
  final occupation = ''.obs;
  final stressFactors = <String>[].obs;

  void updateUserInfo({
    int? newAge,
    String? newOccupation,
    List<String>? newStressFactors,
    required String nickname,
  }) {
    if (newAge != null) age.value = newAge;
    if (newOccupation != null) occupation.value = newOccupation;
    if (newStressFactors != null) stressFactors.value = newStressFactors;
  }
}
