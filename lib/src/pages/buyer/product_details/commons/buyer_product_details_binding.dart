// import 'package:get/get.dart';
// import 'package:taav_store/src/infrastructure/services/network_service.dart';
// import 'package:taav_store/src/pages/buyer/product_details/controllers/buyer_product_details_controller.dart';
// import 'package:taav_store/src/pages/buyer/product_details/repository/buyer_product_details_repository.dart';
//
// class BuyerProductDetailsBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<IBuyerProductDetailsRepository>(
//           () => BuyerProductDetailsRepository(
//         network: Get.find<NetworkService>(),
//       ),
//     );
//
//     Get.lazyPut<BuyerProductDetailsController>(
//           () => BuyerProductDetailsController(
//         detailsRepo: Get.find<IBuyerProductDetailsRepository>(),
//       ),
//     );
//   }
// }
