import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/seller/add_product/view/seller_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/nav_item_model.dart';
import '../../../../infrastructure/widgets/responsive/responsive.dart';
import '../../../../infrastructure/languages/translation_keys.dart';

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

  @override
  void onInit() {
    super.onInit();
    _syncIndexWithRoute();
  }

  @override
  void onReady() {
    super.onReady();
    ever(currentIndex, (_) => _syncIndexWithRoute());
    _syncIndexWithRoute();
  }

  void _syncIndexWithRoute() {
    final currentRoute = Get.currentRoute;

    if (currentRoute.contains('/products') || currentRoute == '/seller') {
      currentIndex.value = 0;
    } else if (currentRoute.contains('/add-product')) {
      currentIndex.value = 1;
    } else if (currentRoute.contains('/account')) {
      currentIndex.value = 2;
    }
  }

  void changeTab(int index) {
    final item = navItems[index];

    if (item.isSpecial) {
      if (Responsive.isDesktop) {
        _navigateToTab(index);
      } else {
        goToAddProduct();
      }
    } else {
      _navigateToTab(index);
    }
  }

  void _navigateToTab(int index) {
    if (currentIndex.value == index) return;

    final routes = [
      AppRoutes.sellerProducts,
      AppRoutes.sellerAddProduct,
      AppRoutes.sellerSettings,
    ];

    if (index >= 0 && index < routes.length) {
      Get.offNamed(routes[index]);
    }
  }

  void goToAddProduct() {
    Get.to(
      () => SellerAddScreen(),
      transition: Transition.downToUp,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
    );
  }

  void goToEditProduct(String productId) {
    Get.toNamed(
      AppRoutes.sellerEditProduct.replaceAll(':id', productId),
      arguments: productId,
    );
  }

  void goToProducts() => _navigateToTab(0);

  void goToSettings() => _navigateToTab(2);
}
