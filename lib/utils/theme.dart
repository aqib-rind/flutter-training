import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profondo/utils/colors.dart';

class MythemeData {
  static ThemeData lightTheme(BuildContext context) => ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      scaffoldBackgroundColor: AppColors.lightSurface,
      appBarTheme: const AppBarTheme(
        color: AppColors.lightSurface,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.lightPrimaryText),
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        secondary: AppColors.lightSecondary,
        onSecondary: AppColors.lightOnSecondary,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightOnSurface,
        error: AppColors.lightError,
        onError: AppColors.lightOnError,
      ),
      dividerColor: AppColors.lightDivider,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.lightPrimaryText),
        bodyMedium: TextStyle(color: AppColors.lightSecondaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          color: AppColors.lightHintText,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.transparent), // Transparent border when enabled
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.lightPrimary), // Primary color when focused
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.transparent), // Transparent default border
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        filled: true, // Background fill
        fillColor: AppColors.lightDivider, // Light gray fill color
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 50), // Width: 150, Height: 50
          backgroundColor: AppColors.lightPrimary, // Button background color
          foregroundColor: AppColors.lightOnPrimary, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 2, // Optional: slight shadow effect
        ),
      ));

  static ThemeData darkTheme(BuildContext context) => ThemeData(
      fontFamily: GoogleFonts.lato().fontFamily,
      scaffoldBackgroundColor: AppColors.darkSurface,
      appBarTheme: const AppBarTheme(
        color: AppColors.darkSurface,
        elevation: 0.0,
        iconTheme: IconThemeData(color: AppColors.darkPrimaryText),
        centerTitle: true,
      ),
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        secondary: AppColors.darkSecondary,
        onSecondary: AppColors.darkOnSecondary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        error: AppColors.darkError,
        onError: AppColors.darkOnError,
      ),
      dividerColor: AppColors.darkDivider,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.darkPrimaryText),
        bodyMedium: TextStyle(color: AppColors.darkSecondaryText),
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.transparent), // Transparent border when enabled
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.darkPrimary), // Primary color when focused
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.transparent), // Transparent default border
          borderRadius: BorderRadius.circular(10), // Rounded corners
        ),
        filled: true, // Background fill
        fillColor: AppColors.darkDivider, // Dark gray fill color
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 50), // Width: 150, Height: 50
          backgroundColor: AppColors.darkPrimary, // Button background color
          foregroundColor: AppColors.darkOnPrimary, // Text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 2, // Optional: slight shadow effect
        ),
      ));
}
