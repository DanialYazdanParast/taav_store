import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_product_details_controller.dart';

class ProductActionBarWidget extends GetView<BuyerProductDetailsController> {
  final bool isDesktop;

  const ProductActionBarWidget({super.key, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      if (controller.product.value == null) return const SizedBox.shrink();

      if (isDesktop) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPriceSection(theme, alignRight: false),
            const SizedBox(height: 20),
            SizedBox(height: 50, child: _buildAddToCartButton(theme)),
          ],
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 2, child: _buildAddToCartButton(theme)),
            const SizedBox(width: AppSize.p20),
            _buildPriceSection(theme),
          ],
        );
      }
    });
  }

  Widget _buildAddToCartButton(ThemeData theme) {
    final product = controller.product.value!;
    int currentQtyForColor = controller.quantityInCartForSelectedColor;
    int dynamicMaxQuantity = currentQtyForColor + controller.remainingStock;

    String buttonLabel = TKeys.addToCart.tr;
    bool isDisabled = false;

    if (product.quantity == 0) {
      buttonLabel = TKeys.outOfStock.tr;
      isDisabled = true;
    } else if (controller.remainingStock <= 0 && currentQtyForColor == 0) {
      buttonLabel = TKeys.soldOut.tr;
      isDisabled = true;
    }

    return AdvancedCountControl(
      currentQuantity: currentQtyForColor,
      maxQuantity: dynamicMaxQuantity,
      onIncrease: controller.onAddOrIncrease,
      onAddTap: controller.onAddOrIncrease,
      onDecrease: controller.onDecrease,
      showAddButton: product.quantity == 0 || currentQtyForColor == 0,
      addButtonLabel: buttonLabel,
      isDisabled: isDisabled,
      maxReachedLabel:  TKeys.maximum.tr,
      style: CountControlStyle(
        primaryColor: theme.colorScheme.primary,
        backgroundColor: theme.scaffoldBackgroundColor,
        contentColor: theme.colorScheme.primary,
        borderSide: BorderSide(color: theme.dividerColor),
        borderRadius: AppSize.r10,
        textStyle: theme.textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
        btnTextStyle: theme.textTheme.labelLarge!.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
      ),
      numberFormatter: (value) => value.toLocalizedDigit,
    );
  }

  Widget _buildPriceSection(ThemeData theme, {bool alignRight = true}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (controller.hasDiscount) _buildDiscountRow(theme),
        _buildFinalPrice(theme),
      ],
    );
  }

  Widget _buildDiscountRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "${controller.discountPercentage.toString()}٪",
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onError,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            controller.product.value!.price.toLocalizedPrice,
            style: theme.textTheme.bodySmall?.copyWith(
              decoration: TextDecoration.lineThrough,
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalPrice(ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          controller.effectivePrice.toInt().toLocalizedPrice,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          TKeys.toman.tr,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
