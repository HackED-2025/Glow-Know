import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xffecf3fe);
  static const Color primary = Color(0xff4aa187);
  static const Color secondary = Color(0xff5dc06e);
  static const Color fontPrimary = Color.fromARGB(255, 15, 9, 61);
  static const Color fontSecondary = Color.fromARGB(255, 21, 119, 67);
}

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
    ),
  );
}
