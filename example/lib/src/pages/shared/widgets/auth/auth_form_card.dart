import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AuthFormVariant { mobile, desktop }

class AuthFormCard extends StatelessWidget {
  final AuthFormVariant variant;
  final Widget child;

  const AuthFormCard({super.key, required this.variant, required this.child});

  bool get _isMobile => variant == AuthFormVariant.mobile;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_isMobile ? 24 : 32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,

        borderRadius: BorderRadius.circular(_isMobile ? 28 : 24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(
              alpha: _isMobile ? 0.1 : 0.08,
            ),
            blurRadius: _isMobile ? 20 : 24,
            offset: Offset(0, _isMobile ? 10 : 8),
          ),
        ],
      ),
      child: child,
    );
  }
}
