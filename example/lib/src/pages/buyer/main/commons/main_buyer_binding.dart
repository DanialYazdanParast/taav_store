import 'package:example/src/commons/services/metadata_service.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/buyer/account/controllers/buyer_account_controller.dart';
import 'package:example/src/pages/buyer/products/controllers/buyer_products_controller.dart';
import 'package:example/src/pages/buyer/products/repository/buyer_products_repository.dart'; // 💡 مخزن خریدار
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';

class MainBuyerBinding extends Bindings {
  @override
  void dependencies() {
    final network = Get.find<NetworkService>();

    Get.lazyPut<IMetadataRepository>(
      () => MetadataRepository(network: network),
      fenix: true,
    );

    Get.lazyPut<IBuyerProductsRepository>(
      () => BuyerProductsRepository(network: network),
      fenix: true,
    );

    if (!Get.isRegistered<MetadataService>()) {
      Get.put(
        MetadataService(repository: Get.find<IMetadataRepository>()),
        permanent: true,
      );
    }

    // ───────────────────────────────────

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
