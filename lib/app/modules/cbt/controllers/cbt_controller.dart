import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/firebase_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../data/models/cbt_model.dart';

class CBTController extends GetxController {
  final situationController = TextEditingController();
  final thoughtController = TextEditingController();
  final emotionController = TextEditingController();
  final rationalThoughtController = TextEditingController();
  final actionPlanController = TextEditingController();
  final FirebaseService _firebaseService = Get.find();
  final AuthService _authService = Get.find();

  Future<void> saveCBTSession() async {
    try {
      final user = _authService.user.value;
      if (user == null) {
        Get.snackbar('오류', '로그인이 필요합니다');
        return;
      }

      if (!_validateInputs()) return;

      final session = CBTSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: user.uid,
        situation: situationController.text,
        thought: thoughtController.text,
        emotion: emotionController.text,
        rationalThought: rationalThoughtController.text,
        actionPlan: actionPlanController.text,
        createdAt: DateTime.now(),
      );

      await _firebaseService.saveCBTSession(session);
      Get.back();
      Get.snackbar('성공', 'CBT 세션이 저장되었습니다');
    } catch (e) {
      Get.snackbar('오류', 'CBT 세션 저장에 실패했습니다');
    }
  }

  bool _validateInputs() {
    if (situationController.text.isEmpty ||
        thoughtController.text.isEmpty ||
        emotionController.text.isEmpty ||
        rationalThoughtController.text.isEmpty ||
        actionPlanController.text.isEmpty) {
      Get.snackbar('오류', '모든 항목을 입력해주세요');
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    situationController.dispose();
    thoughtController.dispose();
    emotionController.dispose();
    rationalThoughtController.dispose();
    super.onClose();
  }
}
