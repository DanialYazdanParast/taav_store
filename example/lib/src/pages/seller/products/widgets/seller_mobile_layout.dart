import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'seller_animated_app_bar.dart';
import 'seller_product_card.dart';
import 'seller_revenue_section.dart';
import 'seller_sheet_header.dart';
import 'seller_stats_row.dart';

class SellerMobileLayout extends GetView<SellerProductsController> {


  const SellerMobileLayout({
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final primaryColor = theme.colorScheme.primary;
    final screenWidth = Get.width;
    final screenHeight = Get.height;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: Stack(
        children: [
          // پس‌زمینه رنگی بالا
          _buildTopBackground(theme, primaryColor, screenHeight, screenWidth, isRtl),
          // لیست پایین صفحه
          _buildBottomSheet(theme),
        ],
      ),
    );
  }

  Widget _buildTopBackground(
      ThemeData theme,
      Color primaryColor,
      double screenHeight,
      double screenWidth,
      bool isRtl,
      ) {
    return Container(
      height: screenHeight * 0.55,
      color: primaryColor,
      child: Stack(
        children: [
          DecorativeCircle(
            top: -80,
            right: -150,
            size: 300,
            color: theme.colorScheme.onPrimary.withOpacity(0.05),
          ),
          DecorativeCircle(
            bottom: -10,
            left: -100,
            size: 300,
            color: theme.colorScheme.onPrimary.withOpacity(0.05),
          ),
          SafeArea(
            child: Column(
              children: [
                SellerAnimatedAppBar(
                  controller: controller,
                  screenWidth: screenWidth,
                  isRtl: isRtl,
                ),
                AppSize.p10.height,
                const SellerRevenueSection(),
                AppSize.p20.height,
                const SellerStatsRowMobile(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(ThemeData theme) {
    return SafeArea(
      child: Obx(() => DraggableScrollableSheet(
        key: ValueKey(controller.isSearching.value),
        initialChildSize: controller.isSearching.value ? 0.75 : 0.58,
        minChildSize: 0.58,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSize.r12),
              ),
            ),
            child: Column(
              children: [
                const SellerSheetHeader(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.p16),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return SellerProductCard(
                        productName: 'محصول نمونه طولانی جهت تست ریسپانسیو ${index + 1}',
                        originalPrice: '۲,۵۰۰,۰۰۰',
                        discountedPrice: '۱,۹۹۰,۰۰۰',
                        discountPercent: '۲۰',
                        quantity: index + 3,
                        onEdit: () => controller.editProduct(index),
                        onDelete: () => controller.deleteProduct(index),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}