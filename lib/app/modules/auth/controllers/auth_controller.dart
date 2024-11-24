import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.put(AuthService());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;
  final isSignUp = false.obs;

  void toggleSignUp() {
    isSignUp.toggle();
    emailController.clear();
    passwordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> handleSubmit() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('오류', '이메일과 비밀번호를 입력해주세요');
      return;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('오류', '올바른 이메일 형식이 아닙니다');
      return;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('오류', '비밀번호는 최소 6자 이상이어야 합니다');
      return;
    }

    try {
      isLoading(true);
      if (isSignUp.value) {
        await _authService.signUp(
            emailController.text.trim(), passwordController.text);
      } else {
        await _authService.signIn(
            emailController.text.trim(), passwordController.text);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = '처리 중 문제가 발생했습니다';
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = '이미 사용 중인 이메일입니다';
          break;
        case 'invalid-email':
          errorMessage = '유효하지 않은 이메일 형식입니다';
          break;
        case 'operation-not-allowed':
          errorMessage = '이메일/비밀번호 로그인이 비활성화되어 있습니다';
          break;
        case 'weak-password':
          errorMessage = '비밀번호가 너무 약합니다 (최소 6자 이상)';
          break;
        case 'user-not-found':
          errorMessage = '등록되지 않은 이메일입니다';
          break;
        case 'wrong-password':
          errorMessage = '잘못된 비밀번호입니다';
          break;
      }
      Get.snackbar(
        '오류',
        errorMessage,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } catch (e) {
      debugPrint('=== 로그인/회원가입 에러 ===\n$e');
      Get.snackbar(
        '오류',
        '처리 중 문제가 발생했습니다',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> signInAnonymously() async {
    try {
      isLoading(true);
      final userCredential = await FirebaseAuth.instance.signInAnonymously();

      if (userCredential.user != null) {
        Get.snackbar(
          '성공',
          '익명으로 로그인되었습니다',
          backgroundColor: Colors.green[100],
          colorText: Colors.green[900],
        );
        await Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      debugPrint('익명 로그인 에러: $e');
      Get.snackbar(
        '오류',
        '익명 로그인에 실패했습니다',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading(false);
    }
  }
}
