import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../data/repositories/policy_repository.dart';
import '../../data/models/policy_model.dart';

class AiService extends GetxService {
  final PolicyRepository _policyRepository = Get.find<PolicyRepository>();

  Future<List<Policy>> getRecommendedPolicies({
    required int age,
    required String occupation,
    required List<String> stressFactors,
  }) async {
    try {
      final policies = await _policyRepository.getPolicies();
      return policies;
    } catch (e) {
      debugPrint('정책 추천 중 오류 발생: $e');
      return [];
    }
  }
}
