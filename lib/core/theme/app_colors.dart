import 'package:flutter/material.dart';

/// Central color palette for the SheltaMe tenant application.
///
/// Keep feature-specific colors out of individual screens. Add new semantic
/// tokens here when a color is genuinely used across the application.
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF032D5C);
  static const Color primaryPressed = Color(0xFF02264D);
  static const Color brandBlue = Color(0xFF0B477A);
  static const Color teal = Color(0xFF13A89E);

  // Status colors
  static const Color success = Color(0xFF00966E);
  static const Color successBackground = Color(0xFFE7F7F0);
  static const Color info = Color(0xFF2463A6);
  static const Color infoBackground = Color(0xFFEAF4FF);
  static const Color warning = Color(0xFF9A6700);
  static const Color warningBackground = Color(0xFFFFF4D6);
  static const Color error = Color(0xFFC0392B);
  static const Color errorBackground = Color(0xFFFFEDEA);

  // Surfaces and typography
  static const Color pageBackground = Color(0xFFF4F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF112A46);
  static const Color secondaryText = Color(0xFF5F738C);
  static const Color hintText = Color(0xFF8193A8);
  static const Color border = Color(0xFFD8E3EF);
  static const Color divider = Color(0xFFE6EDF4);
  static const Color disabled = Color(0xFFA8B6C6);
  static const Color disabledBackground = Color(0xFFE8EDF3);
  static const Color overlay = Color(0x66032D5C);

  // Authentication actions
  static const Color authentication = Color(0xFF0B477A);

  static const Color authenticationPressed = Color(0xFF073A66);

  static const Color onAuthentication = Color(0xFFFFFFFF);
}
