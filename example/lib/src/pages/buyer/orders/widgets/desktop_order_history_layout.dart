import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/widgets/custom_app_bar.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/orders/controllers/order_history_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../widgets/order_card_widget.dart';
import '../../../shared/models/order_model.dart';

class DesktopOrderHistoryLayout extends GetView<OrderHistoryController> {
  const DesktopOrderHistoryLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Rxn<OrderModel> selectedOrder = Rxn<OrderModel>();

    return Scaffold(
      appBar: CustomAppBar(title: TKeys.orderHistory.tr),
      body: Obx(() {
        if (controller.pageState.value != CurrentState.success) {
          return const Center(child: CircularProgressIndicator());
        }

        if (selectedOrder.value == null && controller.orders.isNotEmpty) {
          selectedOrder.value = controller.orders.first;
        }

        return Row(
          children: [
            SizedBox(
              width: 350,
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  return Obx(
                        () => OrderCardWidget(
                      order: order,
                      isMobile: false,
                      isSelected: selectedOrder.value?.id == order.id,
                      onTap: () => selectedOrder.value = order,
                    ),
                  );
                },
              ),
            ),

            const VerticalDivider(width: 1),

            Expanded(
              child: Obx(() {
                final order = selectedOrder.value;
                if (order == null) return const SizedBox.shrink();

                return _buildOrderDetailsView(order, theme);
              }),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildOrderDetailsView(OrderModel order, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${TKeys.orderDetails.tr} #${order.id.toString().toLocalizedDigit}",
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                mainAxisExtent: 100,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: order.items.length,
              itemBuilder: (context, index) {
                final item = order.items[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      TaavNetworkImage(
                        item.image,
                        width: 70,
                        height: 70,
                        borderRadius: 8,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              item.productTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${item.quantity.toString().toLocalizedDigit} ${TKeys.unit.tr} × ${item.price.toLocalizedPrice}",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}