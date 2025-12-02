import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_app_logo.dart';
import 'auth_decorative_circle.dart';
import 'auth_features_list.dart';

class AuthBrandingPanel extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthBrandingPanel({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            colorScheme.secondary,
            colorScheme.secondary.withValues(alpha: 0.85),
            colorScheme.primary.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Stack(
        children: [
          AuthDecorativeCircle(
            top: -100,
            right: -100,
            size: 300,
            color: colorScheme.onPrimary.withValues(alpha: 0.05),
          ),
          AuthDecorativeCircle(
            bottom: -50,
            left: -50,
            size: 200,
            color: colorScheme.onPrimary.withValues(alpha: 0.08),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AuthAppLogo(
                    size: 110,
                    padding: 28,
                    color: colorScheme.onSecondary,
                    backgroundColor: colorScheme.onSecondary.withValues(
                      alpha: 0.1,
                    ),
                    showGlow: true,
                    glowColor: colorScheme.onSecondary.withValues(alpha: 0.2),
                    animated: true,
                  ),
                  48.height,
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  16.height,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16,
                      color: colorScheme.onSecondary.withValues(alpha: 0.85),
                    ),
                  ),
                  56.height,
                  const AuthFeaturesList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
