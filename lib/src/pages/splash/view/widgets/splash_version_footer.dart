import 'package:taav_store/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/splash_controller.dart';

class SplashVersionFooter extends GetView<SplashController> {
  const SplashVersionFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Text(
        controller.appVersion.value.isEmpty
            ? ''
            : '${LocaleKeys.version.tr} ${controller.appVersion.value}',
        style: context.theme.textTheme.bodySmall,
      ),
    );
  }
}
