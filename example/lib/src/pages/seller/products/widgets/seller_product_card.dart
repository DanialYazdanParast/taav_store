import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerProductCard extends StatelessWidget {
  final String productName;
  final String originalPrice;
  final String discountedPrice;
  final String discountPercent;
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
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      margin: Responsive.isMobile
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
          _ProductImage(discountPercent: discountPercent),
          AppSize.p12.width,
          _ProductInfo(
            productName: productName,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
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

// -----------------------------------
// تصویر محصول
// -----------------------------------
class _ProductImage extends StatelessWidget {
  final String discountPercent;

  const _ProductImage({required this.discountPercent});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(AppSize.r10),
          ),
          child: Icon(
            Icons.image_outlined,
            size: 35,
            color: theme.hintColor,
          ),
        ),
        if (discountPercent != '۰') _DiscountBadge(discountPercent: discountPercent),
      ],
    );
  }
}

// -----------------------------------
// برچسب تخفیف
// -----------------------------------
class _DiscountBadge extends StatelessWidget {
  final String discountPercent;

  const _DiscountBadge({required this.discountPercent});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

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
          '$discountPercent٪',
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

// -----------------------------------
// اطلاعات محصول
// -----------------------------------
class _ProductInfo extends StatelessWidget {
  final String productName;
  final String originalPrice;
  final String discountedPrice;
  final int quantity;
  final Color primaryColor;

  const _ProductInfo({
    required this.productName,
    required this.originalPrice,
    required this.discountedPrice,
    required this.quantity,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

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
          ),
          AppSize.p4.height,
          _StockChip(
            quantity: quantity,
            primaryColor: primaryColor,
          ),
        ],
      ),
    );
  }
}

// -----------------------------------
// ردیف قیمت
// -----------------------------------
class _PriceRow extends StatelessWidget {
  final String originalPrice;
  final String discountedPrice;

  const _PriceRow({
    required this.originalPrice,
    required this.discountedPrice,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return SizedBox(
      height: 30,
      child: Align(
        alignment: Alignment.centerRight,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                discountedPrice,
                style: TextStyle(
                  color: Colors.green[600],
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.f14,
                ),
              ),
              Text(
                ' تومان ',
                style: TextStyle(
                  color: Colors.green[600],
                  fontSize: AppSize.f11,
                ),
              ),
              AppSize.p8.width,
              Text(
                originalPrice,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: AppSize.f12,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------
// چیپ موجودی
// -----------------------------------
class _StockChip extends StatelessWidget {
  final int quantity;
  final Color primaryColor;

  const _StockChip({
    required this.quantity,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = quantity < 5 ? Colors.orange : primaryColor;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.p8,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSize.r6),
        border: Border.all(
          color: chipColor.withOpacity(0.2),
          width: 0.5,
        ),
      ),
      child: Text(
        'موجودی: $quantity',
        style: TextStyle(
          color: chipColor,
          fontSize: AppSize.f10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// -----------------------------------
// دکمه‌های عملیات
// -----------------------------------
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

// -----------------------------------
// دکمه عملیات تکی
// -----------------------------------
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
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSize.r8),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}