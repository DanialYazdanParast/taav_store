import 'package:taav_store/src/pages/seller/account/view/seller_account_screen.dart';
import 'package:taav_store/src/pages/seller/products/view/seller_products_screen.dart';
import 'package:taav_store/src/pages/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';

class MainSellerMobile extends GetView<MainSellerController> {
  const MainSellerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SellerProductsScreen(),
      const SellerProductsScreen(),
      const SellerAccountScreen(),
    ];

    return Scaffold(
      body: Obx(
        () =>
            IndexedStack(index: controller.currentIndex.value, children: pages),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          items: controller.navItems,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}
