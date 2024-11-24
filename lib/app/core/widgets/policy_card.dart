import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/policy_model.dart';
import '../../routes/app_pages.dart';

class PolicyCard extends StatelessWidget {
  final Policy policy;

  const PolicyCard({
    super.key,
    required this.policy,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: _onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                policy.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                policy.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: policy.tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          backgroundColor: Colors.blue[50],
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    Get.toNamed(AppRoutes.policyDetail, arguments: policy);
  }
}
