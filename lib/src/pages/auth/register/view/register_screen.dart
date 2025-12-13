import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';
import '../widgets/desktop_register_layout.dart';
import '../widgets/mobile_register_layout.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: const MobileRegisterLayout(),
        desktop: const DesktopRegisterLayout(),
      ),
    );
  }
}
