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

final ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  fontFamily: 'Nunito',
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
);
