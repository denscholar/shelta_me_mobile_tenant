import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../models/onboarding_item.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingItem item;
  final int index;

  const OnboardingPage({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.39,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: DecorationImage(
                  image: AssetImage(item.image),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Show the badge only on the first screen.
            if (index == 0)
              Positioned(
                left: 16,
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.home_outlined,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'A place to call your own',
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 36),

        Text(
          item.tag,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 12),

        Text(item.title, style: textTheme.displayMedium),

        const SizedBox(height: 16),

        Text(
          item.description,
          style: textTheme.bodyLarge?.copyWith(color: AppColors.secondaryText),
        ),
      ],
    );
  }
}
