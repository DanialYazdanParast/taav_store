part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  static const String splash = _Paths.splash;
  static const String sellerProducts = _Paths.sellerProducts;
}

abstract class _Paths {
  _Paths._();

  static const String splash = '/';
  static const String sellerProducts = '/seller_products';
}
