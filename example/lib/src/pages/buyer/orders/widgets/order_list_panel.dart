import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/orders/widgets/selectable_order_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/models/order_model.dart';

class OrderListPanel extends StatelessWidget {
  final List<OrderModel> orders;
  final OrderModel? selectedOrder;
  final ValueChanged<OrderModel> onOrderSelected;

  const OrderListPanel({
    super.key,
    required this.orders,
    this.selectedOrder,
    required this.onOrderSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _buildHeader(theme),
          AppDivider.horizontal(space: 1, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(AppSize.p16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => AppSize.p12.height,
              itemBuilder: (context, index) {
                final order = orders[index];
                final isSelected = selectedOrder?.id == order.id;
                return SelectableOrderCard(
                  order: order,
                  isSelected: isSelected,
                  onTap: () => onOrderSelected(order),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSize.p24),
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppSize.r16),
          topRight: Radius.circular(AppSize.r16),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.receipt_long_outlined, color: theme.colorScheme.primary, size: 24),
          AppSize.p12.width,
          Expanded(
            child: Text(
              TKeys.orderHistory.tr,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSize.p8.width,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppSize.brCircular(20),
            ),
            child: Text(
              orders.length.toString().toLocalizedDigit,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}