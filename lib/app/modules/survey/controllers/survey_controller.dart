import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import '../../user/controllers/user_controller.dart';
import '../../../core/services/auth_service.dart';

class SurveyController extends GetxController {
  final UserController _userController = Get.find();
  final AuthService _authService = Get.find();

  final currentStep = 0.obs;
  final pageController = PageController();
  final ageController = TextEditingController();
  final selectedOccupation = ''.obs;
  final selectedFactors = <String>[].obs;

  final occupations = [
    '회사원',
    '자영업자',
    '프리랜서',
    '학생',
    '구직자',
    '기타',
  ];

  final stressFactors = [
    '업무과중',
    '대인관계',
    '미래불안',
    '건강문제',
    '직장내 갈등',
    '업무 성과',
  ];

  void selectOccupation(String occupation) {
    selectedOccupation.value = occupation;
    nextStep();
  }

  void toggleStressFactor(String factor) {
    if (selectedFactors.contains(factor)) {
      selectedFactors.remove(factor);
    } else {
      selectedFactors.add(factor);
    }
  }

  void nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      handleComplete();
    }
  }

  Future<void> handleComplete() async {
    try {
      final age = int.tryParse(ageController.text) ?? 25;
      final currentUser = _authService.user.value;

      if (currentUser == null) {
        throw Exception('로그인이 필요합니다');
      }

      // UserController 업데이트
      _userController.updateUserInfo(
        newAge: age,
        newOccupation: selectedOccupation.value,
        newStressFactors: selectedFactors,
      );

      // Firestore 업데이트
      await _authService.updateUserStressFactors(
        currentUser.uid,
        selectedFactors,
      );

      // 홈 화면으로 이동
      Get.offAllNamed(
        AppRoutes.home,
        arguments: {
          'age': age,
          'occupation': selectedOccupation.value,
          'stressFactors': selectedFactors,
          'fromSurvey': true,
        },
      );
    } catch (e) {
      Get.snackbar('오류', '설문 저장에 실패했습니다');
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    ageController.dispose();
    super.onClose();
  }
}
