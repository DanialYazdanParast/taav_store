import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';

class MainBuyerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainBuyerController>(() => MainBuyerController());
  }
}