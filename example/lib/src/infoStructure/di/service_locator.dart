import 'package:example/src/commons/services/app_info_service.dart';
import 'package:example/src/commons/services/storage_service.dart';
import 'package:example/src/infoStructure/languages/localization_controller.dart';
import 'package:get/get.dart';

// 1. تغییر void به Future<void>
Future<void> setupLocator() async {
  await Get.putAsync(() => StorageService().init());
  Get.put(LocalizationController(), permanent: true);
  await Get.putAsync(() => AppInfoService().init());
}
