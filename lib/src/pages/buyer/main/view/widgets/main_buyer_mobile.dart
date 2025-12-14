import 'package:taav_store/src/pages/buyer/account/view/buyer_account_screen.dart';
import 'package:taav_store/src/pages/buyer/cart/view/cart_screen.dart';
import 'package:taav_store/src/pages/buyer/products/view/buyer_products_screen.dart';
import 'package:taav_store/src/pages/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_buyer_controller.dart';

class MainBuyerMobile extends GetView<MainBuyerController> {
  const MainBuyerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BuyerProductsScreen(),
      const CartScreen(),
      const BuyerAccountScreen(),
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
