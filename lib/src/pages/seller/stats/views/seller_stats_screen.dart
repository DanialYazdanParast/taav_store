import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/seller_stats_controller.dart';
import '../widgets/desktop_seller_stats_layout.dart';
import '../widgets/mobile_seller_stats_layout.dart';

class SellerStatsScreen extends GetView<SellerStatsController> {
  const SellerStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
        mobile: MobileSellerStatsLayout(),
        desktop: DesktopSellerStatsLayout(),
      ),
    );
  }
}
