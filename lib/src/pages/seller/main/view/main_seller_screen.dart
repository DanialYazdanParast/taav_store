import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';
import 'widgets/main_seller_desktop.dart';
import 'widgets/main_seller_mobile.dart';

class MainSellerScreen extends GetView<MainSellerController> {
  final int initialTab;

  const MainSellerScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: const MainSellerMobile(),
      desktop: const MainSellerDesktop(),
    );
  }
}
