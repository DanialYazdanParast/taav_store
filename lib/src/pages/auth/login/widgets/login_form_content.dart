import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/utils/input/validation_util.dart';
import 'package:taav_store/src/infrastructure/widgets/text/app_password_text_field.dart';
import 'package:taav_store/src/infrastructure/widgets/text/app_text_field.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_input_label.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';
import 'login_button.dart';
import 'remember_me_row.dart';

class LoginFormContent extends GetView<LoginController> {
  final bool isMobile;

  const LoginFormContent({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.fkLogin,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthInputLabel(
              text: TKeys.username.tr,
              icon: Icons.person_outline_rounded,
            ),
            (isMobile ? 12 : 8).height,
            AppTextField(
              controller: controller.usernameController,
              focusNode: controller.usernameFocus,
              labelText: TKeys.username.tr,
              hintText: TKeys.enterUsername.tr,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(controller.passwordFocus);
              },
              autoValidateMode: controller.avmLogin.value,
              validator: ValidationUtil().username,
            ),
            (isMobile ? 20 : 24).height,
            AuthInputLabel(
              text: TKeys.password.tr,
              icon: Icons.lock_outline_rounded,
            ),
            (isMobile ? 12 : 8).height,
            AppPasswordTextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocus,
              hintText: TKeys.enterPassword.tr,
              labelText: TKeys.password.tr,
              showCriteria: false,
              validator: ValidationUtil().loginPassword,
              autoValidateMode: controller.avmLogin.value,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            (isMobile ? 16 : 20).height,
            RememberMeRow(),
            (isMobile ? 28 : 32).height,
            LoginButton(),
          ],
        ),
      ),
    );
  }
}
