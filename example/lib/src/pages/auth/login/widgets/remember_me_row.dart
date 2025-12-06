import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/app_checkbox.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class RememberMeRow extends GetView<LoginController> {
  const RememberMeRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Obx(
      () => GestureDetector(
        onTap: () => controller.rememberMe.toggle(),
        child: Row(
          children: [
            AppCheckbox(
              value: controller.rememberMe.value,
              onChanged: () => controller.rememberMe.toggle(),
            ),
            10.width,
            Text(
              TKeys.rememberMe.tr,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
