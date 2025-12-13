import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/buyer/main/controllers/main_buyer_controller.dart';
import 'package:taav_store/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:taav_store/src/pages/shared/widgets/custom_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/buyer_product_details_controller.dart';
import 'product_image_widget.dart';
import 'color_selector_widget.dart';
import 'product_action_bar_widget.dart';

class DesktopProductLayout extends GetView<BuyerProductDetailsController> {
  const DesktopProductLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(LocaleKeys.productDetails.tr),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(AppRoutes.buyerProducts),
        ),
        actions: [_buildCartIcon(theme), const SizedBox(width: 16)],
      ),
      body: Obx(() {
        if (controller.productState.value != CurrentState.success) {
          return const Center(child: CircularProgressIndicator());
        }

        final product = controller.product.value!;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(24),
                      child: ProductImageWidget(
                        height: 500, // ارتفاع ثابت برای زیبایی در وب
                        width: double.infinity,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(width: 40),

                  // ─── ستون سمت راست: جزئیات و دکمه خرید ───
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // تگ‌ها
                          if (product.tags.isNotEmpty)
                            Text(
                              product.tags.join(" / "),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          const SizedBox(height: 12),

                          // عنوان
                          Text(
                            product.title,
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // قیمت و دکمه خرید (که ویجت جدا کردیم)
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              border: Border.all(color: theme.dividerColor),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const ProductActionBarWidget(
                              isDesktop: true,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // انتخاب رنگ
                          const ColorSelectorWidget(),
                          const SizedBox(height: 32),

                          // توضیحات
                          Text(
                            LocaleKeys.productDescription.tr,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            product.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.8,
                              color: theme.textTheme.bodyMedium?.color
                                  ?.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCartIcon(ThemeData theme) {
    return Obx(() {
      final count = controller.cartController.totalCount;
      return Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            IconButtonWidget(
              icon: Icons.shopping_cart_outlined,
              onTap: () {
                final mainSellerController = Get.find<MainBuyerController>();
                Get.back();
                mainSellerController.changeTab(1);
              }, // Get.toNamed('/cart');
              hasBorder: true,
              size: 20,
              color: theme.colorScheme.onSurface,
            ),
            if (count > 0)
              Positioned(
                top: -5,
                right: -5,
                child: CustomBadge(
                  badgeCount: count,
                  fontSize: 10,
                  paddingHorizontal: 5,
                  paddingVertical: 2,
                  radius: 12,
                ),
              ),
          ],
        ),
      );
    });
  }
}
