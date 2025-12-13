import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const Responsive({super.key, required this.mobile, required this.desktop});

  static bool get isMobile => Get.width < 900;
  static bool get isDesktop => Get.width >= 900;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (isDesktop) {
          return desktop;
        } else {
          return mobile;
        }
      },
    );
  }
}
