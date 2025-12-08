import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:flutter/material.dart';
import '../../../shared/models/order_model.dart';

class OrderCardWidget extends StatelessWidget {
  final OrderModel order;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isMobile;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.isSelected = false,
    this.onTap,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final decoration = BoxDecoration(
      color: theme.scaffoldBackgroundColor,

      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );

    final headerContent = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.receipt_long_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "سفارش #${order.id.toString().toLocalizedDigit}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const Spacer(),
        Text(
          "${order.totalPrice.toLocalizedPrice} تومان",
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );

    if (isMobile) {
      return Container(
        decoration: decoration,
        child: Theme(
          data: theme.copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            title: headerContent,
            children: [const Divider(), _buildItemsList(order, theme)],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: decoration,
          child: headerContent,
        ),
      );
    }
  }

  Widget _buildItemsList(OrderModel order, ThemeData theme) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: order.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = order.items[index];
        return Row(
          children: [
            TaavNetworkImage(
              item.image,
              width: 50,
              height: 50,
              borderRadius: 8,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.productTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text((item.price * item.quantity).toLocalizedPrice),
          ],
        );
      },
    );
  }
}
