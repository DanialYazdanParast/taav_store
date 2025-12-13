import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/extensions/product_discount_ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/app_shimmer.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/products/controllers/buyer_products_controller.dart';
import 'package:example/src/pages/shared/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerProductCard extends GetView<BuyerProductsController> {
  final ProductModel product;
  final double imageHeight;
  final VoidCallback onTap;

  const BuyerProductCard({
    super.key,
    required this.product,
    required this.imageHeight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    controller.initializeProductColor(product.id, product.colors);

    final currentQty = controller.getTotalQuantityInCart(product.id);

    return Obx(() {
      final ProductModel updatedProduct = controller.products.firstWhere(
        (p) => p.id == product.id,
        orElse: () => product,
      );

      controller.initializeProductColor(
        updatedProduct.id,
        updatedProduct.colors,
      );

      return InkWell(
        onTap: onTap,
        child: Container(
          margin:
              Responsive.isMobile
                  ? const EdgeInsets.only(bottom: AppSize.p12)
                  : EdgeInsets.zero,
          padding: const EdgeInsets.all(AppSize.p8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.r15),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE (نیاز نیست دوباره Obx شود، چون کل متد Build در Obx است)
              _ProductImage(product: updatedProduct, height: imageHeight),
              AppSize.p8.height,

              /// TOP CONTENT (title, price, color)
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: _ProductInfo(product: updatedProduct),
                ),
              ),

              AppSize.p8.height,

              /// ✅ ADD TO CART
              _AddToCartSection(product: updatedProduct),
            ],
          ),
        ),
      );
    }); // پایان Obx
  }
}

/* -------------------------------------------------------------------------- */
/*                                   IMAGE                                    */
/* -------------------------------------------------------------------------- */

class _ProductImage extends StatelessWidget {
  final ProductModel product;
  final double height;

  const _ProductImage({required this.product, required this.height});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPercentString != '0';
    final discountPercent = product.discountPercentString;

    return Stack(
      children: [
        TaavNetworkImage(
          product.image,
          width: double.infinity,
          height: height,
          borderRadius: 10,
        ),

        if (hasDiscount)
          Positioned(
            top: AppSize.p6,
            right: AppSize.p6,
            child: _Badge(
              text: '$discountPercent%',
              color: context.theme.colorScheme.error,
            ),
          ),

        Positioned(
          top: AppSize.p6,
          left: AppSize.p6,
          child: _Badge(
            text: '${product.quantity.toLocalizedPrice} ${TKeys.stock.tr} ',
            color: context.theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.p6,
        vertical: AppSize.p2,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSize.r6),
      ),
      child: Text(
        text,
        style: context.theme.textTheme.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}


class _ProductInfo extends GetView<BuyerProductsController> {
  final ProductModel product;

  const _ProductInfo({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [

        Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),


        _PriceRow(product: product),
        const SizedBox(height: 8),

        if (product.colors.isNotEmpty) _ColorSelector(product: product),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final ProductModel product;

  const _PriceRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final hasDiscount =
        product.discountPrice > 0 && product.discountPrice < product.price;

    final effectivePrice = hasDiscount ? product.discountPrice : product.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscount)
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              product.price.toLocalizedPrice,
              style: theme.textTheme.labelSmall?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.disabledColor,
              ),
            ),
          ),

        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(
                effectivePrice.toLocalizedPrice,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium,
              ),

              const SizedBox(width: 4),

              Text(
                TKeys.currency.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class _ColorSelector extends GetView<BuyerProductsController> {
  final ProductModel product;

  const _ColorSelector({required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedColor = controller.getSelectedColor(
        product.id,
        product.colors,
      );

      return SizedBox(
        height: 28,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: product.colors.length,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (_, index) {
            final colorHex = product.colors[index];
            final color = colorHex.toColor;

            return GestureDetector(
              onTap:
                  () => controller.selectColorForProduct(product.id, colorHex),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        selectedColor == colorHex
                            ? context.theme.colorScheme.primary
                            : Colors.grey.shade300,
                    width: selectedColor == colorHex ? 2 : 1,
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}


class _AddToCartSection extends GetView<BuyerProductsController> {
  final ProductModel product;

  const _AddToCartSection({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Obx(() {
      final selectedColor = controller.getSelectedColor(
        product.id,
        product.colors,
      );

      final currentQty = controller.getCurrentQuantityForSelectedColor(
        product.id,
        product.colors,
      );

      final remainingStock = controller.getRemainingStock(
        product.id,
        product.quantity,
      );

      final maxQty = currentQty + remainingStock;

      final isOutOfStock = product.quantity == 0;

      return SizedBox(
        height: 40,
        width: double.infinity,
        child: AdvancedCountControl(
          currentQuantity: currentQty,
          maxQuantity: maxQty,
          onIncrease:
              () => controller.addProductToCart(
                product,
                selectedColor,
                currentQty,
              ),
          onAddTap:
              () => controller.addProductToCart(product, selectedColor, 0),
          onDecrease:
              () =>
                  controller.decreaseProductFromCart(product.id, selectedColor),
          showAddButton: currentQty == 0 || isOutOfStock,
          addButtonLabel:
              isOutOfStock ? TKeys.outOfStock.tr : TKeys.addToCart.tr,
          isDisabled: isOutOfStock,
          style: CountControlStyle(
            primaryColor: theme.colorScheme.primary,
            backgroundColor: theme.scaffoldBackgroundColor,
            contentColor: theme.colorScheme.primary,
            borderSide: BorderSide(color: theme.dividerColor, width: 0.8),
            borderRadius: AppSize.r8,
            btnTextStyle: theme.textTheme.labelMedium!.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimary,
              fontSize: 11,
            ),
          ),
          numberFormatter: (v) => v.toLocalizedDigit,
        ),
      );
    });
  }
}


class BuyerProductCardShimmer extends StatelessWidget {
  const BuyerProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSize.p8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r15),
        border: Border.all(color: context.theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppShimmer.rect(
            width: double.infinity,
            height: 120,
            borderRadius: 10,
          ),
          const SizedBox(height: 12),
          AppShimmer.rect(width: double.infinity, height: 18),
          const SizedBox(height: 8),
          AppShimmer.rect(width: 100, height: 14),
          const SizedBox(height: 12),
          AppShimmer.rect(width: double.infinity, height: 36),
        ],
      ),
    );
  }
}
