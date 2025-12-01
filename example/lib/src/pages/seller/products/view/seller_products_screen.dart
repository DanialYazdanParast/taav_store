import 'package:example/src/commons/constants/app_png.dart';
import 'package:example/src/infoStructure/languages/localization_controller.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerProductsScreen extends StatelessWidget {
  SellerProductsScreen({super.key});

  // متغیر محلی برای مدیریت تب انتخاب شده (فقط برای تست UI)
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final locController = Get.find<LocalizationController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(TKeys.appTitle.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => locController.toggleLocale(),
            tooltip: 'تغییر زبان',
          ),
        ],
      ),

      // بدنه اصلی (همان تست‌های قبلی)
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Chip(
                label: Text(
                  "زبان: ${Get.locale?.languageCode.toUpperCase()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.amber.shade100,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "تست جهت (Row):",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade200,
              child: Row(
                children: [
                  const Icon(Icons.start, color: Colors.green), // فارسی: راست
                  const SizedBox(width: 10),
                  const Text("Start"),
                  const Spacer(),
                  const Text("End"),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.abc_outlined,
                    color: Colors.red,
                  ), // فارسی: چپ
                ],
              ),
            ),
            Image.asset(AppPng.logo, width: 400, height: 400),
          ],
        ),
      ),

      // --- تست BottomNavigationBar ---
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) => selectedIndex.value = index,
          // جهت چیدمان این دکمه‌ها در فارسی و انگلیسی باید برعکس شود
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'خانه', // آیتم اول
            ),
            NavigationDestination(
              icon: Icon(Icons.store_outlined),
              selectedIcon: Icon(Icons.store),
              label: 'محصولات', // آیتم دوم (وسط)
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'پروفایل', // آیتم سوم
            ),
          ],
        ),
      ),
    );
  }
}
