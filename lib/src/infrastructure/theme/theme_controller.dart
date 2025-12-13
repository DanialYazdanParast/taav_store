import 'package:taav_store/src/infrastructure/constants/storage_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:taav_store/src/infrastructure/services/storage_service.dart';

class ThemeController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  static const Map<ThemeMode, String> _themeModeToString = {
    ThemeMode.dark: 'dark',
    ThemeMode.light: 'light',
    ThemeMode.system: 'system',
  };

  ThemeMode get themeMode {
    final stored = _storage.read<String>(StorageKeys.themeMode);
    return _themeModeToString.entries
        .firstWhere(
          (e) => e.value == stored,
          orElse: () => const MapEntry(ThemeMode.system, 'system'),
        )
        .key;
  }

  void changeTheme(ThemeMode mode) {
    Get.changeThemeMode(mode);
    _storage.write(StorageKeys.themeMode, _themeModeToString[mode]);
    update();
  }
}
