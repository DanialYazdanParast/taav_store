import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTextTheme {
  static TextTheme getTheme({
    required Color textPrimary,
    required Color textSecondary,
    required Color primaryColor,
  }) {
    final locale = Get.locale;
    final isFa = locale?.languageCode == 'fa' || locale?.languageCode == 'ar';
    final fontFamily = isFa ? 'Vazir' : 'Roboto';

    return TextTheme(
      titleLarge: TextStyle(
        //  fontFamily: fontFamily,
        color: textPrimary,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),

      titleMedium: TextStyle(
        //   fontFamily: fontFamily,
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),

      titleSmall: TextStyle(
        //   fontFamily: fontFamily,
        color: primaryColor,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),

      bodyMedium: TextStyle(
        //   fontFamily: fontFamily,
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      bodySmall: TextStyle(
        //  fontFamily: fontFamily,
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
