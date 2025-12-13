import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/extensions/ext.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/app_shimmer.dart';
import 'package:taav_store/src/commons/widgets/network_image.dart';
import 'package:taav_store/src/commons/widgets/responsive/responsive.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerProductCard extends StatelessWidget {
  final String productName;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercent;
  final String imagePath;
  final int quantity;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SellerProductCard({
    super.key,
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
    required this.quantity,
    required this.imagePath,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin:
          Responsive.isMobile
              ? const EdgeInsets.only(bottom: AppSize.p12)
              : EdgeInsets.zero,
      padding: const EdgeInsets.all(AppSize.p12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r15),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          _ProductImage(discountPercent: discountPercent, imagePath: imagePath),
          AppSize.p12.width,
          _ProductInfo(
            productName: productName,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            discountPercent: discountPercent,
            quantity: quantity,
            primaryColor: primaryColor,
          ),
          AppSize.p8.width,
          _ActionButtons(
            primaryColor: primaryColor,
            errorColor: theme.colorScheme.error,
            onEdit: onEdit,
            onDelete: onDelete,
          ),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String discountPercent;
  final String imagePath;

  const _ProductImage({required this.discountPercent, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bool hasDiscount = discountPercent != '0' && discountPercent != '۰';

    return Stack(
      children: [
        TaavNetworkImage(imagePath, width: 100, height: 100, borderRadius: 10),

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
          Text(
            productName,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSize.p6.height,
          _PriceRow(
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            discountPercent: discountPercent,
          ),
          AppSize.p4.height,
          _StockChip(quantity: quantity, primaryColor: primaryColor),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String originalPrice;
  final String discountedPrice;
  final String discountPercent;

  const _PriceRow({
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final bool hasDiscount = discountPercent != '0' && discountPercent != '۰';

    return SizedBox(
      height: 30,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: FittedBox(
              child: Text(
                (double.tryParse(discountedPrice.replaceAll(',', '')) ?? 0)
                    .toLocalizedPrice,
                style: TextStyle(
                  color: Colors.green[600],
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.f14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          Flexible(
            child: Text(
              ' ${TKeys.currency.tr} ',
              style: TextStyle(color: Colors.green[600], fontSize: AppSize.f11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (hasDiscount) ...[
            AppSize.p8.width,
            Flexible(
              child: Text(
                (double.tryParse(originalPrice.replaceAll(',', '')) ?? 0)
                    .toLocalizedPrice,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: AppSize.f12,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: theme.hintColor,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StockChip extends StatelessWidget {
  final int quantity;
  final Color primaryColor;

  const _StockChip({required this.quantity, required this.primaryColor});

  @override
  Widget build(BuildContext context) {
    final chipColor = quantity < 5 ? Colors.orange : primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p8, vertical: 3),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.r6),
        border: Border.all(color: chipColor.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Text(
        '${TKeys.stock.tr}: ${quantity.toLocalizedPrice}',
        style: TextStyle(
          color: chipColor,
          fontSize: AppSize.f10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final Color primaryColor;
  final Color errorColor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ActionButtons({
    required this.primaryColor,
    required this.errorColor,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.edit_outlined,
          color: primaryColor,
          onTap: onEdit,
        ),
        AppSize.p8.height,
        _ActionButton(
          icon: Icons.delete_outline,
          color: errorColor,
          onTap: onDelete,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.r8),
      child: Container(
        padding: const EdgeInsets.all(AppSize.p8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSize.r8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
//-------------------------Shimmer----------------------------//

class SellerProductCardShimmer extends StatelessWidget {
  const SellerProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.p12),
      padding: const EdgeInsets.all(AppSize.p12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSize.r15),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          AppShimmer.rect(width: 100, height: 100, borderRadius: 10),

          AppSize.p12.width,

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.rect(width: 140, height: 16, borderRadius: 6),
                AppSize.p8.height,

                AppShimmer.rect(width: 90, height: 14, borderRadius: 6),
                AppSize.p6.height,

                AppShimmer.rect(width: 60, height: 12, borderRadius: 6),
                AppSize.p6.height,

                AppShimmer.rect(width: 80, height: 14, borderRadius: 6),
              ],
            ),
          ),

          AppSize.p12.width,

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppShimmer.rect(height: 32, width: 32, borderRadius: 10),
              AppSize.p10.height,
              AppShimmer.rect(height: 32, width: 32, borderRadius: 10),
            ],
          ),
        ],
      ),
    );
  }
}
