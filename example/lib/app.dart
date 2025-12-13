
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/infrastructure/languages/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/infrastructure/theme/app_theme.dart';
import 'package:taav_store/src/infrastructure/theme/theme_controller.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LocalizationController>();
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      title: LocaleKeys.appTitle.tr,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeController.themeMode,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      unknownRoute: AppPages.unknownRoute,
      translationsKeys: AppTranslation.translations,
      locale: langController.currentLocale,
      fallbackLocale: langController.fallbackLocale,
      supportedLocales: langController.supportedLocales,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}