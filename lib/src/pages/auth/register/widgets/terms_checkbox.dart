import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/app_checkbox.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
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
                  TextSpan(text: TKeys.acceptTermsText.tr),
                  TextSpan(
                    text: TKeys.termsAndConditions.tr,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                    recognizer:
                        TapGestureRecognizer()..onTap = onTermsTap ?? () {},
                  ),
                  TextSpan(text: TKeys.acceptTermsSuffix.tr),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
