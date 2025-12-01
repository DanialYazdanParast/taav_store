import 'package:example/src/commons/services/app_info_service.dart';
import 'package:example/src/infoStructure/languages/localization_controller.dart';
import 'package:get/get.dart';

// 1. تغییر void به Future<void>
Future<void> setupLocator() async {
  print('Starting Dependency Injection...');

  // کنترلر زبان معمولاً نیاز به async ندارد و همین عالی است
  // permanent: true یعنی اگر کاربر لاگ‌اوت کرد یا Get.reset شد، این کنترلر نمیرد
  Get.put(LocalizationController(), permanent: true);

  // 2. تغییر مهم: استفاده از putAsync برای AppInfoService
  // چون باید صبر کنیم تا فایل pubspec خوانده شود و متغیرها پر شوند
  await Get.putAsync(() => AppInfoService().init());

  print('All Services Started.');
}
