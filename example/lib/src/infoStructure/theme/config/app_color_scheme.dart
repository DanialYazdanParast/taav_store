import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppColorScheme {
  static ColorScheme getScheme({
    required bool isDark,
    required Color textPrimary,
  }) {
    final primary =
        isDark ? DarkThemeColors.primaryColor : LightThemeColors.primaryColor;
    final onPrimary =
        isDark
            ? DarkThemeColors.onprimaryColor
            : LightThemeColors.onprimaryColor;
    final secondary =
        isDark ? DarkThemeColors.textPrimary : LightThemeColors.primaryColor;
    final onSecondary =
        isDark
            ? DarkThemeColors.onsecondaryColor
            : LightThemeColors.onsecondaryColor;
    final outline =
        isDark ? DarkThemeColors.borderColor : LightThemeColors.borderColor;

    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return ColorScheme.fromSeed(
      brightness: isDark ? Brightness.dark : Brightness.light,
      seedColor: primary,

      primary: primary,
      onPrimary: onPrimary,

      secondary: secondary,
      onSecondary: onSecondary,
      surface: surface, // رنگ کارت‌ها و دیالوگ‌ها
      onSurface: textPrimary, // رنگ متن و آیکون روی کارت‌ها

      outline: outline,
    );
  }
}
