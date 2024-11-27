import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../user/controllers/user_controller.dart';
import '../../../core/services/auth_service.dart';

class SurveyController extends GetxController {
  final UserController _userController = Get.find();
  final AuthService _authService = Get.find();

  final currentStep = 0.obs;
  final pageController = PageController();
  final nicknameController = TextEditingController();
  final ageController = TextEditingController();
  final selectedOccupation = ''.obs;
  final selectedFactors = <String>[].obs;

  final occupations = [
    '회사원',
    '공무원',
    '자영업자',
    '프리랜서',
    '전문직',
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
    '경제적 어려움',
    '일과 삶의 균형',
    '자기계발',
    '가족관계',
  ];

  void selectOccupation(String occupation) {
    selectedOccupation.value = occupation;
  }

  void toggleStressFactor(String factor) {
    if (selectedFactors.contains(factor)) {
      selectedFactors.remove(factor);
    } else {
      selectedFactors.add(factor);
    }
  }

  void nextStep() {
    if (currentStep.value < 3) {
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
      if (nicknameController.text.isEmpty) {
        Get.snackbar('오류', '닉네임을 입력해주세요');
        return;
      }

      if (ageController.text.isEmpty) {
        Get.snackbar('오류', '나이를 입력해주세요');
        return;
      }

      final age = int.tryParse(ageController.text);
      if (age == null || age < 15 || age > 100) {
        Get.snackbar('오류', '올바른 나이를 입력해주세요 (15-100)');
        return;
      }

      if (selectedOccupation.isEmpty) {
        Get.snackbar('오류', '직업을 선택해주세요');
        return;
      }

      if (selectedFactors.isEmpty) {
        Get.snackbar('오류', '스트레스 요인을 1개 이상 선택해주세요');
        return;
      }

      final currentUser = _authService.user.value;
      if (currentUser == null) {
        throw Exception('로그인이 필요합니다');
      }

      await _authService.updateUserSurvey(
        currentUser.uid,
        nickname: nicknameController.text,
        age: age,
        occupation: selectedOccupation.value,
        stressFactors: selectedFactors,
      );

      _userController.updateUserInfo(
        nickname: nicknameController.text,
        newAge: age,
        newOccupation: selectedOccupation.value,
        newStressFactors: selectedFactors,
      );

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('오류', '설문 저장에 실패했습니다');
    }
  }

  void onBackPressed() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.back();
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    nicknameController.dispose();
    ageController.dispose();
    super.onClose();
  }
}
