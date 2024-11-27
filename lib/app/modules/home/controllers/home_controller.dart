//import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/policy_model.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeController extends GetxController {
  final AiService _aiService = Get.find();
  final AuthService _authService = Get.find();
  final recommendedPolicies = <Policy>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      isLoading(true);
      hasError(false);

      final policyDocs = await _firestore.collection('policies').get();

      final policies = policyDocs.docs.map((doc) {
        return Policy.fromFirestore(doc);
      }).toList();

      // 정책 정렬: 1) 마감임박 2) 카테고리 3) 기관명
      policies.sort((a, b) {
        // 마감일 기준 정렬
        if (a.deadline != null && b.deadline != null) {
          return a.deadline!.compareTo(b.deadline!);
        }
        if (a.deadline != null) return -1;
        if (b.deadline != null) return 1;

        // 카테고리 기준 정렬
        final categoryCompare = a.category.compareTo(b.category);
        if (categoryCompare != 0) return categoryCompare;

        // 기관명 기준 정렬
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
    } finally {
      isLoading(false);
    }
  }

  Future<void> handleSignOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      // debugPrint 대신 개발자 로그를 위해 print 사용
      // ignore: avoid_print
      print('=== 로그아웃 에러 ===\n$e');
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
