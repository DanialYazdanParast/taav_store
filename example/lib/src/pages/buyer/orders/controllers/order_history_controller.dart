import 'package:get/get.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/services/auth_service.dart';
import 'package:example/src/commons/utils/toast_util.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart'; // Import added
import '../../../shared/models/order_model.dart';
import '../repository/order_repository.dart';

class OrderHistoryController extends GetxController {
  final IOrderRepository _repo;
  final AuthService _authService = Get.find<AuthService>();

  OrderHistoryController({required IOrderRepository repo}) : _repo = repo;

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<CurrentState> orderState = CurrentState.idle.obs;

  String get currentUserId => _authService.userId.value;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    orderState.value = CurrentState.loading;

    final result = await _repo.getOrders(currentUserId);

    result.fold(
          (failure) {
        orderState.value = CurrentState.error;
        ToastUtil.show(
            TKeys.fetchOrdersError.tr,
            type: ToastType.error
        );
      },
          (fetchedOrders) {
        fetchedOrders.sort((a, b) => b.date.compareTo(a.date));
        orders.assignAll(fetchedOrders);

        orderState.value = CurrentState.success;

      },
    );
  }

}