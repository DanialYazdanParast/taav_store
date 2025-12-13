import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:flutter/material.dart';
import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/divider_widget.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/buyer/orders/widgets/order_details_summary_card.dart';
import 'package:taav_store/src/pages/buyer/orders/widgets/order_item_card.dart';
import 'package:get/get.dart';
import '../../../shared/models/order_model.dart';

class OrderDetailContent extends StatelessWidget {
  final OrderModel order;
  final bool isDesktop;

  const OrderDetailContent({
    super.key,
    required this.order,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeaderCard(theme),
          AppSize.p16.height,
          OrderDetailsSummaryCard(order: order),
          AppSize.p16.height,
          _buildItemsSection(theme),
          if (!isDesktop) AppSize.p32.height,
        ],
      ),
    );
  }

  Widget _buildHeaderCard(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSize.p24),
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isDesktop ? AppSize.p16 : AppSize.p8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppSize.brCircular(
                isDesktop ? AppSize.r12 : AppSize.r8,
              ),
            ),
            child: Icon(
              Icons.receipt_rounded,
              color: theme.colorScheme.primary,
              size: isDesktop ? 28 : 20,
            ),
          ),
          AppSize.p12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TKeys.orderDetails.tr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color:
                        isDesktop ? theme.colorScheme.onSurfaceVariant : null,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (!isDesktop) AppSize.p4.height,
                Text(
                  '${TKeys.orderNumber.tr} #${order.id.toString().toLocalizedDigit}',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: isDesktop ? TextAlign.start : null,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: [
          _buildItemsHeader(theme),
          AppDivider.horizontal(
            space: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
          if (isDesktop) _buildGridItems(theme) else _buildListItems(),
        ],
      ),
    );
  }

  Widget _buildItemsHeader(ThemeData theme) {
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
          Icon(
            Icons.shopping_basket_outlined,
            color: theme.colorScheme.primary,
            size: 24,
          ),
          AppSize.p12.width,
          Expanded(
            child: Text(
              TKeys.orderItems.tr,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          AppSize.p8.width,
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.p12,
              vertical: AppSize.p4,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: AppSize.brCircular(20),
            ),
            child: Text(
              order.items.length.toString().toLocalizedDigit,
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

  Widget _buildListItems() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSize.p16),
      itemCount: order.items.length,
      itemBuilder:
          (context, i) => Padding(
            padding: EdgeInsets.only(bottom: AppSize.p12),
            child: OrderItemCard(item: order.items[i], index: i + 1),
          ),
    );
  }

  Widget _buildGridItems(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(AppSize.p16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 350,
              mainAxisExtent: 130,
              crossAxisSpacing: AppSize.p16,
              mainAxisSpacing: AppSize.p16,
            ),
            itemCount: order.items.length,
            itemBuilder:
                (context, index) =>
                    OrderItemCard(item: order.items[index], index: index + 1),
          );
        },
      ),
    );
  }
}
