import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/toss_card.dart';
import '../controllers/favorite_policy_controller.dart';
import '../../../routes/app_routes.dart';

class FavoritePolicyView extends GetView<FavoritePolicyController> {
  const FavoritePolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('관심 정책'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.favoritePolicies.isEmpty) {
          return const Center(child: Text('관심 정책이 없습니다'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.favoritePolicies.length,
          itemBuilder: (context, index) {
            final policy = controller.favoritePolicies[index];
            return TossCard(
              onTap: () => Get.toNamed(
                AppRoutes.policyDetail,
                arguments: policy,
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            policy.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            policy.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.business,
                                  size: 16, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Text(
                                policy.organization,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey[400]),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
