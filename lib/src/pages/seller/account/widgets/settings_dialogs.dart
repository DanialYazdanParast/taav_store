import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/bottom_sheet.dart';
import 'package:taav_store/src/infrastructure/widgets/dialog_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:taav_store/src/infrastructure/languages/localization_controller.dart';
import 'package:taav_store/src/infrastructure/theme/theme_controller.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';

import '../../../shared/widgets/ui_components.dart';

class SettingsDialogs {
  SettingsDialogs._();

  static void _show(Widget content) {
    if (Responsive.isMobile) {
      BottomSheetWidget().show(
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSize.p24,
            vertical: AppSize.p12,
          ),
          child: content,
        ),
      );
    } else {
      DialogWidget(maxWidth: 400).show(content);
    }
  }

  static void showLanguage(LocalizationController controller) {
    _show(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupTitleWidget(TKeys.selectLanguage.tr),
          AppSize.p24.height,
          SelectableOptionWidget(
            title: TKeys.farsi.tr,
            isSelected: controller.currentLocale.languageCode == 'fa',
            onTap: () {
              controller.changeLocale(const Locale('fa', 'IR'));
              Get.back();
            },
          ),
          AppSize.p12.height,
          SelectableOptionWidget(
            title: TKeys.english.tr,
            isSelected: controller.currentLocale.languageCode == 'en',
            onTap: () {
              controller.changeLocale(const Locale('en', 'US'));
              Get.back();
            },
          ),
          AppSize.p32.height,
        ],
      ),
    );
  }

  static void showTheme(ThemeController controller) {
    _show(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          PopupTitleWidget(TKeys.appTheme.tr),
          AppSize.p24.height,
          ..._themeOptions.map(
            (option) => Padding(
              padding: const EdgeInsets.only(bottom: AppSize.p12),
              child: SelectableOptionWidget(
                title: (option['title'] as String).tr,
                icon: option['icon'] as IconData,
                isSelected:
                    option['mode'] == ThemeMode.system
                        ? false
                        : (option['mode'] == ThemeMode.dark) == Get.isDarkMode,
                onTap: () {
                  controller.changeTheme(option['mode'] as ThemeMode);
                  Get.back();
                },
              ),
            ),
          ),
          AppSize.p20.height,
        ],
      ),
    );
  }

  static void showLogout(VoidCallback onLogout) {
    _show(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSize.p16),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.logout_rounded,
              size: 32,
              color: Colors.red,
            ),
          ),
          AppSize.p16.height,
          PopupTitleWidget(TKeys.logout.tr),
          AppSize.p8.height,
          Text(
            TKeys.confirmLogoutMsg.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          AppSize.p32.height,
          ActionButtonsWidget(
            cancelText: TKeys.cancel.tr,
            confirmText: TKeys.yesLogout.tr,
            onConfirm: onLogout,
            confirmColor: Colors.red,
          ),
          AppSize.p24.height,
        ],
      ),
    );
  }

  static const List<Map<String, dynamic>> _themeOptions = [
    {
      'title': TKeys.themeLightTitle,
      'icon': Icons.wb_sunny_rounded,
      'mode': ThemeMode.light,
    },
    {
      'title': TKeys.themeDarkTitle,
      'icon': Icons.nightlight_round,
      'mode': ThemeMode.dark,
    },
    {
      'title': TKeys.systemMode,
      'icon': Icons.settings_brightness_rounded,
      'mode': ThemeMode.system,
    },
  ];
}
