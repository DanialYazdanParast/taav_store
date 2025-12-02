import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../controllers/register_controller.dart';
import '../widgets/desktop_register_layout.dart';
import '../widgets/mobile_register_layout.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Column(
          children: [
            Text(controller.userList.length.toString()),
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: controller.userList.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text(controller.userList.length.toString()),
                  );
                },
              ),
            ),
          ],
        );
      }),

      //  Responsive(
      //   mobile: const MobileRegisterLayout(),
      //   desktop: const DesktopRegisterLayout(),
      // ),
    );
  }
}
