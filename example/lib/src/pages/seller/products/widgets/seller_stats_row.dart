import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/seller_products_controller.dart';
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
          SellerStatItem(
            value: '۱۵۶',
            label: TKeys.sales.tr,
            icon: Icons.shopping_cart_outlined,
            textColor: Colors.white,
            subColor: Colors.white70,
          ),
          AppDivider.vertical(height: 40),
          SellerStatItem(
            value: '۸',
            label: TKeys.newOrders.tr,
            icon: Icons.local_shipping_outlined,
            textColor: Colors.white,
            subColor: Colors.white70,
          ),
        ],
      ),
    );
  }
}
