part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const String splash = _Paths.splash;
  static const String sellerProducts = _Paths.sellerProducts;
  static const String login = _Paths.login;
  static const String register = _Paths.register;
  static const String mainSeller = _Paths.mainSeller;
}

abstract class _Paths {
  _Paths._();

  static const String splash = '/';
  static const String sellerProducts = '/seller_products';
  static const String login = '/login';
  static const String register = '/register';
  static const String mainSeller = '/main_seller';
}
