import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationController extends GetxController {
  static const _key = 'locale';

  final GetStorage _box = GetStorage();
  final fallbackLocale = const Locale('en', 'US');

  final supportedLocales = const [Locale('en', 'US'), Locale('fa', 'IR')];
  Locale get currentLocale => Get.locale ?? fallbackLocale;

  @override
  void onInit() {
    super.onInit();

    final saved = _box.read<String>(_key);
    if (saved == null) return;
    final parts = saved.split('_');
    if (parts.isEmpty) return;

    final locale =
        parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);

    if (_isSupported(locale)) {
      Get.updateLocale(locale);
    }
  }

  Future<void> changeLocale(Locale locale) async {
    if (!_isSupported(locale)) return;

    Get.updateLocale(locale);
    final code =
        locale.countryCode != null
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;

    await _box.write(_key, code);
  }

  Future<void> toggleLocale() async {
    final current = Get.locale?.languageCode;
    final newLocale =
        current == 'fa' ? const Locale('en', 'US') : const Locale('fa', 'IR');
    await changeLocale(newLocale);
  }

  bool _isSupported(Locale locale) {
    return supportedLocales.any(
      (l) =>
          l.languageCode == locale.languageCode &&
          (l.countryCode == locale.countryCode),
    );
  }
}
