// lib/core/localization/localization_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalizationController extends GetxController {
  static const _storageKey = 'locale'; // مثلا: en_US یا fa_IR

  final GetStorage _box = GetStorage();

  /// زبان پیش‌فرض اگر چیزی در استوریج نباشه
  final Locale fallbackLocale = const Locale('en', 'US');

  /// زبان‌های پشتیبانی‌شده
  final List<Locale> supportedLocales = const [
    Locale('en', 'US'),
    Locale('fa', 'IR'),
  ];

  /// گرفتن Locale فعلی از GetX
  Locale get currentLocale => Get.locale ?? fallbackLocale;

  @override
  void onInit() {
    super.onInit();

    // زبان ذخیره‌شده رو لود کن
    final String? saved = _box.read<String>(_storageKey);

    if (saved != null) {
      final parts = saved.split('_'); // مثل "fa_IR"
      if (parts.isNotEmpty) {
        final locale = Locale(
          parts[0],
          parts.length > 1 && parts[1].isNotEmpty ? parts[1] : '',
        );
        Get.updateLocale(locale);
      }
    }
  }

  /// تغییر زبان به Locale مشخص
  Future<void> changeLocale(Locale locale) async {
    if (!_isSupported(locale)) return;

    Get.updateLocale(locale);
    final code =
        '${locale.languageCode}_${locale.countryCode ?? ''}'; // مثال: fa_IR
    await _box.write(_storageKey, code);
  }

  /// سوییچ بین fa و en برای راحتی
  Future<void> toggleLocale() async {
    final isFa = (Get.locale?.languageCode ?? 'en') == 'fa';

    final newLocale =
        isFa ? const Locale('en', 'US') : const Locale('fa', 'IR');
    await changeLocale(newLocale);
  }

  bool _isSupported(Locale locale) {
    return supportedLocales.any(
      (l) =>
          l.languageCode == locale.languageCode &&
          (l.countryCode == null || l.countryCode == locale.countryCode),
    );
  }
}
