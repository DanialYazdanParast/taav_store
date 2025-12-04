import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';

class SellerStatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color textColor;
  final Color subColor;
  final double? valueSize;
  final double? iconSize;

  const SellerStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.textColor,
    required this.subColor,
    this.valueSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: subColor,
          size: iconSize ?? 28,
        ),
        AppSize.p10.height,
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontSize: valueSize ?? AppSize.f24,
            fontWeight: FontWeight.w900,
          ),
        ),
        AppSize.p5.height,
        Text(
          label,
          style: TextStyle(
            color: subColor,
            fontSize: AppSize.f13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}