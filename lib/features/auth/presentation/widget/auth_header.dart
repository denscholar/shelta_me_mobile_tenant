import 'package:flutter/material.dart';
import 'package:sheltame_tenant_app/core/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    this.showBackButton = false,
    this.title,
    this.onBackPressed,
  });

  final bool showBackButton;
  final String? title;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBackButton || title != null)
          Row(
            children: [
              if (showBackButton)
                IconButton.outlined(
                  onPressed:
                      onBackPressed ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                ),
              if (showBackButton) const SizedBox(width: 8),
              if (title != null)
                Text(title!, style: Theme.of(context).textTheme.labelLarge),
            ],
          ),

        if (showBackButton || title != null) const SizedBox(height: 28),

        Row(
          children: [
            Image.asset('assets/images/shelta_logo.png', width: 38, height: 38),

            const SizedBox(width: 10),

            Text(
              'SheltaMe',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryText,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
