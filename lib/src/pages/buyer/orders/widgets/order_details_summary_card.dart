import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/extensions/ext.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/divider_widget.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/shared/models/order_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsSummaryCard extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsSummaryCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: EdgeInsets.all(AppSize.p24),
      child: Column(
        children: [
          _buildSummaryItem(
            theme,
            icon: Icons.inventory_2_outlined,
            label: TKeys.items.tr,
            value:
                '${order.items.length.toString().toLocalizedDigit} ${TKeys.item.tr}',
            color: theme.colorScheme.primary,
          ),

          AppSize.p16.height,

          AppDivider.horizontal(space: 1),

          AppSize.p16.height,

          _buildSummaryItem(
            theme,
            icon: Icons.payments_outlined,
            label: TKeys.totalPrice.tr,
            value: "${order.totalPrice.toLocalizedPrice} ${TKeys.toman.tr}",
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(AppSize.p12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: AppSize.brCircular(AppSize.r12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            AppSize.p12.width,
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.bodyLarge!.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        AppSize.p8.width,
        Flexible(
          flex: 3,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
