import 'package:flutter/material.dart';
import 'config/app_color_scheme.dart';
import 'config/app_colors.dart';
import 'config/app_text_theme.dart';

class AppTheme {
  static ThemeData get light {
    return _buildTheme(
      isDark: false,
      primaryColor: LightThemeColors.primaryColor,
      textPrimary: const Color.fromARGB(255, 56, 43, 43),
      textSecondary: LightThemeColors.textSecondary,
    );
  }

  static ThemeData get dark {
    return _buildTheme(
      isDark: true,
      primaryColor: DarkThemeColors.primaryColor,
      textPrimary: DarkThemeColors.textPrimary,
      textSecondary: DarkThemeColors.textSecondary,
    );
  }

  static ThemeData _buildTheme({
    required bool isDark,
    required Color primaryColor,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final colorScheme = AppColorScheme.getScheme(
      isDark: isDark,
      textPrimary: textPrimary,
    );

    final textTheme = AppTextTheme.getTheme(
      textPrimary: textPrimary,
      textSecondary: textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: primaryColor,
      iconTheme: IconThemeData(color: textPrimary),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
    );
  }
}
