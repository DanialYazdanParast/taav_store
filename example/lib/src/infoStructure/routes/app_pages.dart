import 'package:example/src/pages/seller/products/view/seller_products_screen.dart';
import 'package:example/src/pages/splash/commons/splash_binding.dart';
import 'package:example/src/pages/splash/view/splash_screen.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const initial = AppRoutes.splash;
  static List<GetPage> pages = [
    GetPage(
      name: _Paths.splash,
      page: SplashScreen.new,
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: _Paths.sellerProducts,
      page: SellerProductsScreen.new,
      transition: Transition.noTransition,
    ),
  ];
}
