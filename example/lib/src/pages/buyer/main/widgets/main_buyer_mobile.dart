// lib/src/pages/buyer/main/widgets/main_buyer_mobile.dart

import 'package:example/src/pages/buyer/account/view/buyer_account_screen.dart';
import 'package:example/src/pages/buyer/products/view/buyer_products_screen.dart';
import 'package:example/src/pages/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';

class MainBuyerMobile extends GetView<MainBuyerController> {
  const MainBuyerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BuyerProductsScreen(),
      const SizedBox(),
      const BuyerAccountScreen(),
    ];

    return Scaffold(
      body: Obx(
            () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(controller.currentIndex.value),
            child: pages[controller.currentIndex.value],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(() {
        return CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          items: controller.navItems,
          onTap: controller.changeTab,


        );
      }),
    );
  }
}