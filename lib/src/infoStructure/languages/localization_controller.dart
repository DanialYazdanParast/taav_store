import 'package:taav_store/src/commons/constants/storage_keys.dart';
import 'package:taav_store/src/commons/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  final fallbackLocale = const Locale('en', 'US');
  final supportedLocales = const [Locale('en', 'US'), Locale('fa', 'IR')];

  Locale get currentLocale {
    return Get.locale ?? _getSavedLocaleFromStorage() ?? fallbackLocale;
  }

  @override
  void onInit() {
    super.onInit();
    final savedLocale = _getSavedLocaleFromStorage();
    if (savedLocale != null) {
      Get.updateLocale(savedLocale);
    }
  }

  Locale? _getSavedLocaleFromStorage() {
    final savedCode = _storage.read<String>(StorageKeys.language);
    if (savedCode == null) return null;

    final parts = savedCode.split('_');
    if (parts.isEmpty) return null;

    final locale =
        parts.length == 2 ? Locale(parts[0], parts[1]) : Locale(parts[0]);

    return _isSupported(locale) ? locale : null;
  }

  Future<void> changeLocale(Locale locale) async {
    if (!_isSupported(locale)) return;

    Get.updateLocale(locale);

    final code =
        locale.countryCode != null
            ? '${locale.languageCode}_${locale.countryCode}'
            : locale.languageCode;

    _storage.write(StorageKeys.language, code);
  }

  Future<void> toggleLocale() async {
    final isFarsi = Get.locale?.languageCode == 'fa';

    final newLocale =
        isFarsi ? const Locale('en', 'US') : const Locale('fa', 'IR');

    await changeLocale(newLocale);
  }

  bool _isSupported(Locale locale) {
    return supportedLocales.any(
      (l) =>
          l.languageCode == locale.languageCode &&
          l.countryCode == locale.countryCode,
    );
  }
}
