import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/buyer/cart/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/nav_item_model.dart';

class MainBuyerController extends GetxController {
  final CartController _cartController = Get.find<CartController>();
  final RxInt currentIndex = 0.obs;
  final RxInt cartBadge = 0.obs;

  List<NavItemModel> get navItems => [
    NavItemModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: LocaleKeys.navHome.tr,
    ),
    NavItemModel(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: LocaleKeys.navCart.tr,
      isSpecial: true,
      badgeCount: cartBadge.value,
      showBadge: cartBadge.value > 0,
    ),
    NavItemModel(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: LocaleKeys.navProfile.tr,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    ever(currentIndex, (_) => _syncIndexWithRoute());
    _syncIndexWithRoute();
    _setupCartListener();
  }

  @override
  void onReady() {
    super.onReady();
    _syncIndexWithRoute();
  }

  void _setupCartListener() {
    cartBadge.value = _cartController.totalCount;

    ever(_cartController.cartItems, (_) {
      cartBadge.value = _cartController.totalCount;
    });
  }

  void _syncIndexWithRoute() {
    final currentRoute = Get.currentRoute;

    if (currentRoute.contains('/products') || currentRoute == '/buyer') {
      currentIndex.value = 0;
    } else if (currentRoute.contains('/cart')) {
      currentIndex.value = 1;
    } else if (currentRoute.contains('/account')) {
      currentIndex.value = 2;
    }
  }

  void changeTab(int index) {
    if (currentIndex.value == index) return;

    final routes = [
      AppRoutes.buyerProducts,
      AppRoutes.buyerCart,
      AppRoutes.buyerAccount,
    ];

    if (index >= 0 && index < routes.length) {
      Get.offNamed(routes[index]);
    }
  }

  void goToProductDetails(String productId) {
    Get.toNamed(
      AppRoutes.buyerProductDetails.replaceAll(':id', productId),
      arguments: productId,
    );
  }

  void goToCart() => changeTab(1);

  void goToProducts() => changeTab(0);

  void goToAccount() => changeTab(2);
}
