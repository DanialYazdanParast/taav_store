part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  // ─── Auth ───────────────────────────────────────────────────────────────
  static const String splash = _Paths.splash;
  static const String login = _Paths.login;
  static const String register = _Paths.register;

  // ─── Seller ─────────────────────────────────────────────────────────────
  static const String sellerProducts = _Paths.sellerProducts;
  static const String sellerAddProduct = _Paths.sellerAddProduct;
  static const String sellerSettings = _Paths.sellerSettings;
  static const String sellerEditProduct = _Paths.sellerEditProduct;
  static const String sellerStats = _Paths.sellerStats;
  // ─── Buyer ──────────────────────────────────────────────────────────────
  static const String buyerProducts = _Paths.buyerProducts;
  static const String buyerProductDetails = _Paths.buyerProductDetails;
  static const String buyerCart = _Paths.buyerCart;
  static const String buyerAccount = _Paths.buyerAccount;
  static const String buyerOrders = _Paths.buyerOrders;

  static const String notFound = _Paths.notFound;
}

abstract class _Paths {
  _Paths._();

  // ─── Auth ───────────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // ─── Seller ─────────────────────────────────────────────────────────────
  static const String sellerProducts = '/seller/products';
  static const String sellerAddProduct = '/seller/add-product';
  static const String sellerSettings = '/seller/settings';
  static const String sellerEditProduct = '/seller/products/:id';
  static const String sellerStats = '/seller/stats';

  // ─── Buyer ──────────────────────────────────────────────────────────────
  static const String buyerProducts = '/buyer/products';
  static const String buyerProductDetails = '/buyer/products/:id';
  static const String buyerCart = '/buyer/cart';
  static const String buyerAccount = '/buyer/account';
  static const String buyerOrders = '/buyer/orders';

  static const String notFound = '/404';
}