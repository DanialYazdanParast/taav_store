import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
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
          value: '۴۵,۸۵۰,۰۰۰',
          // فقط عدد
          unit: TKeys.currency.tr,
          label: TKeys.totalRevenue.tr,
          icon: Icons.monetization_on_outlined,
          textColor: theme.colorScheme.primary,
          subColor: theme.colorScheme.primary.withAlpha(200),
        ),
        AppDivider.vertical(height: 50),

        Obx(
          () => SellerStatItem(
            value: controller.products.length.toString(),
            state: controller.productsState.value,
            label: TKeys.activeProducts.tr,
            icon: Icons.inventory_2_outlined,
            textColor: textColor,
            subColor: subColor,
          ),
        ),
        AppDivider.vertical(height: 50),

        SellerStatItem(
          value: '۱۵۶',
          label: TKeys.successfulSales.tr,
          icon: Icons.shopping_cart_outlined,
          textColor: textColor,
          subColor: subColor,
        ),
        AppDivider.vertical(height: 50),

        SellerStatItem(
          value: '۸',
          label: TKeys.newOrders.tr,
          icon: Icons.local_shipping_outlined,
          textColor: textColor,
          subColor: subColor,
        ),
      ],
    );
  }
}
