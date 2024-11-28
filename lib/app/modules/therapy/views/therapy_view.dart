import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twokong/app/core/theme/theme.dart';
import 'package:twokong/app/routes/app_routes.dart';
import 'package:twokong/app/widgets/toss_button.dart';
import 'package:twokong/app/widgets/toss_card.dart';
import '../controllers/therapy_controller.dart';
import '../../../core/widgets/custom_scaffold.dart';

class TherapyView extends GetView<TherapyController> {
  const TherapyView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '심리상담',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TossCard(
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
                        child: Icon(
                          Icons.psychology,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '인지행동치료 (CBT)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '일상 속 부정적 사고 패턴을 발견하고 교정하는 CBT 기법',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TossButton(
                    text: 'CBT 시작하기',
                    onPressed: () => Get.toNamed(AppRoutes.cbt),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TossCard(
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
                        child: Icon(
                          Icons.schema,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '심리도식치료 (Schema Therapy)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '어린 시절부터 형성된 부정적 사고 패턴을 인식하고 교정하는 치료',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TossButton(
                    text: '도식치료 시작하기',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TossCard(
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
                        child: Icon(
                          Icons.support_agent,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '전문 상담사와 함께하는\n마음 치유',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '전문가와 함께 당신의 마음 건강을 돌보세요',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TossButton(
                    text: '상담 예약하기',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TossCard(
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
                        child: Icon(
                          Icons.self_improvement,
                          color: AppTheme.primaryColor,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '수용전념치료 (ACT)',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '현재의 감정을 수용하고 가치 있는 삶을 향해 나아가는 치료',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TossButton(
                    text: 'ACT 시작하기',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '상담 프로그램',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTherapyPrograms(),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapyPrograms() {
    return Column(
      children: [
        TossCard(
          onTap: () {},
          child: _buildProgramItem(
            title: '1:1 화상상담',
            description: '전문 상담사와 편안한 공간에서 1:1 화상상담',
            icon: Icons.videocam_outlined,
          ),
        ),
        const SizedBox(height: 12),
        TossCard(
          onTap: () {},
          child: _buildProgramItem(
            title: '채팅상담',
            description: '부담없이 시작하는 채팅 상담',
            icon: Icons.chat_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildProgramItem({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, size: 32, color: AppTheme.primaryColor),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}
