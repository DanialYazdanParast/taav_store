import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppColorScheme {
  static ColorScheme getScheme({
    required bool isDark,
    required Color textPrimary,
  }) {
    final primary = isDark ? DarkColors.primaryColor : LightColors.primaryColor;
    final onPrimary =
        isDark ? DarkColors.onprimaryColor : LightColors.onprimaryColor;
    final secondary =
        isDark ? DarkColors.textPrimary : LightColors.primaryColor;
    final onSecondary =
        isDark ? DarkColors.onsecondaryColor : LightColors.onsecondaryColor;
    final outline = isDark ? DarkColors.borderColor : LightColors.borderColor;
    final disabledColor =
        isDark ? DarkColors.disabledColor : LightColors.disabledColor;

    final errorColor = isDark ? DarkColors.errorColor : LightColors.errorColor;

    final surface = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    return ColorScheme.fromSeed(
      brightness: isDark ? Brightness.dark : Brightness.light,

      primary: primary,

      secondary: secondary,

      outlineVariant: disabledColor,

      error: errorColor,

      //------------------------
      seedColor: primary,

      onPrimary: onPrimary,

      onSecondary: onSecondary,
      surface: surface, // رنگ کارت‌ها و دیالوگ‌ها
      onSurface: textPrimary, // رنگ متن و آیکون روی کارت‌ها

      outline: outline,
    );
  }
}
