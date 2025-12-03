import 'package:get/get.dart';
import '../controllers/main_seller_controller.dart';

class MainSellerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainSellerController>(() => MainSellerController());
  }
}
