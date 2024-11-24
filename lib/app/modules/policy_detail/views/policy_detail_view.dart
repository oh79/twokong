import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/policy_detail_controller.dart';
import '../../../widgets/policy_info_card.dart';
import '../../../core/theme/theme.dart';
import 'package:intl/intl.dart';

class PolicyDetailView extends GetView<PolicyDetailController> {
  const PolicyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Obx(() => Text(controller.policy.value.title)),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  controller.isFavorite.value
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: controller.isFavorite.value
                      ? Colors.red
                      : AppTheme.secondaryTextColor,
                )),
            onPressed: controller.toggleFavorite,
          ),
        ],
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PolicyInfoCard(
                  title: '지원 대상',
                  content: controller.policy.value.target,
                  icon: Icons.people_outline,
                ),
                const SizedBox(height: 16),
                PolicyInfoCard(
                  title: '신청 방법',
                  content: controller.policy.value.howToApply,
                  icon: Icons.edit_document,
                ),
                const SizedBox(height: 16),
                PolicyInfoCard(
                  title: '마감일',
                  content: controller.policy.value.deadline != null
                      ? DateFormat('yyyy.MM.dd')
                          .format(controller.policy.value.deadline!)
                      : '상시',
                  icon: Icons.calendar_today,
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: controller.applyPolicy,
                    child: const Text(
                      '신청하기',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
