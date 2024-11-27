import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/policy_model.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final AiService _aiService = Get.find();
  final AuthService _authService = Get.find();
  final RxList<Policy> recommendedPolicies = <Policy>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  @override
  void onReady() {
    super.onReady();
    loadPolicies();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading(true);
      hasError(false);

      final policyDocs = await _firestore.collection('policies').get();
      final policies = policyDocs.docs.map((doc) {
        return Policy.fromFirestore(doc);
      }).toList();

      policies.sort((a, b) {
        if (a.deadline != null && b.deadline != null) {
          return a.deadline!.compareTo(b.deadline!);
        }
        if (a.deadline != null) return -1;
        if (b.deadline != null) return 1;

        final categoryCompare = a.category.compareTo(b.category);
        if (categoryCompare != 0) return categoryCompare;

        return a.organization.compareTo(b.organization);
      });

      recommendedPolicies.value = policies;
    } catch (e) {
      hasError(true);
      Get.snackbar(
        '오류',
        '데이터를 불러오는데 실패했습니다',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadPolicies() async {
    try {
      isLoading(true);
      hasError(false);

      final currentUser = _authService.user.value;
      if (currentUser == null) {
        await _loadInitialData();
        return;
      }

      final userData = await _authService.getUserData(currentUser.uid);
      final policies = await _aiService.getRecommendedPolicies(
        age: userData?.age ?? 25,
        occupation: userData?.occupation ?? '회사원',
        stressFactors: userData?.stressFactors ?? ['업무과중', '대인관계'],
      );

      if (policies.isNotEmpty) {
        recommendedPolicies.value = policies;
      }
    } catch (e) {
      hasError(true);
      Get.snackbar('오류', '데이터를 불러오는데 실패했습니다');
      debugPrint('loadPolicies 에러: $e');
      await _loadInitialData();
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

  Future<void> refreshPolicies({
    int? age,
    String? occupation,
    List<String>? stressFactors,
  }) async {
    try {
      isLoading(true);
      final policies = await _aiService.getRecommendedPolicies(
        age: age ?? 25,
        occupation: occupation ?? '회사원',
        stressFactors: stressFactors ?? ['업무과중', '대인관계'],
      );
      recommendedPolicies.value = policies;
    } catch (e) {
      hasError(true);
      Get.snackbar('오류', '데이터를 불러오는데 실패했습니다');
      await _loadInitialData();
    } finally {
      isLoading(false);
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
