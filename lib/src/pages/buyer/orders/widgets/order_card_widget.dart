import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/widgets/network_image.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              "${TKeys.order.tr} #${order.id.toString().toLocalizedDigit}",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const Spacer(),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                order.totalPrice.toLocalizedPrice,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                TKeys.toman.tr,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                  fontSize: 10,
                ),
              ),
            ],
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
            children: [_buildItemsList(order, theme)],
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
