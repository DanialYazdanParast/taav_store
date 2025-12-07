import 'package:get/get.dart';
import 'package:example/src/commons/services/network_service.dart';
import 'package:example/src/pages/shared/repositories/metadata_repository.dart';
import '../controllers/seller_edit_controller.dart';
import '../repository/seller_edit_repository.dart';

class SellerEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ISellerEditRepository>(
      () => SellerEditRepository(network: Get.find<NetworkService>()),
    );

    Get.lazyPut<SellerEditController>(
      () => SellerEditController(
        editRepo: Get.find<ISellerEditRepository>(),
      ),
    );
  }
}
