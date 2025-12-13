import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/widgets/divider_widget.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/seller_products_controller.dart';
import 'seller_stat_item.dart';

class SellerStatsRowMobile extends GetView<SellerProductsController> {
  const SellerStatsRowMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => SellerStatItem(
              value: controller.products.length.toString(),
              state: controller.productsState.value,
              label: TKeys.products.tr,
              icon: Icons.inventory_2_outlined,
              textColor: Colors.white,
              subColor: Colors.white70,
            ),
          ),
          AppDivider.vertical(height: 40),
          Obx(
            () => SellerStatItem(
              value: controller.totalSalesCount.value.toString(),
              label: TKeys.sales.tr,
              icon: Icons.shopping_cart_outlined,
              textColor: Colors.white,
              subColor: Colors.white70,
              state: controller.statsState.value,
            ),
          ),
          AppDivider.vertical(height: 40),
          Obx(
            () => SellerStatItem(
              value: controller.totalItemsInCart.toString(),
              label: TKeys.inCartItems.tr,
              icon: Icons.shopping_bag_outlined,
              textColor: Colors.white,
              subColor: Colors.white70,
              state: controller.statsState.value,
            ),
          ),
        ],
      ),
    );
  }
}
