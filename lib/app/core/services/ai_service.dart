import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:twokong/app/data/models/policy_model.dart';
import 'package:twokong/app/data/repositories/policy_repository.dart';

import 'dart:convert';

class AiService extends GetxService {
  final PolicyRepository _policyRepository = Get.find();
  final String apiUrl = 'http://localhost:8000/similarity'; // FastAPI 서버 주소

  Future<List<Policy>> getRecommendedPolicies({
    required int age,
    required String occupation,
    required List<String> stressFactors,
  }) async {
    final policies = await _policyRepository.getPolicies();

    // FastAPI 서버로 요청 데이터 생성
    final requestData = {
      'age': age,
      'occupation': occupation,
      'stressFactors': stressFactors,
      'policies': policies.map((policy) => {
        'id': policy.id,
        'eligibility': policy.eligibility,
        'target': policy.target,
        'tags': policy.tags,
        'title': policy.title,
        'organization': policy.organization,
      }).toList(),
    };

    // 서버로 POST 요청 보내기
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestData),
    );

    if (response.statusCode == 200) {
      // jsonDecode 후 Map<String, dynamic>으로 받기
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      
      // 'recommended_policies' 키에서 리스트를 추출하고, 이를 Policy 객체로 변환
      final List<dynamic> policiesJson = responseData['recommended_policies'];

      return policiesJson.map((data) => Policy.fromJson(data)).toList();
    } else {
      throw Exception('추천 정책을 가져오는데 실패했습니다');
    }
  }
}
