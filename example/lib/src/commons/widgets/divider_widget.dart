import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppDivider {
  AppDivider._();

  static Widget horizontal({
    final double? width,
    final double thickness = 1,
    final double space = 16,
    final double indent = 0,
    final double endIndent = 0,
    final Color? color,
  }) {
    final divider = Divider(
      color: color ?? Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      thickness: thickness,
      height: space,
      indent: indent,
      endIndent: endIndent,
    );

    if (width != null) {
      return SizedBox(width: width, child: divider);
    }

    return divider;
  }

  static Widget vertical({
    final double height = 24,
    final double thickness = 1,
    final double space = 16,
    final Color? color,
  }) {
    return SizedBox(
      height: height,
      child: VerticalDivider(
        width: space,
        thickness: thickness,
        color: color ?? Get.theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
