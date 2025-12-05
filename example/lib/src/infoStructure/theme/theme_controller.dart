import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:example/src/commons/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  static const String _storageKey = 'theme_mode';

  static const Map<ThemeMode, String> _themeModeToString = {
    ThemeMode.dark: 'dark',
    ThemeMode.light: 'light',
    ThemeMode.system: 'system',
  };

  ThemeMode get themeMode {
    final stored = _storage.read<String>(_storageKey);
    return _themeModeToString.entries
        .firstWhere(
          (e) => e.value == stored,
      orElse: () => const MapEntry(ThemeMode.system, 'system'),
    )
        .key;
  }

  void changeTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
    _storage.write(_storageKey, _themeModeToString[mode]);
    update();
  }
}