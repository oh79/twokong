import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twokong/app/core/theme/theme.dart';
import 'package:twokong/app/core/widgets/custom_scaffold.dart';
import 'package:twokong/app/modules/cbt/controllers/cbt_controller.dart';
import 'package:twokong/app/widgets/toss_button.dart';
import 'package:twokong/app/widgets/toss_card.dart';

class CBTView extends GetView<CBTController> {
  const CBTView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '인지행동치료',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStepCard(
              step: 1,
              title: '상황 기록',
              description: '현재 어떤 상황에 처해 있나요?\n가능한 구체적으로 설명해주세요.',
              hint: '예시: 오늘 오후 3시경 팀장님께 업무 피드백을 받는 상황',
              controller: controller.situationController,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: 2,
              title: '자동적 사고',
              description:
                  '이 상황에서 자연스럽게 떠오른 생각은 무엇인가요?\n그 생각이 사실이라고 확신하는 근거가 있나요?',
              hint: '예시: 내 능력이 부족한 것 같다, 다른 동료들은 이런 실수를 하지 않을 것이다',
              controller: controller.thoughtController,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: 3,
              title: '감정 기록',
              description: '어떤 감정이 들었나요?\n감정의 강도를 0-10 사이로 표현해주세요.',
              hint: '예시: 불안감(8/10), 부끄러움(6/10), 자책감(7/10)',
              controller: controller.emotionController,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: 4,
              title: '대안적 사고',
              description: '이 상황을 다른 관점에서 보면 어떨까요?\n제3자가 본다면 어떻게 평가할 것 같나요?',
              hint: '예시: 실수를 통해 배우는 것도 성장의 과정이다, 팀장님의 피드백은 나의 발전을 위한 것이다',
              controller: controller.rationalThoughtController,
            ),
            const SizedBox(height: 16),
            _buildStepCard(
              step: 5,
              title: '행동 계획',
              description:
                  '현재 상황에서 실천 가능한 구체적인 행동은 무엇인가요?\n이 행동이 가져올 결과를 예상해보세요.',
              hint:
                  '예시: 팀장님께 피드백 받은 내용을 정리하고 개선 계획을 수립한다, 비슷한 실수를 방지하기 위한 체크리스트를 만든다',
              controller: controller.actionPlanController,
            ),
            const SizedBox(height: 24),
            TossButton(
              text: '저장하기',
              onPressed: controller.saveCBTSession,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepCard({
    required int step,
    required String title,
    required String description,
    required String hint,
    required TextEditingController controller,
  }) {
    return TossCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'STEP $step',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
