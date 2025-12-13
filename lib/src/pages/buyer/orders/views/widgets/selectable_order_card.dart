import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/pages/shared/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectableOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableOrderCard({
    super.key,
    required this.order,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppSize.brCircular(AppSize.r16),
        child: Padding(
          padding: EdgeInsets.all(AppSize.p16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${LocaleKeys.order.tr} #${order.id.toString().toLocalizedDigit}',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  AppSize.p8.width,
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSize.p10,
                      vertical: AppSize.p6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: AppSize.brCircular(AppSize.r8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        AppSize.p6.width,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '${order.items.length.toString().toLocalizedDigit} ${LocaleKeys.item.tr}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSize.p16.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      LocaleKeys.totalPrice.tr,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                    ),
                  ),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.p12,
                          vertical: AppSize.p6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: AppSize.brCircular(AppSize.r8),
                          border: Border.all(
                            color: Colors.green.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          "${order.totalPrice.toLocalizedPrice} ${LocaleKeys.toman.tr}",
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
