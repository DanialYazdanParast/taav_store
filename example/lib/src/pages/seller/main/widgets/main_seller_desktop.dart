// lib/src/pages/seller/main/widgets/main_seller_desktop.dart

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
      const SellerProductsScreen(), // تب 0: محصولات
      const SellerAddScreen(), // تب 1: افزودن محصول
      const SellerAccountScreen(), // تب 2: تنظیمات
    ];

    return Scaffold(
      body: Row(
        children: [
          Obx(
                () => CustomSidebar(
              currentIndex: controller.currentIndex.value,
              items: controller.navItems,
              onTap: controller.changeTab, // 🔥 مدیریت navigation
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