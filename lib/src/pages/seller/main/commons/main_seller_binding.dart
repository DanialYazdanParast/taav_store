import 'package:taav_store/src/infrastructure/services/metadata_service.dart';
import 'package:taav_store/src/infrastructure/network/network_service.dart';
import 'package:taav_store/src/pages/seller/account/controllers/seller_account_controller.dart';
import 'package:taav_store/src/pages/seller/add_product/controllers/seller_add_controller.dart';
import 'package:taav_store/src/pages/seller/add_product/repository/seller_add_repository.dart';
import 'package:taav_store/src/pages/seller/edit_product/controllers/seller_edit_controller.dart';
import 'package:taav_store/src/pages/seller/edit_product/repository/seller_edit_repository.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:taav_store/src/pages/seller/products/repository/seller_products_repository.dart';
import 'package:taav_store/src/pages/shared/repositories/metadata_repository.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';

import 'package:taav_store/src/pages/seller/stats/repository/seller_stats_repository.dart';

class MainSellerBinding extends Bindings {
  @override
  void dependencies() {
    final network = Get.find<NetworkService>();

    // Repositories
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
    Get.lazyPut<ISellerEditRepository>(
      () => SellerEditRepository(network: network),
      fenix: true,
    );
    Get.lazyPut<ISellerStatsRepository>(
      () => SellerStatsRepository(network: network),
      fenix: true,
    );

    Get.put(
      MetadataService(repository: Get.find<IMetadataRepository>()),
      permanent: true,
    );

    Get.lazyPut<MainSellerController>(() => MainSellerController());

    Get.put<SellerProductsController>(
      SellerProductsController(
        productRepo: Get.find<ISellerProductsRepository>(),
        statsRepo: Get.find<ISellerStatsRepository>(),
      ),
      permanent: true,
    );

    Get.put<SellerAddProductController>(
      SellerAddProductController(addRepo: Get.find<ISellerAddRepository>()),
      permanent: true,
    );

    Get.lazyPut<SellerAccountController>(
      () => SellerAccountController(),
      fenix: true,
    );

    Get.lazyPut<SellerEditController>(
      () => SellerEditController(editRepo: Get.find<ISellerEditRepository>()),
    );
  }
}
