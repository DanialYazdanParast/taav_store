import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:get/get.dart';
import '../controllers/main_seller_controller.dart';

class MainSellerBinding extends Bindings {
  @override
  void dependencies() {
    // if (Get.isRegistered<BuyerMainController>()) {
    //   Get.delete<BuyerMainController>();
    // }

    Get.lazyPut<MainSellerController>(() => MainSellerController());
    Get.lazyPut<SellerProductsController>(() => SellerProductsController());
  }
}
