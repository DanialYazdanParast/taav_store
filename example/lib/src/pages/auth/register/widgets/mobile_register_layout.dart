import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/pages/auth/register/widgets/register_form_content.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_form_card.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_link_text.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_mobile_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class MobileRegisterLayout extends GetView<RegisterController> {
  const MobileRegisterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.secondary,
            colorScheme.secondary.withValues(alpha: 0.8),
            colorScheme.surface,
            colorScheme.surface,
          ],
          stops: const [0.0, 0.12, 0.35, 1.0],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: size.height - MediaQuery.of(context).padding.top,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  AuthMobileHeader(
                    title: TKeys.createAccount.tr,
                    subtitle: TKeys.enterInfoToStart.tr,
                  ),

                  AuthFormCard(
                    variant: AuthFormVariant.mobile,
                    child: RegisterFormContent(isMobile: true),
                  ),

                  20.height,

                  AuthLinkText(
                    prefixText: TKeys.alreadyHaveAccount.tr,
                    linkText: TKeys.signIn.tr,
                    onTap: () => Get.offNamed(AppRoutes.login),
                  ),
                  24.height,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
