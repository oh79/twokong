import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/survey_controller.dart';
import '../../../core/theme/theme.dart';
import '../../../widgets/toss_input_field.dart';
import '../../../widgets/toss_card.dart';
import '../../../widgets/toss_button.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설문조사'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.onBackPressed,
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // 진행 상태 표시
          Obx(() => LinearProgressIndicator(
                value: (controller.currentStep.value + 1) / 4,
                backgroundColor: Colors.grey[200],
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              )),
          const SizedBox(height: 16),
          // 단계 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Text(
                  '${controller.currentStep.value + 1}/4',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNicknamePage(),
                _buildAgePage(),
                _buildOccupationPage(),
                _buildStressFactorsPage(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Obx(() => _buildNextButton(
                  controller.currentStep.value == 3 ? '완료' : '다음',
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildNicknamePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '닉네임을 입력해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '다른 사용자에게 보여질 이름입니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          TossCard(
            child: TossInputField(
              label: '닉네임',
              hint: '닉네임을 입력하세요',
              controller: controller.nicknameController,
              maxLength: 30,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAgePage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '나이를 알려주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '맞춤 정책을 추천해드릴게요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          TossCard(
            child: TossInputField(
              label: '나이',
              hint: '나이를 입력하세요',
              controller: controller.ageController,
              keyboardType: TextInputType.number,
              maxLength: 3,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOccupationPage() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '현재 직업을 선택해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '맞춤 정책을 추천해드릴게요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: controller.occupations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final occupation = controller.occupations[index];
                return Obx(() => TossCard(
                      onTap: () => controller.selectOccupation(occupation),
                      child: _buildSelectionTile(
                        title: occupation,
                        isSelected:
                            controller.selectedOccupation.value == occupation,
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStressFactorsPage() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '스트레스 요인을 선택해주세요',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '해당되는 항목을 모두 선택해주세요',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Obx(() => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.stressFactors.map((factor) {
                    final isSelected =
                        controller.selectedFactors.contains(factor);
                    return FilterChip(
                      label: Text(factor),
                      selected: isSelected,
                      onSelected: (_) => controller.toggleStressFactor(factor),
                      selectedColor: const Color(0xFF4B89DC).withOpacity(0.2),
                      checkmarkColor: const Color(0xFF4B89DC),
                      labelStyle: TextStyle(
                        color:
                            isSelected ? const Color(0xFF4B89DC) : Colors.black,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4B89DC).withOpacity(0.1)
            : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF4B89DC) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFF4B89DC) : Colors.black,
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              Icons.check_circle,
              color: Color(0xFF4B89DC),
            ),
        ],
      ),
    );
  }

  Widget _buildNextButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: TossButton(
          text: text,
          onPressed: () => controller.nextStep(),
        ),
      ),
    );
  }
}
