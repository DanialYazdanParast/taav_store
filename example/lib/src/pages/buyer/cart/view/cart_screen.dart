import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../widgets/desktop_cart_layout.dart';
import '../widgets/mobile_cart_layout.dart';


class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
        mobile: MobileCartLayout(),
        desktop: DesktopCartLayout(),
      ),
    );
  }
}