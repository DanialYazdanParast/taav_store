import 'package:taav_store/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/order_history_controller.dart';
import '../widgets/desktop_order_history_layout.dart';
import '../widgets/mobile_order_history_layout.dart';

class OrderHistoryScreen extends GetView<OrderHistoryController> {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: MobileOrderHistoryLayout(),
        desktop: DesktopOrderHistoryLayout(),
      ),
    );
  }
}
