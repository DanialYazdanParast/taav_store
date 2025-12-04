import 'package:example/src/commons/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? bgColor;
  final bool hasBorder;
  final double? size;

  const SellerIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.bgColor,
    this.hasBorder = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSize.p8),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppSize.r10),
          border: hasBorder ? Border.all(color: theme.dividerColor) : null,
        ),
        child: Icon(
          icon,
          color: color ?? Colors.white,
          size: size ?? 22,
        ),
      ),
    );
  }
}