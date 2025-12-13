import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/auth/login/widgets/login_form_content.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_branding_panel.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_form_card.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_link_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DesktopLoginLayout extends StatelessWidget {
  const DesktopLoginLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Row(
      textDirection: TextDirection.ltr,
      children: [
        Expanded(
          flex: 5,
          child: AuthBrandingPanel(
            title: TKeys.welcomeToApp.tr,
            subtitle: TKeys.smartBusinessManagement.tr,
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
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        TKeys.helloEmoji.tr,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      8.height,
                      Text(
                        TKeys.loginToAccount.tr,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      40.height,
                      AuthFormCard(
                        variant: AuthFormVariant.desktop,
                        child: LoginFormContent(isMobile: false),
                      ),
                      32.height,
                      AuthLinkText(
                        prefixText: TKeys.noAccount.tr,
                        linkText: TKeys.signUp.tr,
                        onTap: () => Get.offNamed(AppRoutes.register),
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
