import 'package:example/src/pages/seller/products/view/seller_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_seller_controller.dart';
import '../widgets/custom_bottom_nav.dart';

class MainSellerScreen extends GetView<MainSellerController> {
  const MainSellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainSellerController());

    final pages = [
      const SellerProductsScreen(),
      const SizedBox(),
      const ProfileSellerPage(),
    ];

    return Scaffold(
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child:
              pages[controller.currentIndex.value == 1
                  ? 0
                  : controller.currentIndex.value],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Obx(
        () => CustomBottomNav(
          currentIndex: controller.currentIndex.value,
          items: controller.navItems,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}



class ProfileSellerPage extends StatelessWidget {
  const ProfileSellerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: Text(
            'صفحه پروفایل فروشنده',
            style: TextStyle(fontSize: 20, color: Colors.grey[800]),
          ),
        ),
      ),
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
