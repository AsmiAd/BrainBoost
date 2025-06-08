import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_text_styles.dart';

class AppTheme {

  //// Dark theme for the application.
static ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.darkBackground,
  primaryColor: AppColors.primary,
  fontFamily: 'Poppins',
  textTheme: AppTextStyles.textTheme.apply(
    fontFamily: 'Poppins',
    bodyColor: AppColors.darkText, // Override default text color
    displayColor: AppColors.darkText,
  ),
  
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.darkBackground,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.darkText),
  ),
  
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.dark,
    surface: AppColors.darkSurface,
  ).copyWith(error: AppColors.error),

  // Reuse component themes from light theme but adapt colors
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      textStyle: AppTextStyles.buttonLarge,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    filled: true,
    fillColor: AppColors.darkSurface, // Add this to AppColors
    errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
    hintStyle: AppTextStyles.faded.copyWith(color: AppColors.darkText.withOpacity(0.6)),
    labelStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.darkText),
  ),
);

  /// Light theme for the application.
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primary,
    fontFamily: 'Poppins',
    textTheme: AppTextStyles.textTheme.apply(fontFamily: 'Poppins'),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.text),
    ),

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.background,
    ).copyWith(error: AppColors.error),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        textStyle: AppTextStyles.buttonLarge,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      filled: true,
      fillColor: AppColors.white,
      errorStyle: const TextStyle(
        fontFamily: 'Poppins',
        color: AppColors.error,
        fontSize: 13,
      ),
      hintStyle: const TextStyle(
        color: AppColors.grey,
        fontFamily: 'Poppins',
      ),
      labelStyle: const TextStyle(
        color: AppColors.text,
        fontFamily: 'Poppins',
      ),
    ),



  );
}
