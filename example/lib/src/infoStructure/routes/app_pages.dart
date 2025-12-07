// lib/src/routes/app_pages.dart

import 'package:example/src/pages/Not_found/not_found_screen.dart';
import 'package:example/src/pages/auth/login/commons/login_binding.dart';
import 'package:example/src/pages/auth/login/view/login_screen.dart';
import 'package:example/src/pages/auth/register/commons/register_binding.dart';
import 'package:example/src/pages/auth/register/view/register_screen.dart';
import 'package:example/src/pages/buyer/main/commons/main_buyer_binding.dart';
import 'package:example/src/pages/buyer/main/view/main_buyer_screen.dart';
import 'package:example/src/pages/buyer/product_details/commons/buyer_product_details_binding.dart';
import 'package:example/src/pages/buyer/product_details/view/buyer_product_details_screen.dart';
import 'package:example/src/pages/seller/add_product/view/seller_add_screen.dart';
import 'package:example/src/pages/seller/edit_product/commons/seller_edit_binding.dart';
import 'package:example/src/pages/seller/edit_product/view/seller_edit_screen.dart';
import 'package:example/src/pages/seller/main/commons/main_seller_binding.dart';
import 'package:example/src/pages/seller/main/view/main_seller_screen.dart';
import 'package:example/src/pages/splash/commons/splash_binding.dart';
import 'package:example/src/pages/splash/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

part 'app_routes.dart';



class AppPages {
  AppPages._();

  static const initial = AppRoutes.splash;

  static final pages = [
    GetPage(
      name: _Paths.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),

    // ─── Auth ───────────────────────────────────────────────────────────
    GetPage(
      name: _Paths.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
      transition: Transition.rightToLeft,
    ),

    // ─── Seller ─────────────────────────────────────────────────────────
    GetPage(
      name: _Paths.sellerProducts,
      page: () => const MainSellerScreen(initialTab: 0),
      binding: MainSellerBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.sellerAddProduct,
      page: () => const MainSellerScreen(initialTab: 1),
      binding: MainSellerBinding(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: _Paths.sellerSettings,
      page: () => const MainSellerScreen(initialTab: 2),
      binding: MainSellerBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.sellerEditProduct,
      page: () => const SellerEditScreen(),
      binding: SellerEditBinding(),
      transition: Transition.downToUp,
    ),

    // ─── Buyer ──────────────────────────────────────────────────────────
    GetPage(
      name: _Paths.buyerProducts,
      page: () => const MainBuyerScreen(initialTab: 0),
      binding: MainBuyerBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.buyerCart,
      page: () => const MainBuyerScreen(initialTab: 1),
      binding: MainBuyerBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.buyerAccount,
      page: () => const MainBuyerScreen(initialTab: 2),
      binding: MainBuyerBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.buyerProductDetails,
      page: () => const BuyerProductDetailsScreen(),
      binding: BuyerProductDetailsBinding(),
      transition: Transition.rightToLeft,
    ),
  ];


}