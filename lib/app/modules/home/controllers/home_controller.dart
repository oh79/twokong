import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/policy_model.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/auth_service.dart';

class HomeController extends GetxController {
  final AiService _aiService = Get.find();
  final AuthService _authService = Get.find();
  final RxList<Policy> recommendedPolicies = <Policy>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    Future.microtask(() => loadPolicies());
  }

  @override
  void onReady() {
    super.onReady();
    loadPolicies();
  }

  Future<void> loadPolicies() async {
    try {
      isLoading(true);
      hasError(false);
      recommendedPolicies.clear();

      Map<String, dynamic> requestData = {
        'age': 25,
        'occupation': '회사원',
        'stressFactors': <String>[],
      };

      try {
        final currentUser = _authService.user.value;
        if (currentUser != null) {
          final userData = await _authService.getUserData(currentUser.uid);
          if (userData != null) {
            if (userData.age != null) {
              requestData['age'] = userData.age;
            }
            if (userData.occupation != null) {
              requestData['occupation'] = userData.occupation;
            }
            requestData['stressFactors'] = userData.stressFactors;
          }
        }
      } catch (userError) {
        debugPrint('사용자 데이터 로드 실패: $userError');
      }

      try {
        final policies = await _aiService.getRecommendedPolicies(
          age: requestData['age'] as int,
          occupation: requestData['occupation'] as String,
          stressFactors: requestData['stressFactors'] as List<String>,
        );

        if (policies.isNotEmpty) {
          recommendedPolicies.assignAll(policies);
        }
      } catch (policyError) {
        debugPrint('정책 데이터 로드 실패: $policyError');
        rethrow;
      }
    } catch (e) {
      hasError(true);
      Get.snackbar('오류', '데이터를 불러오는데 실패했습니다');
      debugPrint('loadPolicies 에러: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      Get.snackbar('오류', '로그아웃 중 오류가 발생했습니다');
    }
  }

  // 카테고리 포맷팅
  // ignore: unused_element
  String _formatCategory(String category) {
    final categories = {
      '자산형성': '💰 자산형성',
      '정신건강': '🧠 정신건강',
      '건강': '🏥 건강관리',
      '취업': '💼 취업지원',
      '주거': '🏠 주거지원',
    };
    return categories[category] ?? '📋 기타';
  }

  // 기관명 포맷팅
  // ignore: unused_element
  String _formatOrganization(String organization) {
    return organization.length > 15
        ? '${organization.substring(0, 12)}...'
        : organization;
  }
}
