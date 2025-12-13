import 'package:taav_store/src/commons/enums/enums.dart';
import 'package:taav_store/src/commons/services/app_info_service.dart';
import 'package:taav_store/src/commons/services/auth_service.dart';
import 'package:taav_store/src/infoStructure/routes/app_pages.dart';
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
      final userTypeString = authService.userType.value;

      final userType = userTypeFromString(userTypeString);

      if (userType != null) {
        switch (userType) {
          case UserType.seller:
            Get.offAllNamed(AppRoutes.sellerProducts);
            break;

          case UserType.buyer:
            Get.offAllNamed(AppRoutes.buyerProducts);
            break;
        }
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
