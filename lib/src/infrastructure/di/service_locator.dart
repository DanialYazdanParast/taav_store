import 'package:get/get.dart';

import 'package:taav_store/src/infrastructure/services/app_info_service.dart';
import 'package:taav_store/src/infrastructure/services/auth_service.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/src/infrastructure/services/storage_service.dart';
import 'package:taav_store/src/infrastructure/languages/localization_controller.dart';
import 'package:taav_store/src/infrastructure/theme/theme_controller.dart';

Future<void> setupLocator() async {
  await Get.putAsync(() => StorageService().init());

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => AppInfoService().init());

  Get.put(LocalizationController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  Get.put(NetworkService(), permanent: true);
}
