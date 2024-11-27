import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:twokong/app/widgets/toss_button.dart';
import 'package:twokong/app/widgets/toss_card.dart';
import '../controllers/home_controller.dart';
import '../../../core/widgets/custom_scaffold.dart';
import '../../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: '마음피움',
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeSection(),
              _buildPolicySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TossCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '안녕하세요 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '오늘도 당신의 마음 건강을 응원합니다',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            TossButton(
              text: '상담 시작하기',
              onPressed: () => Get.toNamed(AppRoutes.therapy),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '추천 정책',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.hasError.value) {
                return const Center(child: Text('데이터를 불러오는데 실패했습니다'));
              }

              if (controller.recommendedPolicies.isEmpty) {
                return const Center(
                  child: Text('추천 정책이 없습니다.\n설문을 완료하면 맞춤 정책을 추천해드립니다.'),
                );
              }

              return Column(
                children: controller.recommendedPolicies.map((policy) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TossCard(
                      onTap: () {
                        if (policy.id.isNotEmpty) {
                          Get.toNamed(AppRoutes.policyDetail,
                              arguments: policy);
                        }
                      },
                      child: ListTile(
                        title: Text(
                          policy.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(policy.organization),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}
