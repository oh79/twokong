import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/policy_model.dart';
import '../../../core/services/ai_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/firebase_service.dart';

class HomeController extends GetxController {
  final AiService _aiService = Get.find();
  final AuthService _authService = Get.find();
  final FirebaseService _firebaseService = Get.find();
  final RxList<Policy> recommendedPolicies = <Policy>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final hasDoneCBTToday = false.obs;
  final dailyFeedback = ''.obs;

  @override
  void onInit() {
    debugPrint('HomeController onInit 시작');
    super.onInit();
    ever(dailyFeedback, (value) => debugPrint('피드백 변경됨: $value'));
    _initializeDailyFeedback();
    loadPolicies();
    checkTodaysCBT();
    debugPrint('HomeController onInit 완료');
  }

  void _initializeDailyFeedback() {
    debugPrint('피드백 초기화 시작');
    final feedbacks = [
      '오늘도 CBT를 통해 마음 건강을 관리해보세요!',
      '스트레스 관리의 첫 걸음, CBT와 함께 시작해보세요.',
      '규칙적인 CBT 기록이 정신 건강 관리의 기본입니다.',
      '오늘 하루 어떠셨나요? CBT로 마음을 정리해보세요.',
    ];

    final random = DateTime.now().millisecondsSinceEpoch % feedbacks.length;
    debugPrint('랜덤 인덱스: $random');
    debugPrint('선택된 피드백: ${feedbacks[random]}');

    dailyFeedback(feedbacks[random]);
    debugPrint('피드백 초기화 완료: ${dailyFeedback.value}');
  }

  void generateDailyFeedback() {
    _initializeDailyFeedback();
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

      final policies = await _firebaseService.getPolicies().first;

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

  Future<void> checkTodaysCBT() async {
    try {
      final user = _authService.user.value;
      if (user != null) {
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        final sessions = await _firebaseService.getCBTSessions(user.uid);
        hasDoneCBTToday.value = sessions.any((session) =>
            session.createdAt.isAfter(startOfDay) &&
            session.createdAt.isBefore(endOfDay));
      }
    } catch (e) {
      debugPrint('checkTodaysCBT 에러: $e');
    }
  }
}
