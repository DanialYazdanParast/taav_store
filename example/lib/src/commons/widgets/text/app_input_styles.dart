import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';

class AppInputStyles {
  AppInputStyles._();

  // --- Border Styles ---

  static OutlineInputBorder get normalBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Get.theme.colorScheme.outline, width: 2),
    borderRadius: AppSize.brMedium,
  );

  static OutlineInputBorder get focusedBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Get.theme.colorScheme.primary, width: 2),
    borderRadius: AppSize.brMedium,
  );

  static OutlineInputBorder get errorBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Get.theme.colorScheme.error, width: 2),
    borderRadius: AppSize.brMedium,
  );

  static OutlineInputBorder get focusedErrorBorder => OutlineInputBorder(
    borderSide: BorderSide(color: Get.theme.colorScheme.error, width: 2),
    borderRadius: AppSize.brMedium,
  );

  static OutlineInputBorder get disabledBorder => OutlineInputBorder(
    borderSide: BorderSide(
      color: Get.theme.colorScheme.outline.withValues(alpha:  0.5),
      width: 1,
    ),
    borderRadius: AppSize.brMedium,
  );

  // --- Text Styles ---

  static TextStyle get textStyle => TextStyle(
    fontSize: AppSize.f14, // Normal
    color: Get.theme.colorScheme.onSurface,
    fontWeight: FontWeight.w400,
  );

  static TextStyle get labelStyle => TextStyle(
    fontSize: AppSize.f14,
    color: Get.theme.colorScheme.onSurfaceVariant,
  );

  static TextStyle get hintStyle =>
      TextStyle(fontSize: AppSize.f14, color: Get.theme.hintColor);

  static TextStyle get errorStyle => TextStyle(
    fontSize: AppSize.f12, // Small
    color: Get.theme.colorScheme.error,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get helperStyle => TextStyle(
    fontSize: AppSize.f12, // Small
    color: Get.theme.colorScheme.onSurfaceVariant,
  );

  static TextStyle get prefixStyle => TextStyle(
    fontSize: AppSize.f14, // سایز متن
    color: Get.theme.colorScheme.onSurface.withValues(
    alpha:   0.6,
    ), // رنگ خاکستری ملایم
    fontWeight: FontWeight.w500, // کمی ضخیم‌تر
  );
}
