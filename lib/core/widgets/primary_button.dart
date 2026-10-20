import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Reusable SheltaMe primary action button.
///
/// Behaviour:
/// - Enabled: primary background with white content.
/// - Loading: primary background with white spinner.
/// - Disabled: disabled grey background.
///
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.expand = true,
    this.height = 56,
    this.leading,
    this.trailing,
    this.backgroundColor,
    this.loadingBackgroundColor,
    this.foregroundColor = AppColors.surface,
    this.loadingIndicatorColor = AppColors.surface,
  });

  final String label;
  final VoidCallback? onPressed;

  final bool isLoading;
  final bool expand;
  final double height;

  final Widget? leading;
  final Widget? trailing;

  /// Normal enabled button colour.
  final Color? backgroundColor;

  /// Button colour displayed while loading.
  ///
  /// Defaults to the normal background colour.
  final Color? loadingBackgroundColor;

  /// Text and icon colour.
  final Color foregroundColor;

  /// Spinner colour while loading.
  final Color loadingIndicatorColor;

  @override
  Widget build(BuildContext context) {
    final normalBackgroundColor = backgroundColor ?? AppColors.primary;

    final effectiveLoadingBackgroundColor =
        loadingBackgroundColor ?? normalBackgroundColor;

    final isActuallyDisabled = onPressed == null && !isLoading;

    final effectiveBackgroundColor = isLoading
        ? effectiveLoadingBackgroundColor
        : normalBackgroundColor;

    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        /*
         * During loading, the button remains technically enabled but
         * receives an empty callback. This prevents duplicate requests
         * while keeping the loading background colour instead of using
         * Flutter's grey disabled style.
         */
        onPressed: isLoading ? () {} : onPressed,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (isActuallyDisabled || states.contains(WidgetState.disabled)) {
              return AppColors.disabledBackground;
            }

            if (states.contains(WidgetState.pressed) && !isLoading) {
              return AppColors.primaryPressed;
            }

            return effectiveBackgroundColor;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (isActuallyDisabled || states.contains(WidgetState.disabled)) {
              return AppColors.secondaryText;
            }

            return foregroundColor;
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (isLoading) {
              return Colors.transparent;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.surface.withValues(alpha: 0.10);
            }

            return null;
          }),
          textStyle: WidgetStatePropertyAll(
            Theme.of(context).textTheme.labelLarge,
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: isLoading
              ? SizedBox.square(
                  key: const ValueKey('loading'),
                  dimension: 23,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: loadingIndicatorColor,
                    backgroundColor: loadingIndicatorColor.withValues(
                      alpha: 0.24,
                    ),
                  ),
                )
              : Row(
                  key: const ValueKey('content'),
                  mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (leading != null) ...[
                      IconTheme(
                        data: IconThemeData(color: foregroundColor),
                        child: leading!,
                      ),
                      const SizedBox(width: 10),
                    ],
                    if (expand)
                      Expanded(
                        child: Center(
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    if (trailing != null) ...[
                      const SizedBox(width: 10),
                      IconTheme(
                        data: IconThemeData(color: foregroundColor),
                        child: trailing!,
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
