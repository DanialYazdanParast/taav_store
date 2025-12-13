import 'package:taav_store/src/pages/Not_found/not_found_screen.dart';
import 'package:taav_store/src/pages/auth/login/commons/login_binding.dart';
import 'package:taav_store/src/pages/auth/login/view/login_screen.dart';
import 'package:taav_store/src/pages/auth/register/commons/register_binding.dart';
import 'package:taav_store/src/pages/auth/register/view/register_screen.dart';
import 'package:taav_store/src/pages/buyer/main/commons/main_buyer_binding.dart';
import 'package:taav_store/src/pages/buyer/main/view/main_buyer_screen.dart';
import 'package:taav_store/src/pages/buyer/orders/commons/order_history_binding.dart';
import 'package:taav_store/src/pages/buyer/orders/views/order_history_screen.dart';
import 'package:taav_store/src/pages/buyer/product_details/view/buyer_product_details_screen.dart';
import 'package:taav_store/src/pages/seller/edit_product/view/seller_edit_screen.dart';
import 'package:taav_store/src/pages/seller/main/commons/main_seller_binding.dart';
import 'package:taav_store/src/pages/seller/main/view/main_seller_screen.dart';
import 'package:taav_store/src/pages/seller/stats/commons/seller_stats_binding.dart';
import 'package:taav_store/src/pages/seller/stats/views/seller_stats_screen.dart';
import 'package:taav_store/src/pages/splash/commons/splash_binding.dart';
import 'package:taav_store/src/pages/splash/view/splash_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final unknownRoute = GetPage(
    name: _Paths.notFound,
    page: NotFoundScreen.new,
    transition: Transition.noTransition,
  );

  static final pages = <GetPage>[
    // Splash
    GetPage(
      name: _Paths.splash,
      page: SplashScreen.new,
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),

    // Auth
    GetPage(
      name: _Paths.auth,
      page: NotFoundScreen.new,
      binding: LoginBinding(),
      children: [
        GetPage(
          name: _Paths.login,
          page: LoginScreen.new,
          binding: LoginBinding(),
          transition: Transition.noTransition,
        ),
        GetPage(
          name: _Paths.register,
          page: RegisterScreen.new,
          binding: RegisterBinding(),
          transition: Transition.noTransition,
        ),
        GetPage(name: _Paths.notFound, page: NotFoundScreen.new),
      ],
    ),

    // Seller
    GetPage(
      name: _Paths.seller,
      page: MainSellerScreen.new,
      binding: MainSellerBinding(),
      children: [
        GetPage(
          name: _Paths.sellerProducts,
          page: MainSellerScreen.new,
          binding: MainSellerBinding(),
        ),
        GetPage(
          name: _Paths.sellerAddProduct,
          page: MainSellerScreen.new,
          binding: MainSellerBinding(),
        ),
        GetPage(
          name: _Paths.sellerAccount,
          page: MainSellerScreen.new,
          binding: MainSellerBinding(),
        ),
        GetPage(
          name: _Paths.sellerEditProduct,
          page: SellerEditScreen.new,
          binding: MainSellerBinding(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: _Paths.sellerStats,
          page: SellerStatsScreen.new,
          binding: SellerStatsBinding(),
          transition: Transition.downToUp,
        ),
        GetPage(name: _Paths.notFound, page: NotFoundScreen.new),
      ],
    ),

    // Buyer
    GetPage(
      name: _Paths.buyer,
      page: MainBuyerScreen.new,
      binding: MainBuyerBinding(),
      children: [
        GetPage(
          name: _Paths.buyerProducts,
          page: MainBuyerScreen.new,
          binding: MainBuyerBinding(),
        ),
        GetPage(
          name: _Paths.buyerCart,
          page: MainBuyerScreen.new,
          binding: MainBuyerBinding(),
        ),
        GetPage(
          name: _Paths.buyerAccount,
          page: MainBuyerScreen.new,
          binding: MainBuyerBinding(),
        ),
        GetPage(
          name: _Paths.buyerProductDetails,
          page: BuyerProductDetailsScreen.new,
          binding: MainBuyerBinding(),
          transition: Transition.downToUp,
        ),
        GetPage(
          name: _Paths.buyerOrders,
          page: OrderHistoryScreen.new,
          binding: OrderHistoryBinding(),
          transition: Transition.downToUp,
        ),
        GetPage(name: _Paths.notFound, page: NotFoundScreen.new),
      ],
    ),
  ];
}
