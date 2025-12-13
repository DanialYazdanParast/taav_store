import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:taav_store/src/infrastructure/languages/localization_controller.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/infrastructure/theme/theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/ui_components.dart' show MenuItem;
import 'settings_dialogs.dart';


class IconList extends StatelessWidget {
  final VoidCallback onLogout;
  final bool showChevron;

  const IconList({super.key, required this.onLogout, this.showChevron = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locController = Get.find<LocalizationController>();
    final themeController = Get.find<ThemeController>();

    return Column(
      children: [
        MenuItem(
          icon: Icons.language,
          color: theme.colorScheme.primary,
          title: TKeys.appLanguage.tr,
          subtitle:
              locController.currentLocale.languageCode == 'fa'
                  ? TKeys.farsi.tr
                  : TKeys.english.tr,
          showChevron: showChevron,
          onTap: () => SettingsDialogs.showLanguage(locController),
        ),
        AppSize.p10.height,
        MenuItem(
          icon: Icons.dark_mode_outlined,
          color: theme.colorScheme.primary,
          title: TKeys.appTheme.tr,
          subtitle: Get.isDarkMode ? TKeys.darkMode.tr : TKeys.lightMode.tr,
          showChevron: showChevron,
          onTap: () => SettingsDialogs.showTheme(themeController),
        ),
        AppSize.p10.height,
        MenuItem(
          icon: Icons.logout_rounded,
          color: Colors.redAccent,
          title: TKeys.logout.tr,
          subtitle:
              Responsive.isMobile
                  ? TKeys.logoutDescMobile.tr
                  : TKeys.logoutDescWeb.tr,
          isDestructive: true,
          showChevron: showChevron,
          onTap: () => SettingsDialogs.showLogout(onLogout),
        ),
      ],
    );
  }
}
