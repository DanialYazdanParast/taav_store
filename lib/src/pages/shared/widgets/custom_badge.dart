import 'package:flutter/material.dart';

class CustomBadge extends StatelessWidget {
  final int? badgeCount;

  final Color? backgroundColor;
  final Color? textColor;
  final String overflowText;
  final double fontSize;
  final double paddingHorizontal;
  final double paddingVertical;
  final double radius;

  const CustomBadge({
    super.key,
    required this.badgeCount,
    this.backgroundColor,
    this.textColor = Colors.white,
    this.overflowText = '99+',
    this.fontSize = 10,
    this.paddingHorizontal = 6,
    this.paddingVertical = 3,  this.radius =8,
  });

  @override
  Widget build(BuildContext context) {
    if (badgeCount == null || badgeCount! <= 0) {
      return Container();
    }

    final countText = badgeCount! > 99 ? overflowText : badgeCount.toString();
    final badgeColor = Theme.of(context).colorScheme.error;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        countText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
