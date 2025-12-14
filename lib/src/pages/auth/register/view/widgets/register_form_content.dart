import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/utils/input/validation_util.dart';
import 'package:taav_store/src/infrastructure/widgets/text/app_password_text_field.dart';
import 'package:taav_store/src/infrastructure/widgets/text/app_text_field.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_input_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/register_controller.dart';
import 'rgister_button.dart';
import 'terms_checkbox.dart';
import 'user_type_selector.dart';

class RegisterFormContent extends GetView<RegisterController> {
  final bool isMobile;

  const RegisterFormContent({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.fkRegister,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserTypeSelector(),
            (isMobile ? 20 : 24).height,

            AuthInputLabel(
              text: LocaleKeys.username.tr,
              icon: Icons.person_outline_rounded,
              style: AuthInputLabelStyle.secondary,
            ),

            (isMobile ? 10 : 8).height,

            AppTextField(
              controller: controller.usernameController,
              focusNode: controller.usernameFocus,
              labelText: LocaleKeys.username.tr,
              hintText: LocaleKeys.chooseUsername.tr,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(controller.passwordFocus);
              },
              autoValidateMode: controller.avmRegister.value,
              validator: ValidationUtil().username,
            ),
            (isMobile ? 16 : 20).height,

            AuthInputLabel(
              text: LocaleKeys.password.tr,
              icon: Icons.lock_outline_rounded,
              style: AuthInputLabelStyle.secondary,
            ),

            (isMobile ? 10 : 8).height,

            AppPasswordTextField(
              controller: controller.passwordController,
              focusNode: controller.passwordFocus,
              hintText: LocaleKeys.minCharacters.tr,
              labelText: LocaleKeys.password.tr,
              showCriteria: true,
              validator: ValidationUtil().password,
              autoValidateMode: controller.avmRegister.value,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(
                  context,
                ).requestFocus(controller.confirmPasswordFocus);
              },
            ),

            (isMobile ? 16 : 20).height,

            AuthInputLabel(
              text: LocaleKeys.confirmPassword.tr,
              icon: Icons.lock_outline_rounded,
              style: AuthInputLabelStyle.secondary,
            ),
            (isMobile ? 10 : 8).height,
            AppPasswordTextField(
              controller: controller.confirmPasswordController,
              focusNode: controller.confirmPasswordFocus,
              hintText: LocaleKeys.repeatPassword.tr,
              labelText: LocaleKeys.password.tr,
              showCriteria: false,
              autoValidateMode: controller.avmRegister.value,
              validator:
                  (value) => ValidationUtil().passwordConfirm(
                    value,
                    controller.passwordController.text,
                  ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
            ),
            (isMobile ? 20 : 24).height,

            Obx(
              () => TermsCheckbox(
                value: controller.acceptTerms.value,
                onChanged: () => controller.acceptTerms.toggle(),
              ),
            ),
            (isMobile ? 24 : 28).height,

            RegisterButton(),
          ],
        ),
      ),
    );
  }
}
