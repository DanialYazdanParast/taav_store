part of 'app_pages.dart';

abstract class AppRoutes {
  AppRoutes._();

  // Core / Auth
  static const splash = _Paths.splash;
  static const auth = _Paths.auth;
  static const login = '${_Paths.auth}${_Paths.login}';
  static const register = '${_Paths.auth}${_Paths.register}';

  // Seller
  static const seller = _Paths.seller;
  static const sellerProducts = '${_Paths.seller}${_Paths.sellerProducts}';
  static const sellerAddProduct = '${_Paths.seller}${_Paths.sellerAddProduct}';
  static const sellerSettings = '${_Paths.seller}${_Paths.sellerSettings}';
  static const sellerEditProduct = '${_Paths.seller}${_Paths.sellerEditProduct}';
  static const sellerStats = '${_Paths.seller}${_Paths.sellerStats}';

  // Buyer
  static const buyer = _Paths.buyer;
  static const buyerProducts = '${_Paths.buyer}${_Paths.buyerProducts}';
  static const buyerProductDetails = '${_Paths.buyer}${_Paths.buyerProductDetails}';
  static const buyerCart = '${_Paths.buyer}${_Paths.buyerCart}';
  static const buyerAccount = '${_Paths.buyer}${_Paths.buyerAccount}';
  static const buyerOrders = '${_Paths.buyer}${_Paths.buyerOrders}';

  static const notFound = _Paths.notFound;
}

abstract class _Paths {
  _Paths._();

  // Base
  static const splash = '/';
  static const notFound = '/:unknown';

  // Groups
  static const auth = '/auth';
  static const seller = '/seller';
  static const buyer = '/buyer';

  // Auth children
  static const login = '/login';
  static const register = '/register';

  // Seller children
  static const sellerProducts = '/products';
  static const sellerAddProduct = '/add-product';
  static const sellerSettings = '/settings';
  static const sellerEditProduct = '/products/:id';
  static const sellerStats = '/stats';

  // Buyer children
  static const buyerProducts = '/products';
  static const buyerProductDetails = '/products/:id';
  static const buyerCart = '/cart';
  static const buyerAccount = '/account';
  static const buyerOrders = '/orders';
}
