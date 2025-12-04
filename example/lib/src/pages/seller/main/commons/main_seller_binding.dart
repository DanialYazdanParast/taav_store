import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/seller/products/repository/seller_products_repository.dart';
import 'package:get/get.dart';
import '../controllers/main_seller_controller.dart';

class MainSellerBinding extends Bindings {
  @override
  void dependencies() {
    // if (Get.isRegistered<BuyerMainController>()) {
    //   Get.delete<BuyerMainController>();
    // }

    Get.lazyPut<MainSellerController>(() => MainSellerController());

    Get.lazyPut<ISellerProductsRepository>(
          () => SellerProductsRepository(network: Get.find<NetworkService>()),
    );



    Get.lazyPut<SellerProductsController>(() => SellerProductsController(repository: Get.find<ISellerProductsRepository>()));
  }
}
