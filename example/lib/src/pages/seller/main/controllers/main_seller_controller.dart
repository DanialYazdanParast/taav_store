import 'package:example/src/pages/shared/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../view/main_seller_screen.dart';

class MainSellerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final RxInt currentIndex = 0.obs;

  final List<NavItemModel> navItems = [
    NavItemModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'خانه',
    ),
    NavItemModel(
      icon: Icons.add,
      activeIcon: Icons.add,
      label: 'افزودن',
      isSpecial: true,
    ),
    NavItemModel(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'پروفایل',
    ),
  ];

  void changeTab(int index) {
    if (index == 1) {
      goToAddProduct();
    } else {
      currentIndex.value = index;
    }
  }

  void goToAddProduct() {
    Get.to(
      () => const AddProductPage(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }
}
