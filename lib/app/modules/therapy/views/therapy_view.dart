import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twokong/app/core/theme/theme.dart';
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
                  const Text(
                    '전문 상담사와 함께하는\n마음 치유',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
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
