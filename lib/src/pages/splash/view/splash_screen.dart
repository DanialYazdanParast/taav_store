import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/splash_body.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Responsive(
          mobile: SplashBody(logoWidth: Get.width * 0.6),
          desktop: SplashBody(logoWidth: 350),
        ),
      ),
    );
  }
}
