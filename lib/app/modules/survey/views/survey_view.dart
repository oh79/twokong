import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/survey_controller.dart';
import '../../../core/theme/theme.dart';
import '../../../widgets/toss_input_field.dart';

class SurveyView extends GetView<SurveyController> {
  const SurveyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.onBackPressed,
        ),
        title: Obx(() => Text('${controller.currentStep.value + 1}/4')),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildNicknameStep(),
                  _buildAgeStep(),
                  _buildOccupationStep(),
                  _buildStressFactorsStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Obx(() {
      final progress = (controller.currentStep.value + 1) / 4;
      return Container(
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(2),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progress,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF4B89DC),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNicknameStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TossInputField(
            label: '닉네임을 입력해주세요',
            hint: '다른 사용자에게 보여질 이름입니다',
            controller: controller.nicknameController,
            maxLength: 10,
          ),
          const Spacer(),
          _buildNextButton('다음'),
        ],
      ),
    );
  }

  Widget _buildAgeStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TossInputField(
            label: '나이를 알려주세요',
            hint: '맞춤 정책을 추천해드릴게요',
            controller: controller.ageController,
            keyboardType: TextInputType.number,
            maxLength: 3,
          ),
          const Spacer(),
          _buildNextButton('다음'),
        ],
      ),
    );
  }

  Widget _buildOccupationStep() {
    return Padding(
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: controller.occupations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final occupation = controller.occupations[index];
                return _buildSelectionTile(
                  title: occupation,
                  isSelected: controller.selectedOccupation.value == occupation,
                  onTap: () => controller.selectOccupation(occupation),
                );
              },
            ),
          ),
          _buildNextButton('다음'),
        ],
      ),
    );
  }

  Widget _buildStressFactorsStep() {
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
          _buildNextButton('완료'),
        ],
      ),
    );
  }

  Widget _buildSelectionTile({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
      ),
    );
  }

  Widget _buildNextButton(String text) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: controller.nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B89DC),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
