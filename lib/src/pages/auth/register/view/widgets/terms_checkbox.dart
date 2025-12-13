import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/app_checkbox.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;
  final VoidCallback? onTermsTap;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.onTermsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return GestureDetector(
      onTap: onChanged,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppCheckbox(value: value, onChanged: onChanged),
          12.width,
          Expanded(
            child: Text.rich(
              TextSpan(
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
                children: [
                  TextSpan(text: LocaleKeys.acceptTermsText.tr),
                  TextSpan(
                    text: LocaleKeys.termsAndConditions.tr,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer:
                        TapGestureRecognizer()..onTap = onTermsTap ?? () {},
                  ),
                  TextSpan(text: LocaleKeys.acceptTermsSuffix.tr),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
