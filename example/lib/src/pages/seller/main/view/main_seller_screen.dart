
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';
import '../widgets/main_seller_desktop.dart';
import '../widgets/main_seller_mobile.dart';

class MainSellerScreen extends GetView<MainSellerController> {
  const MainSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MainSellerController());

    return const Responsive(
      mobile: MainSellerMobile(),
      desktop: MainSellerDesktop(),
    );
  }
}


class ProfileSellerPage extends StatelessWidget {
  const ProfileSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('پروفایل')),
      body: const Center(child: Text('صفحه پروفایل فروشنده')),
    );
  }
}

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('افزودن محصول جدید'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: const Center(child: Text('صفحه افزودن محصول')),
    );
  }
}

