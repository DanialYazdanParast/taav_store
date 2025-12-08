import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/app_shimmer.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../../../shared/models/cart_item_model.dart';

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
                    TKeys.selectedColor.tr,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item.totalPrice.toLocalizedPrice} ${TKeys.toman.tr}",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    16.width,
                    _buildQuantityControl(item, theme),
                  ],
                ),
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

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const double imageSize = 90;
    const double borderRadius = 12;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. شیمر برای تصویر محصول
        AppShimmer.rect(
          width: imageSize,
          height: imageSize,
          borderRadius: borderRadius,
        ),
        const SizedBox(width: AppSize.p12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer.rect(
                width: Get.width * 0.45,
                height: 18,
                borderRadius: 4,
              ),
              const SizedBox(height: 8),

              AppShimmer.rect(
                width: Get.width * 0.3,
                height: 18,
                borderRadius: 4,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  AppShimmer.circle(size: 16),
                  6.width,
                  AppShimmer.rect(
                    width: Get.width * 0.2,
                    height: 14,
                    borderRadius: 4,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.rect(
                    width: Get.width * 0.3,
                    height: 20,
                    borderRadius: 4,
                  ),



                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
