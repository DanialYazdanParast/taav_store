import 'package:get/get.dart';

import 'package:example/src/commons/services/app_info_service.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/commons/services/storage_service.dart';
import 'package:example/src/infoStructure/languages/localization_controller.dart';
import 'package:example/src/infoStructure/theme/theme_controller.dart';

Future<void> setupLocator() async {
  await Get.putAsync(() => StorageService().init());

  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => AppInfoService().init());

  Get.put(LocalizationController(), permanent: true);
  Get.put(ThemeController(), permanent: true);

  Get.put(NetworkService(), permanent: true);
}
