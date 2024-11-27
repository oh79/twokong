import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../exceptions/custom_auth_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;
  final isSignUp = false.obs;

  void toggleSignUp() {
    isSignUp.toggle();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> handleSubmit() async {
    if (!_validateInputs()) return;

    try {
      isLoading(true);

      if (isSignUp.value) {
        await _handleSignUp();
      } else {
        await _handleSignIn();
      }
    } on CustomAuthException catch (e) {
      Get.snackbar(
        '오류',
        e.toString(),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } catch (e) {
      debugPrint('=== 로그인/회원가입 에러 ===\n$e');
      Get.snackbar(
        '오류',
        isSignUp.value ? '회원가입 중 오류가 발생했습니다' : '로그인 중 오류가 발생했습니다',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading(false);
    }
  }

  bool _validateInputs() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('오류', '이메일과 비밀번호를 입력해주세요');
      return false;
    }

    if (!GetUtils.isEmail(emailController.text)) {
      Get.snackbar('오류', '올바른 이메일 형식이 아닙니다');
      return false;
    }

    if (passwordController.text.length < 6) {
      Get.snackbar('오류', '비밀번호는 최소 6자 이상이어야 합니다');
      return false;
    }

    if (isSignUp.value &&
        passwordController.text != confirmPasswordController.text) {
      Get.snackbar('오류', '비밀번호가 일치하지 않습니다');
      return false;
    }

    return true;
  }

  Future<void> _handleSignUp() async {
    try {
      final user = await _authService.signUp(
        emailController.text.trim(),
        passwordController.text,
      );

      if (user != null) {
        // 설문 화면으로 이동하면서 uid 전달
        Get.offNamed(AppRoutes.survey, arguments: user.uid);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('Firebase 인증 오류: ${e.code}');
      throw CustomAuthException(_getErrorMessage(e.code));
    } catch (e) {
      debugPrint('회원가입 실패: $e');
      rethrow;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return '이미 사용 중인 이메일입니다';
      case 'invalid-email':
        return '올바르지 않은 이메일 형식입니다';
      case 'operation-not-allowed':
        return '이메일/비밀번호 로그인이 비활성화되어 있습니다';
      case 'weak-password':
        return '비밀번호가 너무 약합니다';
      default:
        return '회원가입 중 오류가 발생했습니다';
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _authService.signIn(
        emailController.text.trim(),
        passwordController.text,
      );
    } catch (e) {
      debugPrint('로그인 실패: $e');
      rethrow;
    }
  }
}
