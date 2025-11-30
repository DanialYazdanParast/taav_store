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
    // 1. تزریق کنترلر زبان (همینجا Put می‌کنیم تا زبان ذخیره شده رو لود کنه)
    final langController = Get.put(LocalizationController());

    return GetMaterialApp(
      title: 'Taav Store',
      debugShowCheckedModeBanner: false,

      // --- تم‌ها ---
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      // --- روتینگ ---
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,

      // --- تنظیمات زبان (اصلاح شده) ---
      translations: AppTranslations(),

      // 2. استفاده از زبان ذخیره شده در کنترلر (بجای Get.locale خالی)
      locale: langController.currentLocale,

      // 3. زبان زاپاس (اگر زبان گوشی کاربر پشتیبانی نمیشد)
      fallbackLocale: const Locale('en', 'US'),

      // 4. لیست زبان‌های پشتیبانی شده (برای راست‌چین شدن صحیح فلاتر)
      supportedLocales: langController.supportedLocales,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
