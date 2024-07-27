// lib/theme.dart
import 'package:flutter/material.dart';

// Define the main and secondary colors
class AppColors {
  static const Color mainColor = Color(0xFF00ADEF);
  static const Color secondColor = Color(0xFFF57C00);
}

// Create a ThemeData object to use throughout the app
final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.mainColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: AppColors.mainColor,
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: AppColors.mainColor,
  ),

);