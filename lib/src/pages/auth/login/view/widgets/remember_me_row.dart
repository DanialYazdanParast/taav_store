import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/app_checkbox.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';

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
              LocaleKeys.rememberMe.tr,
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
