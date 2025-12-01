import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      backgroundColor: LightThemeColors.backgroundColor,
    );
  }

  static ThemeData get dark {
    return _buildTheme(
      isDark: true,
      primaryColor: DarkThemeColors.primaryColor,
      textPrimary: DarkThemeColors.textPrimary,
      textSecondary: DarkThemeColors.textSecondary,
      backgroundColor: DarkThemeColors.backgroundColor,
    );
  }

  static ThemeData _buildTheme({
    required bool isDark,
    required Color primaryColor,
    required Color textPrimary,
    required Color textSecondary,
    required Color backgroundColor,
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
      scaffoldBackgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: textPrimary),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark,
          statusBarIconBrightness:
              isDark ? Brightness.light : Brightness.dark, // Android
          statusBarBrightness:
              isDark ? Brightness.dark : Brightness.light, // iOS
        ),
      ),
    );
  }
}
