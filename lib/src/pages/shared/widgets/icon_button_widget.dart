import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? bgColor;
  final bool hasBorder;
  final double? size;

  const IconButtonWidget({
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
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.r10),
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(AppSize.p8),
        decoration: BoxDecoration(
          color: bgColor ?? Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSize.r10),
          border: hasBorder ? Border.all(color: theme.dividerColor) : null,
        ),
        child: Icon(icon, size: size ?? 22, color: color ?? Colors.white),
      ),
    );
  }
}
