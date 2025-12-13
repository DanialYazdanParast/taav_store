import 'package:taav_store/src/infoStructure/languages/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/commons/constants/app_png.dart';

class AnimatedLogo extends StatelessWidget {
  final double width;

  const AnimatedLogo({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1500),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: GestureDetector(
        onTap: () => Get.find<LocalizationController>().toggleLocale(),
        child: Image.asset(
          AppPng.logo,
          width: width,
          color: context.theme.colorScheme.secondary,
        ),
      ),
    );
  }
}
