import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_branding_panel.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_form_card.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_link_text.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'register_form_content.dart';

class DesktopRegisterLayout extends StatelessWidget {
  const DesktopRegisterLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Expanded(
          flex: 5,
          child: AuthBrandingPanel(
            title: TKeys.joinUs.tr,
            subtitle: TKeys.thousandsUsersTrust.tr,
          ),
        ),
        Expanded(
          flex: 4,
          child: Container(
            color: theme.colorScheme.surface,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(48),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        TKeys.signUpEmoji.tr,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.height,
                      Text(
                        TKeys.createNewAccount.tr,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      36.height,
                      AuthFormCard(
                        variant: AuthFormVariant.desktop,
                        child: RegisterFormContent(isMobile: false),
                      ),
                      28.height,
                      AuthLinkText(
                        prefixText: TKeys.alreadyHaveAccount.tr,
                        linkText: TKeys.signIn.tr,
                        onTap: () => Get.offNamed(AppRoutes.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
