import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.desktop,
    this.tablet,
  });

  static bool get isMobile => Get.width < 600;
  static bool get isTablet => Get.width >= 600 && Get.width < 1024;
  static bool get isDesktop => Get.width >= 1024;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      return desktop;
    } else if (isTablet) {
      return tablet ?? mobile;
    }
    return mobile;
  }
}
