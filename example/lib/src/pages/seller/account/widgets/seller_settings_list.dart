import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/infoStructure/languages/localization_controller.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/infoStructure/theme/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'seller_settings_dialogs.dart';
import 'seller_ui_components.dart';

class SellerSettingsList extends StatelessWidget {
  final VoidCallback onLogout;
  final bool showChevron;

  const SellerSettingsList({
    super.key,
    required this.onLogout,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locController = Get.find<LocalizationController>();
    final themeController = Get.find<ThemeController>();

    return Column(
      children: [
        SettingsMenuItem(
          icon: Icons.language,
          color: theme.colorScheme.primary,
          title: TKeys.appLanguage.tr,
          subtitle: locController.currentLocale.languageCode == 'fa' ? TKeys.farsi.tr : TKeys.english.tr,
          showChevron: showChevron,
          onTap: () => SellerSettingsDialogs.showLanguage(locController),
        ),
        AppSize.p10.height,
        SettingsMenuItem(
          icon: Icons.dark_mode_outlined,
          color: theme.colorScheme.primary,
          title: TKeys.appTheme.tr,
          subtitle: Get.isDarkMode ? TKeys.darkMode.tr : TKeys.lightMode.tr,
          showChevron: showChevron,
          onTap: () => SellerSettingsDialogs.showTheme(themeController),
        ),
        AppSize.p10.height,
        SettingsMenuItem(
          icon: Icons.logout_rounded,
          color: Colors.redAccent,
          title: TKeys.logout.tr,
          subtitle: Responsive.isMobile ? TKeys.logoutDescMobile.tr : TKeys.logoutDescWeb.tr,
          isDestructive: true,
          showChevron: showChevron,
          onTap: () => SellerSettingsDialogs.showLogout(onLogout),
        ),
      ],
    );
  }
}