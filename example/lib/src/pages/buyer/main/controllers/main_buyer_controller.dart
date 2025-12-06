import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/nav_item_model.dart';
import '../../../../commons/widgets/responsive/responsive.dart';
import '../../../../infoStructure/languages/translation_keys.dart';

class MainBuyerController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxInt addProductBadge = 5.obs;
  List<NavItemModel> get navItems => [
    NavItemModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: TKeys.navHome.tr,
    ),
    NavItemModel(
        icon: Icons.shopping_cart,
        activeIcon: Icons.shopping_cart,
        label: TKeys.navAddProduct.tr,
        isSpecial: true,
        badgeCount: addProductBadge.value
    ),


    
    NavItemModel(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: TKeys.navProfile.tr,
    ),
  ];




  void incrementBadge() {
    addProductBadge.value++;
  }


  void decrementBadge() {
    if (addProductBadge.value > 0) {
      addProductBadge.value--;
    }
  }


  void setBadge(int count) {
    addProductBadge.value = count;
  }


  void clearBadge() {
    addProductBadge.value = 0;
  }

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
    // Get.to(
    //       () => SellerAddScreen(),
    //   transition: Transition.downToUp,
    //   duration: const Duration(milliseconds: 400),
    //   curve: Curves.easeOutQuart,
    // );
  }
}