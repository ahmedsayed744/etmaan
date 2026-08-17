import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  // ============================================================
  // Light Theme
  // ============================================================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Tajawal',
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.light,
      surface: Colors.white,
    ),

    // =========================
    // AppBar
    // =========================
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xff111827),
      elevation: 0,
    ),

    // =========================
    // Text
    // =========================
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xff111827)),
      bodyMedium: TextStyle(color: Color(0xff111827)),
      bodySmall: TextStyle(color: Color(0xff667085)),
      titleLarge: TextStyle(color: Color(0xff111827)),
      titleMedium: TextStyle(color: Color(0xff111827)),
      titleSmall: TextStyle(color: Color(0xff667085)),
    ),

    // =========================
    // Divider
    // =========================
    dividerTheme: const DividerThemeData(
      color: Color(0xffE4E7EC),
      thickness: 1,
      space: 1,
    ),

    // =========================
    // Card
    // =========================
    cardTheme: const CardThemeData(
      color: Colors.white,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    // =========================
    // Input
    // =========================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xffF1F3F2),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      hintStyle: const TextStyle(color: Color(0xff98A2B3)),
    ),

    // =========================
    // Switch
    // =========================
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }

        return const Color(0xffF9FAFB);
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor.withValues(alpha: 0.45);
        }

        return const Color(0xffD0D5DD);
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }

        return const Color(0xffD0D5DD);
      }),
    ),
  );

  // ============================================================
  // Dark Theme
  // ============================================================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Tajawal',
    brightness: Brightness.dark,

    // #101725
    scaffoldBackgroundColor: AppColors.darkScaffoldBackground,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      surface: AppColors.darkContainer,
      onSurface: AppColors.darkText,
    ),

    // =========================
    // AppBar
    // =========================
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkScaffoldBackground,
      foregroundColor: AppColors.darkText,
      elevation: 0,
    ),

    // =========================
    // Text
    // =========================
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText),
      bodySmall: TextStyle(color: AppColors.darkSecondaryText),
      titleLarge: TextStyle(color: AppColors.darkText),
      titleMedium: TextStyle(color: AppColors.darkText),
      titleSmall: TextStyle(color: AppColors.darkSecondaryText),
    ),

    // =========================
    // Divider
    // =========================
    dividerTheme: const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 1,
    ),

    // =========================
    // Card
    // #1E2735
    // =========================
    cardTheme: const CardThemeData(
      color: AppColors.darkContainer,
      elevation: 0,
      margin: EdgeInsets.zero,
    ),

    // =========================
    // Input
    // =========================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkContainer,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryColor),
      ),
      hintStyle: const TextStyle(color: AppColors.darkSecondaryText),
    ),

    // =========================
    // Switch
    // =========================
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }

        return const Color(0xffD0D5DD);
      }),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }

        return const Color(0xff475467);
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryColor;
        }

        return const Color(0xff667085);
      }),
    ),
  );
}
