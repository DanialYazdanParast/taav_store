import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/nav_item_model.dart';
import '../view/main_seller_screen.dart';


class MainSellerController extends GetxController {
  final RxInt currentIndex = 0.obs;


  List<NavItemModel> get navItems => [
    NavItemModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: TKeys.navHome.tr,
    ),
    NavItemModel(
      icon: Icons.add,
      activeIcon: Icons.add,
      label: TKeys.navAddProduct.tr,
      isSpecial: true,
    ),
    NavItemModel(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: TKeys.navProfile.tr,
    ),
  ];

  void changeTab(int index) {

    final item = navItems[index];

    if (item.isSpecial) {
      if (Responsive.isDesktop) {
        currentIndex.value = index;
      } else {
        goToAddProduct();
      }
    } else {
      currentIndex.value = index;
    }
  }

  void goToAddProduct() {
    Get.to(
          () => AddProductPage(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }
}