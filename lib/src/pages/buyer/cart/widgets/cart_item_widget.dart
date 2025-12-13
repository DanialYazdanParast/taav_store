import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/app_shimmer.dart';
import 'package:taav_store/src/infrastructure/widgets/network_image.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../../../shared/models/cart_item_model.dart';

class CartItemWidget extends GetView<CartController> {
  final CartItemModel item;

  const CartItemWidget({super.key, required this.item});

  static const double _imageSize = 90;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TaavNetworkImage(
          item.productImage,
          width: _imageSize,
          height: _imageSize,
          borderRadius: AppSize.r12,
          fit: BoxFit.cover,
        ),
        AppSize.p12.width,

        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(theme),
              AppSize.p6.height,
              _buildColorInfo(theme),
              AppSize.p12.height,
              _buildPriceAndQuantityControl(theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      item.productTitle,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildColorInfo(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: item.colorHex.toColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
          ),
        ),
        AppSize.p6.width,
        Text(
          TKeys.selectedColor.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.disabledColor,
            fontSize: AppSize.f12,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndQuantityControl(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.totalPrice.toLocalizedPrice,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.f16,
                  ),
                ),
                AppSize.p8.width,
                Text(
                  TKeys.toman.tr,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.f12,
                  ),
                ),
                AppSize.p16.width,
              ],
            ),
          ),
        ),
        _buildQuantityControl(item, theme),
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
        borderSide: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
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
    final double borderRadius = AppSize.r12;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppShimmer.rect(
          width: imageSize,
          height: imageSize,
          borderRadius: borderRadius,
        ),
        AppSize.p12.width,

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppShimmer.rect(
                width: Get.width * 0.45,
                height: AppSize.f16,
                borderRadius: AppSize.r4,
              ),
              AppSize.p8.height,

              AppShimmer.rect(
                width: Get.width * 0.3,
                height: AppSize.f16,
                borderRadius: AppSize.r4,
              ),
              AppSize.p10.height,

              Row(
                children: [
                  AppShimmer.circle(size: 16),
                  AppSize.p6.width,
                  AppShimmer.rect(
                    width: Get.width * 0.2,
                    height: AppSize.f14,
                    borderRadius: AppSize.r4,
                  ),
                ],
              ),
              AppSize.p12.height,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppShimmer.rect(
                    width: Get.width * 0.25,
                    height: AppSize.f20,
                    borderRadius: AppSize.r4,
                  ),
                  AppShimmer.rect(
                    width: 120,
                    height: 36,
                    borderRadius: AppSize.r8,
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
