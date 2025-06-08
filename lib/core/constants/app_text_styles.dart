import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppTextStyles {
  // Headings
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700, // Bold (700)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold (600)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600, // SemiBold (600)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  static const faded = TextStyle(
    fontSize: 14,
    color: AppColors.grey,
    fontWeight: FontWeight.w400,
    fontFamily: 'Poppins',
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular (400)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular (400)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular (400)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  // Captions & Subtle Text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular (400)
    fontFamily: 'Poppins',
    color: AppColors.grey,
  );

  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold (600)
    fontFamily: 'Poppins',
    color: AppColors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold (600)
    fontFamily: 'Poppins',
    color: AppColors.white,
  );

  // Flashcard-Specific Styles
  static const TextStyle cardFront = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700, // Bold (700)
    fontFamily: 'Poppins',
    color: AppColors.text,
  );

  static const TextStyle cardBack = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400, // Regular (400)
    fontFamily: 'Poppins',
    color: AppColors.grey,
  );

  // TextTheme for Material App
  static final TextTheme textTheme = TextTheme(
  displayLarge: AppTextStyles.headingLarge,
  displayMedium: AppTextStyles.headingMedium,
  displaySmall: AppTextStyles.headingSmall,
  bodyLarge: AppTextStyles.bodyLarge,
  bodyMedium: AppTextStyles.bodyMedium,
  bodySmall: AppTextStyles.bodySmall,
  labelLarge: AppTextStyles.buttonLarge,  // Buttons
  labelSmall: AppTextStyles.buttonSmall,
  titleMedium: AppTextStyles.cardFront,   // Flashcard front
  titleSmall: AppTextStyles.cardBack,    // Flashcard back
);


}