import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/Empty_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/bottom_sheet.dart';
import 'package:taav_store/src/infrastructure/widgets/custom_app_bar.dart';
import 'package:taav_store/src/infrastructure/widgets/error_view.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/pages/shared/models/order_model.dart';

import '../../controllers/order_history_controller.dart';
import 'order_detail_content.dart';
import 'order_history_loading.dart';
import 'selectable_order_card.dart';

class MobileOrderHistoryLayout extends GetView<OrderHistoryController> {
  const MobileOrderHistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TKeys.orderHistory.tr),
      body: Obx(() {
        if (controller.orderState.value == CurrentState.loading) {
          return const OrderHistoryLoading();
        }
        if (controller.orderState.value == CurrentState.error) {
          return const Center(child: ErrorView());
        }
        if (controller.orders.isEmpty) {
          return Center(child: EmptyWidget(title: TKeys.cartEmpty.tr));
        }

        return _MobileOrderListView(orders: controller.orders);
      }),
    );
  }
}

class _MobileOrderListView extends StatelessWidget {
  final List<OrderModel> orders;
  const _MobileOrderListView({required this.orders});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(AppSize.p16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => AppSize.p12.height,
      itemBuilder: (context, index) {
        final order = orders[index];
        return SelectableOrderCard(
          order: order,
          isSelected: false,
          onTap: () {
            BottomSheetWidget(
              isScrollControlled: true,
              //showDragHandle: true,
            ).show(
              Padding(
                padding: EdgeInsets.only(
                  left: AppSize.p16,
                  right: AppSize.p16,
                  top: AppSize.p8,
                ),
                child: SizedBox(
                  height: Get.height * 0.8,
                  child: OrderDetailContent(order: order),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
