import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Global Material 3 theme for SheltaMe.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.primary,
          onPrimary: AppColors.surface,
          secondary: AppColors.teal,
          onSecondary: AppColors.surface,
          surface: AppColors.surface,
          onSurface: AppColors.primaryText,
          error: AppColors.error,
          onError: AppColors.surface,
          outline: AppColors.border,
          surfaceTint: Colors.transparent,
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: AppTypography.fontFamily,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: AppColors.pageBackground,
      canvasColor: AppColors.surface,
      dividerColor: AppColors.divider,
      visualDensity: VisualDensity.standard,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pageBackground,
        foregroundColor: AppColors.primaryText,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 20,
          height: 1.4,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryText, size: 24),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(0, 56)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          elevation: const WidgetStatePropertyAll(0),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.disabledBackground;
            }

            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryPressed;
            }

            return AppColors.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.secondaryText;
            }

            return AppColors.surface;
          }),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.surface.withValues(alpha: 0.10);
            }

            return null;
          }),
          textStyle: WidgetStatePropertyAll(AppTypography.textTheme.labelLarge),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandBlue,
          backgroundColor: AppColors.surface,
          disabledForegroundColor: AppColors.disabled,
          minimumSize: const Size(0, 48),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          side: const BorderSide(color: AppColors.border),
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.brandBlue,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandBlue,
          textStyle: AppTypography.textTheme.labelLarge?.copyWith(
            color: AppColors.brandBlue,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        hintStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.hintText,
        ),
        labelStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.secondaryText,
        ),
        helperStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.secondaryText,
        ),
        errorStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.disabledBackground),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryText,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: AppColors.surface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        circularTrackColor: AppColors.border,
        linearTrackColor: AppColors.border,
        refreshBackgroundColor: AppColors.surface,
      ),
    );
  }
}
