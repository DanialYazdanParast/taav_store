// lib/src/infrastructure/widgets/app_radio_button.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppRadio extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;
  final double size;
  final double innerSizeRatio;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Duration animationDuration;

  const AppRadio({
    super.key,
    required this.isSelected,
    this.onTap,
    this.size = 20,
    this.innerSizeRatio = 0.5,
    this.selectedColor,
    this.unselectedColor,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final activeColor = selectedColor ?? colorScheme.secondary;
    final inactiveColor = unselectedColor ?? colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? activeColor : inactiveColor,
            width: 2,
          ),
        ),
        child:
            isSelected
                ? Center(
                  child: AnimatedContainer(
                    duration: animationDuration,
                    width: size * innerSizeRatio,
                    height: size * innerSizeRatio,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: activeColor,
                    ),
                  ),
                )
                : null,
      ),
    );
  }
}
