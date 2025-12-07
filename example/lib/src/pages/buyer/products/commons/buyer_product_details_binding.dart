
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/buyer/product_details/controllers/buyer_product_details_controller.dart';
import 'package:example/src/pages/buyer/product_details/repository/buyer_product_details_repository.dart';
import 'package:get/get.dart';

// فایل: lib/src/pages/buyer/product_details/bindings/buyer_product_details_binding.dart

class BuyerProductDetailsBinding extends Bindings {
  @override
  void dependencies() {
    final network = Get.find<NetworkService>();


    Get.lazyPut<IBuyerProductDetailsRepository>(
          () => BuyerProductDetailsRepository(network: network),
    );


    Get.lazyPut(
          () => BuyerProductDetailsController(
        detailsRepo: Get.find(),
      ),
    );
  }
}