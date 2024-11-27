import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twokong/app/routes/app_routes.dart';
import 'package:twokong/app/widgets/toss_button.dart';
import 'package:twokong/app/widgets/toss_card.dart';
import '../controllers/profile_controller.dart';
import '../../../core/widgets/custom_scaffold.dart';
import '../../../core/theme/theme.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '프로필',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 24),
            _buildMenuSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Obx(() {
      final user = controller.userInfo.value;

      return TossCard(
        child: Row(
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, size: 32, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user?.nickname ?? '사용자',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            TossButton(
              text: '수정',
              onPressed: () => Get.toNamed(AppRoutes.survey),
              isOutlined: true,
              height: 36,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '히스토리 관리',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TossCard(
          onTap: () => Get.toNamed(AppRoutes.cbtHistory),
          child: _buildMenuItem(
            icon: Icons.psychology_outlined,
            title: 'CBT 기록',
            showArrow: true,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '관심 정책',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TossCard(
          onTap: () => Get.toNamed(AppRoutes.favoritePolicy),
          child: _buildMenuItem(
            icon: Icons.favorite_outline,
            title: '관심 정책',
            showArrow: true,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          '설정',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TossCard(
          onTap: () => Get.toNamed(AppRoutes.alarmSettings),
          child: _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: '알림 설정',
            showArrow: true,
          ),
        ),
        const SizedBox(height: 12),
        TossCard(
          onTap: () => Get.toNamed(AppRoutes.privacySettings),
          child: _buildMenuItem(
            icon: Icons.security_outlined,
            title: '개인정보 관리',
            showArrow: true,
          ),
        ),
        const SizedBox(height: 12),
        TossCard(
          onTap: () => controller.handleSignOut(),
          child: _buildMenuItem(
            icon: Icons.logout,
            title: '로그아웃',
            isDestructive: true,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String title,
    required IconData icon,
    bool isDestructive = false,
    bool showArrow = false,
    Color? textColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isDestructive ? Colors.red : AppTheme.textColor,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isDestructive ? Colors.red : AppTheme.textColor,
          ),
        ),
        const Spacer(),
        if (showArrow) const Icon(Icons.arrow_forward_ios, size: 16),
      ],
    );
  }
}
