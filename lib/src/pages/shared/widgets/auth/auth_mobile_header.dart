import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';

import 'auth_app_logo.dart';

class AuthMobileHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthMobileHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        32.height,
        AuthAppLogo(
          size: 70,
          padding: 20,
          color: colorScheme.onSecondary,
          backgroundColor: colorScheme.onSecondary.withValues(alpha: 0.15),
          showGlow: true,
          glowColor: colorScheme.onSecondary.withValues(alpha: 0.1),
        ),
        20.height,
        Text(
          title,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSecondary,
          ),
        ),
        8.height,
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: colorScheme.onSecondary.withValues(alpha: 0.8),
          ),
        ),
        28.height,
      ],
    );
  }
}
