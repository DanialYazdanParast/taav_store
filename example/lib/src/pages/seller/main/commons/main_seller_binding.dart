import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/seller/account/controllers/seller_account_controller.dart';
import 'package:example/src/pages/seller/add_product/controllers/seller_add_controller.dart';
import 'package:example/src/pages/seller/add_product/repository/seller_add_repository.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/seller/products/repository/seller_products_repository.dart';
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';

class MainSellerBinding extends Bindings {
  @override
  void dependencies() {
    final network = Get.find<NetworkService>();

    Get.lazyPut<IMetadataRepository>(
      () => MetadataRepository(network: network),
      fenix: true,
    );

    Get.lazyPut<ISellerProductsRepository>(
      () => SellerProductsRepository(network: network),
      fenix: true,
    );

    Get.lazyPut<ISellerAddRepository>(
      () => SellerAddRepository(network: network),
      fenix: true,
    );

    //--------------

    Get.lazyPut<MainSellerController>(() => MainSellerController());

    Get.lazyPut<SellerProductsController>(
      () => SellerProductsController(
        productRepo: Get.find<ISellerProductsRepository>(),
        metadataRepo: Get.find<IMetadataRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SellerAddProductController>(
      () => SellerAddProductController(
        addRepo: Get.find<ISellerAddRepository>(),
        metadataRepo: Get.find<IMetadataRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SellerAccountController>(
      () => SellerAccountController(),
      fenix: true,
    );
  }
}
