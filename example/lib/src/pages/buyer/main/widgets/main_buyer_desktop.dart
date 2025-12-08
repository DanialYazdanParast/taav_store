
import 'package:example/src/pages/buyer/account/view/buyer_account_screen.dart';
import 'package:example/src/pages/buyer/cart/view/cart_screen.dart';
import 'package:example/src/pages/buyer/products/view/buyer_products_screen.dart' show BuyerProductsScreen;
import 'package:example/src/pages/shared/widgets/custom_sidebar.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';



class MainBuyerDesktop extends GetView<MainBuyerController> {
  const MainBuyerDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BuyerProductsScreen(),
      const CartScreen(),
      const BuyerAccountScreen(),
    ];

    return Scaffold(
      body: Row(
        children: [
          Obx(
                () => CustomSidebar(
              currentIndex: controller.currentIndex.value,
              items: controller.navItems,
              onTap: controller.changeTab,
            ),
          ),

          Expanded(
            child: Obx(
                  () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Container(
                  key: ValueKey(controller.currentIndex.value),
                  child: pages[controller.currentIndex.value],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


