import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/enums/enums.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/Empty_widget.dart';
import 'package:taav_store/src/commons/widgets/error_view.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/buyer/orders/controllers/order_history_controller.dart';
import 'package:taav_store/src/pages/buyer/orders/widgets/order_detail_content.dart';
import 'package:taav_store/src/pages/buyer/orders/widgets/order_history_loading.dart';
import 'package:taav_store/src/pages/buyer/orders/widgets/order_list_panel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/models/order_model.dart';

class DesktopOrderHistoryLayout extends GetView<OrderHistoryController> {
  const DesktopOrderHistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

        return _DesktopMasterDetailView(orders: controller.orders);
      }),
    );
  }
}

class _DesktopMasterDetailView extends StatefulWidget {
  final List<OrderModel> orders;
  const _DesktopMasterDetailView({required this.orders});

  @override
  State<_DesktopMasterDetailView> createState() =>
      _DesktopMasterDetailViewState();
}

class _DesktopMasterDetailViewState extends State<_DesktopMasterDetailView> {
  late OrderModel selectedOrder;

  @override
  void initState() {
    super.initState();
    selectedOrder = widget.orders.first;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppSize.p16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 380,
            child: OrderListPanel(
              orders: widget.orders,
              selectedOrder: selectedOrder,
              onOrderSelected: (order) => setState(() => selectedOrder = order),
            ),
          ),
          AppSize.p24.width,
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: OrderDetailContent(
                key: ValueKey(selectedOrder.id),
                order: selectedOrder,
                isDesktop: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
