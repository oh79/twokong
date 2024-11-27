import 'package:get/get.dart';
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
      // 모든 정책을 가져옵니다
      final policies = await _policyRepository.getPolicies();

      // 여기에 AI 추천 로직을 구현할 수 있습니다
      // 현재는 간단히 모든 정책을 반환합니다
      return policies;
    } catch (e) {
      print('정책 추천 중 오류 발생: $e');
      return [];
    }
  }
}
