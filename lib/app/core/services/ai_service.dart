import 'package:get/get.dart';
import '../../data/models/policy_model.dart';
import '../../data/repositories/policy_repository.dart';

class AiService extends GetxService {
  final PolicyRepository _policyRepository = Get.find();

  Future<List<Policy>> getRecommendedPolicies({
    required int age,
    required String occupation,
    required List<String> stressFactors,
  }) async {
    // 연령대와 직업, 스트레스 요인을 기반으로 정책 필터링
    final policies = await _policyRepository.getAllPolicies();

    return policies.where((policy) {
      // 연령 조건 확인
      final isAgeMatch = policy.eligibility.contains('만 $age세');
      // 직업 조건 확인
      final isOccupationMatch = policy.target.contains(occupation);
      // 스트레스 요인과 관련된 태그 확인
      final hasMatchingTags = policy.tags
          .any((tag) => stressFactors.any((factor) => tag.contains(factor)));

      return isAgeMatch && isOccupationMatch && hasMatchingTags;
    }).toList();
  }
}
