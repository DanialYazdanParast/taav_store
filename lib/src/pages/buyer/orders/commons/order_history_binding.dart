import 'package:get/get.dart';
import 'package:taav_store/src/commons/services/network_service.dart';
import '../repository/order_repository.dart';
import '../controllers/order_history_controller.dart';

class OrderHistoryBinding extends Bindings {
  @override
  void dependencies() {
    // ۱. تزریق ریپازیتوری (نیاز به نتورک سرویس دارد که قبلا در مین پروژه اینجکت شده)
    Get.lazyPut<IOrderRepository>(
      () => OrderRepository(network: Get.find<NetworkService>()),
    );

    // ۲. تزریق کنترلر (نیاز به ریپازیتوری دارد)
    Get.lazyPut(
      () => OrderHistoryController(repo: Get.find<IOrderRepository>()),
    );
  }
}
