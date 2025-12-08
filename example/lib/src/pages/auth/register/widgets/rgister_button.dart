import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class RegisterButton extends GetView<RegisterController> {
  const RegisterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          ButtonWidget(
            TKeys.createAccount.tr,
            () {
              controller.register();
            },
            isLoading: controller.registerState.value == CurrentState.loading,
          ).material(),
    );
  }
}
