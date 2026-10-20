import 'package:flutter/material.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (index) {
        final active = currentIndex == index;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 50 : 8,
          height: 6,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }),
    );
  }
}
