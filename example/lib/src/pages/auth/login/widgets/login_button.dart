import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controllr.dart';

class LoginButton extends GetView<LoginControllr> {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ButtonWidget(
      TKeys.login.tr,
      () {
        // controller.login();
      },
      isLoading: false,
      isEnabled: true,
    ).material();
  }
}
