import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins', // Example font - ensure it's added to pubspec.yaml
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle subtitle1 = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  static const TextStyle button = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: Colors.white, // Button text is often white or contrasting
    fontFamily: 'Poppins',
  );

   static const TextStyle caption = TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

   static const TextStyle tag = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    color: AppColors.primary, // Use primary color for tags
    fontFamily: 'Poppins',
  );
}

