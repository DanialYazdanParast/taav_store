import 'package:example/src/commons/services/app_info_service.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
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
    Future.delayed(const Duration(seconds: 3), _handleNavigation);
  }

  void _loadVersion() {
    final appInfoService = Get.find<AppInfoService>();
    appVersion.value = appInfoService.version;
  }

  void _handleNavigation() {
    final authService = Get.find<AuthService>();

    if (authService.rememberMe.value && authService.userId.value.isNotEmpty) {
      final type = authService.userType.value.toLowerCase();

      if (type == 'seller') {
        Get.offAllNamed(AppRoutes.mainSeller);
      } else if (type == 'buyer') {
      //  Get.offAllNamed(AppRoutes.buyerHome);
      } else {
        Get.offAllNamed(AppRoutes.mainSeller);
       // Get.offAllNamed(AppRoutes.login);
      }

    } else {
      Get.offAllNamed(AppRoutes.mainSeller);
     // Get.offAllNamed(AppRoutes.login);
    }
  }
}
