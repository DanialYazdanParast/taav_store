import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_form_card.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_link_text.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_mobile_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import 'login_form_content.dart';

class MobileLoginLayout extends GetView<LoginController> {
  const MobileLoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

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
          stops: const [0.0, 0.12, 0.45, 1.0],
        ),
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          AuthMobileHeader(
                            title: TKeys.welcome.tr,
                            subtitle: TKeys.loginToContinue.tr,
                          ),
                          AuthFormCard(
                            variant: AuthFormVariant.mobile,
                            child: LoginFormContent(isMobile: true),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32, top: 24),
                        child: AuthLinkText(
                          prefixText: TKeys.noAccount.tr,
                          linkText: TKeys.signUp.tr,
                          onTap: () => Get.offNamed(AppRoutes.register),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
