import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/infoStructure/languages/localization_controller.dart';
import 'src/infoStructure/routes/app_pages.dart';
import 'src/infoStructure/theme/app_theme.dart';
import 'src/infoStructure/languages/app_translations.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LocalizationController>();

    return GetMaterialApp(
      title: 'Taav Store',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      translations: AppTranslations(),
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
