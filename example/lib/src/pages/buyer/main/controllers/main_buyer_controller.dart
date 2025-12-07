
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/nav_item_model.dart';
import '../../../../commons/widgets/responsive/responsive.dart';
import '../../../../infoStructure/languages/translation_keys.dart';

class MainBuyerController extends GetxController {
  // ─── Navigation State ──────────────────────────────────────────────────
  final RxInt currentIndex = 0.obs;
  final RxInt cartBadge = 5.obs;

  // ─── Nav Items ─────────────────────────────────────────────────────────
  List<NavItemModel> get navItems => [
    NavItemModel(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: TKeys.navHome.tr,
    ),
    NavItemModel(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart,
      label: "TKeys.navCart.tr",
      isSpecial: true,
      badgeCount: cartBadge.value,
      showBadge: true,


    ),
    NavItemModel(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: TKeys.navProfile.tr,
    ),
  ];

  // ─── Lifecycle ─────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    _syncIndexWithRoute();
    _loadCartCount();
  }

  // ─── Private Methods ───────────────────────────────────────────────────

  /// هماهنگ کردن index با مسیر فعلی URL
  void _syncIndexWithRoute() {
    final currentRoute = Get.currentRoute;

    if (currentRoute.contains('/buyer/products') ||
        currentRoute == '/buyer') {
      currentIndex.value = 0;
    } else if (currentRoute.contains('/buyer/cart')) {
      currentIndex.value = 1;
    } else if (currentRoute.contains('/buyer/account')) {
      currentIndex.value = 2;
    }
  }

  /// بارگیری تعداد آیتم‌های سبد خرید
  void _loadCartCount() {
    // TODO: دریافت تعداد از سرویس سبد خرید
    // مثال:
    // final cartService = Get.find<CartService>();
    // cartBadge.value = cartService.itemCount;

    // برای الان یک مقدار نمونه:
    cartBadge.value = 0;
  }

  // ─── Public Methods ────────────────────────────────────────────────────

  /// تغییر تب (با تغییر URL)
  void changeTab(int index) {
    if (currentIndex.value == index) return;

    final routes = [
      AppRoutes.buyerProducts,  // تب 0: محصولات
      AppRoutes.buyerCart,      // تب 1: سبد خرید
      AppRoutes.buyerAccount,   // تب 2: حساب کاربری
    ];

    if (index >= 0 && index < routes.length) {
      // استفاده از offNamed برای جلوگیری از stack شدن routes
      Get.offNamed(routes[index]);
    }
  }

  /// تنظیم تب به صورت دستی (بدون navigation - فقط برای initialTab)
  void setTab(int index) {
    if (index >= 0 && index < navItems.length) {
      currentIndex.value = index;
    }
  }

  // ─── Cart Badge Management ─────────────────────────────────────────────

  /// افزایش تعداد بج سبد خرید
  void incrementCartBadge() {
    cartBadge.value++;
  }

  /// کاهش تعداد بج سبد خرید
  void decrementCartBadge() {
    if (cartBadge.value > 0) {
      cartBadge.value--;
    }
  }

  /// تنظیم دستی تعداد بج
  void setCartBadge(int count) {
    cartBadge.value = count.clamp(0, 99); // محدود به 0-99
  }

  /// پاک کردن بج
  void clearCartBadge() {
    cartBadge.value = 0;
  }

  // ─── Navigation Helpers ────────────────────────────────────────────────

  /// رفتن به صفحه جزئیات محصول
  void goToProductDetails(String productId) {
    Get.toNamed(
      AppRoutes.buyerProductDetails.replaceAll(':id', productId),
      arguments: productId,
    );
  }

  /// رفتن به صفحه سبد خرید
  void goToCart() {
    changeTab(1);
  }

  /// رفتن به صفحه محصولات
  void goToProducts() {
    changeTab(0);
  }

  /// رفتن به صفحه حساب کاربری
  void goToAccount() {
    changeTab(2);
  }

  // ─── Cart Actions ──────────────────────────────────────────────────────

  /// افزودن محصول به سبد خرید
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      // TODO: فراخوانی سرویس افزودن به سبد
      // await cartService.addItem(productId, quantity);

      incrementCartBadge();

      Get.snackbar(
        'موفق',
        'محصول به سبد خرید اضافه شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'افزودن به سبد خرید ناموفق بود',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  /// حذف محصول از سبد خرید
  Future<void> removeFromCart(String productId) async {
    try {
      // TODO: فراخوانی سرویس حذف از سبد
      // await cartService.removeItem(productId);

      decrementCartBadge();

      Get.snackbar(
        'موفق',
        'محصول از سبد خرید حذف شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    } catch (e) {
      Get.snackbar(
        'خطا',
        'حذف از سبد خرید ناموفق بود',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
      );
    }
  }

  // ─── Utils ─────────────────────────────────────────────────────────────

  /// بررسی اینکه آیا در حالت موبایل هستیم یا نه
  bool get isMobile => !Responsive.isDesktop;

  /// بررسی اینکه آیا در حالت دسکتاپ هستیم یا نه
  bool get isDesktop => Responsive.isDesktop;

  /// گرفتن نام تب فعلی
  String get currentTabName {
    if (currentIndex.value >= 0 && currentIndex.value < navItems.length) {
      return navItems[currentIndex.value].label;
    }
    return '';
  }

  /// بررسی اینکه آیا سبد خرید خالی است یا نه
  bool get isCartEmpty => cartBadge.value == 0;

  /// بررسی اینکه آیا سبد خرید پر است یا نه
  bool get hasCartItems => cartBadge.value > 0;
}