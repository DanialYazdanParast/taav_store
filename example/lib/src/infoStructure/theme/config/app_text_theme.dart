import 'package:flutter/material.dart';

class AppTextTheme {
  static TextTheme getTheme({
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
  }) {

    return TextTheme(
      titleLarge: TextStyle(
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      titleMedium: TextStyle(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      titleSmall: TextStyle(
        color: primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(
        color: textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
