import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_product_details_controller.dart';
import 'widgets/desktop_product_layout.dart';
import 'widgets/mobile_product_layout.dart';

class BuyerProductDetailsScreen extends GetView<BuyerProductDetailsController> {
  const BuyerProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
        mobile: MobileProductLayout(),
        desktop: DesktopProductLayout(),
      ),
    );
  }
}
