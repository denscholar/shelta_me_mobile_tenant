import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Shared typography tokens for the SheltaMe tenant application.
///
/// Inter should be bundled in assets/fonts and registered in pubspec.yaml
/// to ensure consistent rendering across Android and iOS.
abstract final class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 36,
      height: 1.2,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.7,
      color: AppColors.primaryText,
    ),

    displayMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 30,
      height: 1.25,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      color: AppColors.primaryText,
    ),

    displaySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 27,
      height: 1.25,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: AppColors.primaryText,
    ),

    headlineLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 26,
      height: 1.3,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      color: AppColors.primaryText,
    ),

    headlineMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 24,
      height: 1.33,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
      color: AppColors.primaryText,
    ),

    headlineSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 22,
      height: 1.35,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryText,
    ),

    titleLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 21,
      height: 1.4,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryText,
    ),

    titleMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 18,
      height: 1.45,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryText,
    ),

    titleSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.45,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryText,
    ),

    bodyLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 17,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryText,
    ),

    bodyMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryText,
    ),

    bodySmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.45,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryText,
    ),

    labelLarge: TextStyle(
      fontFamily: fontFamily,
      fontSize: 16,
      height: 1.4,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryText,
    ),

    labelMedium: TextStyle(
      fontFamily: fontFamily,
      fontSize: 14,
      height: 1.4,
      fontWeight: FontWeight.w600,
      color: AppColors.secondaryText,
    ),

    labelSmall: TextStyle(
      fontFamily: fontFamily,
      fontSize: 13,
      height: 1.4,
      fontWeight: FontWeight.w500,
      color: AppColors.secondaryText,
    ),
  );
}
