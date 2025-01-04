import 'package:flutter/material.dart';

class AppColors {
  // Light theme colors (Black & White Style)
  static const Color lightPrimary = Color(0xFF000000); // Pure black as primary
  static const Color lightOnPrimary = Color(0xFFFFFFFF); // Text on primary
  static const Color lightSecondary =
      Color(0xFFB3B3B3); // Light gray for accents
  static const Color lightOnSecondary = Color(0xFF000000); // Text on secondary
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white surface
  static const Color lightOnSurface = Color(0xFF000000); // Black text on white
  static const Color lightError = Color(0xFFB00020); // Error color
  static const Color lightOnError = Color(0xFFFFFFFF); // Text on error
  static const Color lightPrimaryText = Color(0xFF000000); // Black text
  static const Color lightSecondaryText = Color(0xFF757575); // Subtle gray text
  static const Color lightDivider = Color(0xFFE0E0E0); // Light gray divider
  static const Color lightHintText =
      Color.fromRGBO(156, 156, 156, 1); // Light gray divider

  // Dark theme colors (Black & White Style)
  static const Color darkPrimary = Color(0xFFFFFFFF); // Pure white as primary
  static const Color darkOnPrimary = Color(0xFF000000); // Text on primary
  static const Color darkSecondary = Color(0xFF4D4D4D); // Dark gray for accents
  static const Color darkOnSecondary = Color(0xFFFFFFFF); // Text on secondary
  static const Color darkSurface = Color(0xFF000000); // Pure black surface
  static const Color darkOnSurface = Color(0xFFFFFFFF); // White text on black
  static const Color darkError = Color(0xFFCF6679); // Error color for dark mode
  static const Color darkOnError = Color(0xFF000000); // Text on error
  static const Color darkPrimaryText = Color(0xFFFFFFFF); // White text
  static const Color darkSecondaryText = Color(0xFFB3B3B3); // Subtle gray text
  static const Color darkDivider = Color(0xFF2A2A2A); // Dark gray divider

  // Common colors
  static const Color error = Color(0xFFD32F2F); // Same for light and dark modes
}
