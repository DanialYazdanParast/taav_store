import 'package:example/src/pages/buyer/account/controllers/buyer_account_controller.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';

class MainBuyerBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<MainBuyerController>(() => MainBuyerController());
    Get.lazyPut<BuyerAccountController>(
          () => BuyerAccountController(),
      fenix: true,
    );
  }
}