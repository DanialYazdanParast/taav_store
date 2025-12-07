// فایل: src/pages/buyer/orders/controllers/order_history_controller.dart

import 'package:get/get.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/utils/toast_util.dart';
import '../../../shared/models/order_model.dart';
import '../repository/order_repository.dart';

class OrderHistoryController extends GetxController {
  final IOrderRepository _repo;
  final AuthService _authService = Get.find<AuthService>();

  OrderHistoryController({required IOrderRepository repo}) : _repo = repo;

  // متغیرهای Rx
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<CurrentState> pageState = CurrentState.idle.obs;

  String get currentUserId => _authService.userId.value;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    pageState.value = CurrentState.loading;

    final result = await _repo.getOrders(currentUserId);

    result.fold(
          (failure) {
        pageState.value = CurrentState.error;
        ToastUtil.show(
            "خطا در دریافت لیست سفارشات",
            type: ToastType.error
        );
      },
          (fetchedOrders) {
        fetchedOrders.sort((a, b) => b.date.compareTo(a.date));
        orders.assignAll(fetchedOrders);

          pageState.value = CurrentState.success;

      },
    );
  }

}