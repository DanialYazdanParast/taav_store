import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_buyer_controller.dart';
import '../widgets/main_buyer_desktop.dart';
import '../widgets/main_buyer_mobile.dart';



class MainBuyerScreen extends GetView<MainBuyerController> {
  const MainBuyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Responsive(
      mobile: MainBuyerMobile(),
      desktop: MainBuyerDesktop(),
    );
  }
}
