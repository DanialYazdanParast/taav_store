import 'package:example/src/pages/seller/account/view/seller_account_screen.dart';
import 'package:example/src/pages/seller/products/view/seller_products_screen.dart';
import 'package:example/src/pages/shared/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';

class MainSellerMobile extends GetView<MainSellerController> {
  const MainSellerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SellerProductsScreen(), // تب 0: محصولات
      const SizedBox(), // تب 1: افزودن (در موبایل نمایش داده نمی‌شه)
      const SellerAccountScreen(), // تب 2: تنظیمات/حساب
    ];

    return Scaffold(
      body: Obx(
            () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(controller.currentIndex.value),
            // اگر تب 1 (افزودن) بود، تب 0 رو نشون بده
            child: pages[controller.currentIndex.value == 1
                ? 0
                : controller.currentIndex.value],
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(() {
        return CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          items: controller.navItems,
          onTap: controller.changeTab, // 🔥 مدیریت navigation
        );
      }),
    );
  }
}