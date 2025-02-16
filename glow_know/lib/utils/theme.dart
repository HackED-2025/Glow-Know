import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Color(0xFFFAFFFF);
  static const Color primary = Color(0xFF1D294A);
  static const Color secondary = Color(0xFF1D294A);
  static const Color highlight = Color(0xFFF6ADAF);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    scaffoldBackgroundColor: AppColors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
    ),
  );
}
