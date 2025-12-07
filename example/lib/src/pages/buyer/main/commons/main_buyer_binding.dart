import 'package:example/src/pages/buyer/cart/repository/cart_repository.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/services/metadata_service.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';
import 'package:example/src/pages/buyer/products/controllers/buyer_products_controller.dart';
import 'package:example/src/pages/buyer/products/repository/buyer_products_repository.dart';
import 'package:example/src/pages/buyer/account/controllers/buyer_account_controller.dart';

import '../controllers/main_buyer_controller.dart';

import '../../cart/controllers/cart_controller.dart';

class MainBuyerBinding extends Bindings {
  @override
  void dependencies() {
    final network = Get.find<NetworkService>();

    // ─── 1. Repositories ───

    Get.lazyPut<IMetadataRepository>(
      () => MetadataRepository(network: network),
      fenix: true,
    );

    Get.lazyPut<IBuyerProductsRepository>(
      () => BuyerProductsRepository(network: network),
      fenix: true,
    );

    Get.lazyPut<ICartRepository>(
      () => CartRepository(network: network),
      fenix: true,
    );

    // ───  Services ───

    if (!Get.isRegistered<MetadataService>()) {
      Get.put(
        MetadataService(repository: Get.find<IMetadataRepository>()),
        permanent: true,
      );
    }

    // ───  Controllers ───

    Get.put<CartController>(
      CartController(repo: Get.find<ICartRepository>()),
      permanent: true,
    );

    Get.lazyPut<MainBuyerController>(() => MainBuyerController());

    Get.lazyPut<BuyerProductsController>(
      () => BuyerProductsController(
        productRepo: Get.find<IBuyerProductsRepository>(),
      ),
      fenix: true,
    );

    Get.lazyPut<BuyerAccountController>(
      () => BuyerAccountController(),
      fenix: true,
    );
  }
}
