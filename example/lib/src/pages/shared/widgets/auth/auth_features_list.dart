import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthFeaturesList extends StatelessWidget {
  const AuthFeaturesList({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      (Icons.speed_rounded, TKeys.highSpeed.tr),
      (Icons.security_rounded, TKeys.fullSecurity.tr),
      (Icons.support_agent_rounded, TKeys.support247.tr),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          features
              .map((f) => AuthFeatureItem(icon: f.$1, label: f.$2))
              .toList(),
    );
  }
}

class AuthFeatureItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const AuthFeatureItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.onSecondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: colorScheme.onSecondary, size: 28),
          ),
          12.height,
          Text(
            label,
            style: TextStyle(
              color: colorScheme.onSecondary.withValues(alpha: 0.9),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
