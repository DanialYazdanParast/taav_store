import 'package:get/get.dart';
import 'package:taav_store/src/commons/enums/enums.dart';
import 'package:taav_store/src/commons/services/auth_service.dart';
import '../repository/seller_stats_repository.dart';
import '../models/seller_sales_stat_model.dart';

class SellerStatsController extends GetxController {
  final ISellerStatsRepository _statsRepo;
  final AuthService _authService = Get.find<AuthService>();

  SellerStatsController({required ISellerStatsRepository repo})
    : _statsRepo = repo;

  final RxList<SellerSalesStatModel> salesStats = <SellerSalesStatModel>[].obs;
  final Rx<CurrentState> pageState = CurrentState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    pageState.value = CurrentState.loading;
    final sellerId = _authService.userId.value;

    final result = await _statsRepo.getBestSellers(sellerId);

    result.fold(
      (failure) {
        pageState.value = CurrentState.error;
      },
      (data) {
        salesStats.assignAll(data);

        pageState.value = CurrentState.success;
      },
    );
  }
}
