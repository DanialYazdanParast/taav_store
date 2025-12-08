import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/utils/formatters/number_formatter.dart';
import 'package:example/src/commons/widgets/app_shimmer.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerProductCard extends StatelessWidget {
  final String productName;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercent;
  final String imagePath;
  final int quantity;
  final double size;
  final Function onTap;

  const BuyerProductCard({
    super.key,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.quantity,
    required this.imagePath,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: () => onTap(),
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
          children: [
            _ProductImage(
              discountPercent: discountPercent,
              imagePath: imagePath,
              size: size,
            ),
            AppSize.p12.width,
            _ProductInfo(
              productName: productName,
              originalPrice: originalPrice,
              discountedPrice: discountedPrice,
              discountPercent: discountPercent,
              quantity: quantity,
              primaryColor: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String discountPercent;
  final String imagePath;
  final double size;

  const _ProductImage({
    required this.discountPercent,
    required this.imagePath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = discountPercent != '0' && discountPercent != '۰';

    return Stack(
      children: [
        TaavNetworkImage(
          imagePath,
          width: double.infinity,
          height: size,
          borderRadius: 10,
        ),

        if (hasDiscount) _DiscountBadge(discountPercent: discountPercent),
      ],
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  final String discountPercent;

  const _DiscountBadge({required this.discountPercent});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Positioned(
      top: AppSize.p4,
      right: AppSize.p4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.p5,
          vertical: AppSize.p2,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.error,
          borderRadius: BorderRadius.circular(AppSize.r6),
        ),
        child: Text(
          '$discountPercent%',
          style: TextStyle(
            color: theme.colorScheme.onError,
            fontSize: AppSize.f10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// اطلاعات محصول
class _ProductInfo extends StatelessWidget {
  final String productName;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercent;
  final int quantity;
  final Color primaryColor;

  const _ProductInfo({
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.quantity,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              productName,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          _PriceColum(
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            discountPercent: discountPercent,
          ),
        ],
      ),
    );
  }
}

class _PriceColum extends StatelessWidget {
  final String originalPrice;
  final String discountedPrice;
  final String discountPercent;

  const _PriceColum({
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final double original =
        double.tryParse(originalPrice.replaceAll(',', '')) ?? 0;
    final double discounted =
        double.tryParse(discountedPrice.replaceAll(',', '')) ?? 0;

    final bool hasDiscount = original > discounted;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasDiscount)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    original.toLocalizedPrice,
                    style: theme.textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: theme.disabledColor,
                      fontSize: AppSize.f12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 32),

        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              discounted.toLocalizedPrice,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                TKeys.currency.tr,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

//-------------------------Shimmer----------------------------//

class BuyerProductCardShimmer extends StatelessWidget {
  const BuyerProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          Responsive.isMobile
              ? const EdgeInsets.only(bottom: AppSize.p12)
              : EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSize.p8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r15),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
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

          AppShimmer.rect(width: double.infinity, height: 20, borderRadius: 6),

          const SizedBox(height: 16),

          AppShimmer.rect(width: 100, height: 16, borderRadius: 4),

          const SizedBox(height: 16),

          AppShimmer.rect(width: 140, height: 24, borderRadius: 6),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
