import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/pages/auth/login/widgets/desktop_login_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/login_controllr.dart';
import '../widgets/mobile_login_layout.dart';

class LoginScreen extends GetView<LoginControllr> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: const MobileLoginLayout(),
        desktop: const DesktopLoginLayout(),
      ),
    );
  }
}
