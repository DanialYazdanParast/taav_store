import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLoading {
  AppLoading._();

  static Widget circular({
    final double size = 24,
    final double strokeWidth = 2.5,
    final Color? color,
    final Color? backgroundColor,
  }) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color ?? Get.theme.colorScheme.primary,
        backgroundColor: backgroundColor,
      ),
    );
  }

  static Widget linear({
    final double? width,
    final double height = 4,
    final Color? color,
    final Color? backgroundColor,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: LinearProgressIndicator(
        minHeight: height,
        color: color ?? Get.theme.colorScheme.primary,
        backgroundColor:
            backgroundColor ?? Get.theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(height),
      ),
    );
  }
}
