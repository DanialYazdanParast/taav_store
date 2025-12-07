import 'package:get/get.dart';
import 'package:example/src/commons/services/network_service.dart';
import '../repository/seller_stats_repository.dart';
import '../controllers/seller_stats_controller.dart';

class SellerStatsBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ISellerStatsRepository>(
          () => SellerStatsRepository(network: Get.find<NetworkService>()),
    );

    Get.lazyPut(
          () => SellerStatsController(repo: Get.find<ISellerStatsRepository>()),
    );
  }
}