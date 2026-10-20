import 'package:flutter/material.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';

class AuthSecurityCard extends StatelessWidget {
  const AuthSecurityCard({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.infoBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.info, size: 20),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: AppColors.primaryText),
                ),

                const SizedBox(height: 4),

                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
