import 'package:example/src/pages/seller/account/view/seller_account_screen.dart';
import 'package:example/src/pages/seller/add_product/view/seller_add_screen.dart';
import 'package:example/src/pages/seller/products/view/seller_products_screen.dart';
import 'package:example/src/pages/shared/widgets/custom_sidebar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';

class MainSellerDesktop extends GetView<MainSellerController> {
  const MainSellerDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SellerProductsScreen(),
      const SellerAddScreen(),
      const SellerAccountScreen(),
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
                  () => IndexedStack(
                index: controller.currentIndex.value,
                children: pages,
              ),
            ),
          ),
        ],
      ),
    );
  }
}