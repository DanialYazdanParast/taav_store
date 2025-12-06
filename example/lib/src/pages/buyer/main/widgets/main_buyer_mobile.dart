
import 'package:example/src/pages/shared/widgets/custom_bottom_nav.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';


class MainBuyerMobile extends GetView<MainBuyerController> {
  const MainBuyerMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const SizedBox(),
      const SizedBox(),
      const SizedBox(),
    ];

    return Scaffold(
      body: Obx(
            () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
          pages[controller.currentIndex.value == 1
              ? 0
              : controller.currentIndex.value],
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
