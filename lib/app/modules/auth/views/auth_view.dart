import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twokong/app/core/theme/theme.dart';
import 'package:twokong/app/modules/auth/controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 60),
              Image.asset(
                'lib/app/assets/images/logo2.png',
                height: 120,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                '마음피움',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8), // 간격 추가
              const Text(
                '직장인 정신건강 솔루션',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center, // 가운데 정렬 추가
              ),
              const SizedBox(height: 40),
              _buildInputField(
                controller: controller.emailController,
                hint: '이메일 주소를 입력해주세요',
                label: '이메일',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: controller.passwordController,
                hint: '비밀번호를 입력해주세요',
                label: '비밀번호',
                obscureText: true,
              ),
              const SizedBox(height: 16),
              Obx(() => controller.isSignUp.value
                  ? _buildInputField(
                      controller: controller.confirmPasswordController,
                      hint: '비밀번호를 다시 입력해주세요',
                      label: '비밀번호 확인',
                      obscureText: true,
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 24),
              Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () => controller.handleSubmit(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            controller.isSignUp.value ? '회원가입' : '로그인',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  )),
              const SizedBox(height: 16),
              Obx(() => TextButton(
                    onPressed: () => controller.toggleSignUp(),
                    child: Text(
                      controller.isSignUp.value ? '로그인하기' : '회원가입하기',
                      style: const TextStyle(
                        color: AppTheme.secondaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: const TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.primaryColor),
        ),
        filled: false, // filled 속성 제거
        fillColor: Colors.transparent, // fillColor 투명하게 설정
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      cursorColor: AppTheme.primaryColor,
    );
  }
}
