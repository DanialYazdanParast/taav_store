import 'package:example/src/commons/services/app_info_service.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final appVersion = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadVersion();
  }

  @override
  void onReady() {
    super.onReady();

    // Future.delayed(const Duration(seconds: 3), () {
    //   Get.offAllNamed(AppRoutes.sellerProducts);
    // });
  }

  void _loadVersion() {
    final appInfoService = Get.find<AppInfoService>();
    appVersion.value = appInfoService.version;
  }
}
