import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class CartItemWidget extends GetView<CartController> {
  final CartItemModel item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaavNetworkImage(
          item.productImage,
          width: 90,
          height: 90,
          borderRadius: 12,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: AppSize.p12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: item.colorHex.toColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "رنگ انتخابی",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${item.totalPrice.toLocalizedPrice} تومان",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildQuantityControl(item, theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(CartItemModel item, ThemeData theme) {
    int dynamicMaxQuantity = controller.getMaxAllowedQuantity(item);

    return AdvancedCountControl(
      currentQuantity: item.quantity,
      maxQuantity: dynamicMaxQuantity,
      onIncrease: () {
        if (item.quantity < dynamicMaxQuantity) {
          controller.incrementItem(item);
        } else {
          Get.snackbar(
            "محدودیت",
            "موجودی انبار تکمیل شده است",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
      onDecrease: () => controller.decrementItem(item),
      showAddButton: false,
      height: 36,
      width: 120,
      style: CountControlStyle(
        primaryColor: theme.colorScheme.primary,
        backgroundColor: theme.scaffoldBackgroundColor,
        contentColor: theme.iconTheme.color ?? Colors.black,
        borderSide: BorderSide(color: theme.dividerColor),
        borderRadius: 8,
        textStyle: theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),

      numberFormatter: (value) => value.toLocalizedDigit,
    );
  }
}
