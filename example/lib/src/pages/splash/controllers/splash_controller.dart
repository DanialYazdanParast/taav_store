import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.sellerProducts);
    });
  }
}
