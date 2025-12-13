import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/bottom_sheet.dart';
import 'package:example/src/commons/widgets/custom_app_bar.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/orders/controllers/order_history_controller.dart';
import 'package:example/src/pages/buyer/orders/widgets/order_detail_content.dart';
import 'package:example/src/pages/buyer/orders/widgets/order_history_loading.dart';
import 'package:example/src/pages/buyer/orders/widgets/selectable_order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/models/order_model.dart';

class MobileOrderHistoryLayout extends GetView<OrderHistoryController> {
  const MobileOrderHistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TKeys.orderHistory.tr, ),
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
                    height: Get.height *0.8,
                    child: OrderDetailContent(order: order)),
              ),
            );
          },
        );
      },
    );
  }
}