import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/widgets/button/button_widget.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginButton extends GetView<LoginController> {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          ButtonWidget(
            TKeys.login.tr,
            () {
              controller.login();
            },
            isLoading: controller.loginState.value == CurrentState.loading,
            isEnabled: true,
          ).material(),
    );
  }
}
