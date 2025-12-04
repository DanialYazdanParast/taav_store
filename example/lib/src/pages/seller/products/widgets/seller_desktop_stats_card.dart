import 'package:example/src/commons/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/seller_products_controller.dart';
import 'seller_stat_item.dart';

class SellerDesktopStatsCard extends GetView<SellerProductsController> {
  const SellerDesktopStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: Get.width * 0.85,
      constraints: const BoxConstraints(maxWidth: 1000),
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.p24,
        horizontal: 40,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSize.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: AppSize.p20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: _buildStatsRow(theme),
    );
  }

  Widget _buildStatsRow(ThemeData theme) {
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.grey[800]!;
    final subColor = theme.textTheme.bodySmall?.color ?? Colors.grey[500]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SellerStatItem(
          value: ' ۴۵,۸۵۰,۰۰۰ تومان',
          label: ' درآمد کل',
          icon: Icons.monetization_on_outlined,
          textColor: theme.colorScheme.primary,
          subColor: theme.colorScheme.primary.withAlpha(200),
        ),
        _buildDivider(theme),
      Obx(() =>   SellerStatItem(
        value: controller.products.length.toString(),
        state: controller.productsState.value,
        label: 'محصولات فعال',
        icon: Icons.inventory_2_outlined,
        textColor: textColor,
        subColor: subColor,
      ),),
        _buildDivider(theme),
        SellerStatItem(
          value: '۱۵۶',
          label: 'فروش موفق',
          icon: Icons.shopping_cart_outlined,
          textColor: textColor,
          subColor: subColor,
        ),
        _buildDivider(theme),
        SellerStatItem(
          value: '۸',
          label: 'سفارش جدید',
          icon: Icons.local_shipping_outlined,
          textColor: textColor,
          subColor: subColor,
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(
      height: 50,
      width: 1,
      color: theme.dividerColor,
    );
  }
}