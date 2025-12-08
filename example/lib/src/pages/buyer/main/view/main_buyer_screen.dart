import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';
import '../widgets/main_buyer_desktop.dart';
import '../widgets/main_buyer_mobile.dart';

class MainBuyerScreen extends GetView<MainBuyerController> {
  final int initialTab;

  const MainBuyerScreen({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.currentIndex.value != initialTab) {
       // controller.setTab(initialTab);
      }
    });

    return Responsive(mobile: MainBuyerMobile(), desktop: MainBuyerDesktop());
  }
}
