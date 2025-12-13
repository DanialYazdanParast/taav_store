import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthInputLabelStyle { primary, secondary }

class AuthInputLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  final AuthInputLabelStyle style;

  const AuthInputLabel({
    super.key,
    required this.text,
    required this.icon,
    this.style = AuthInputLabelStyle.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isPrimary = style == AuthInputLabelStyle.primary;

    final color =
        isPrimary ? theme.colorScheme.primary : theme.colorScheme.secondary;

    final padding = isPrimary ? 8.0 : 6.0;
    final iconSize = isPrimary ? 18.0 : 16.0;
    final borderRadius = isPrimary ? 10.0 : 8.0;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Icon(icon, size: iconSize, color: color),
        ),
        (isPrimary ? 12 : 10).width,
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
