import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/app_loading.dart';
import 'package:example/src/commons/widgets/custom_app_bar.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_history_controller.dart';
import '../widgets/order_card_widget.dart';

class MobileOrderHistoryLayout extends GetView<OrderHistoryController> {
  const MobileOrderHistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TKeys.orderHistory.tr),
      body: Obx(() {
        if (controller.orderState.value == CurrentState.loading) {
          return Center(child: AppLoading.circular(size: 50));
        }

        if (controller.orderState.value == CurrentState.loading) {
          return EmptyWidget(title: TKeys.errorLoadingData.tr);
        }

        if (controller.orders.isEmpty) {
          return Center(child: ErrorView());
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadOrders(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return OrderCardWidget(
                order: controller.orders[index],
                isMobile: true,
              );
            },
          ),
        );
      }),
    );
  }
}
