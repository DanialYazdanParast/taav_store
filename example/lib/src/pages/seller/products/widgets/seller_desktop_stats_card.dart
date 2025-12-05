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

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1000),
        padding: const EdgeInsets.symmetric(
          vertical: AppSize.p24,
          horizontal: 24,
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

        child: _buildDesktopLayout(theme),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme) {
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.grey[800]!;
    final subColor = theme.textTheme.bodySmall?.color ?? Colors.grey[500]!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: _buildItem1(theme)),
        AppDivider.vertical(height: 50),
        Expanded(child: _buildItem2(textColor, subColor)),
        AppDivider.vertical(height: 50),
        Expanded(child: _buildItem3(textColor, subColor)),
        AppDivider.vertical(height: 50),
        Expanded(child: _buildItem4(textColor, subColor)),
      ],
    );
  }

  Widget _buildItem1(ThemeData theme) {
    return SellerStatItem(
      value: '۴۵,۸۵۰,۰۰۰',
      unit: TKeys.currency.tr,
      label: TKeys.totalRevenue.tr,
      icon: Icons.monetization_on_outlined,
      textColor: theme.colorScheme.primary,
      subColor: theme.colorScheme.primary.withAlpha(200),
    );
  }

  Widget _buildItem2(Color textColor, Color subColor) {
    return Obx(
      () => SellerStatItem(
        value: controller.products.length.toString(),
        state: controller.productsState.value,
        label: TKeys.activeProducts.tr,
        icon: Icons.inventory_2_outlined,
        textColor: textColor,
        subColor: subColor,
      ),
    );
  }

  Widget _buildItem3(Color textColor, Color subColor) {
    return SellerStatItem(
      value: '۱۵۶',
      label: TKeys.successfulSales.tr,
      icon: Icons.shopping_cart_outlined,
      textColor: textColor,
      subColor: subColor,
    );
  }

  Widget _buildItem4(Color textColor, Color subColor) {
    return SellerStatItem(
      value: '۸',
      label: TKeys.newOrders.tr,
      icon: Icons.local_shipping_outlined,
      textColor: textColor,
      subColor: subColor,
    );
  }
}
