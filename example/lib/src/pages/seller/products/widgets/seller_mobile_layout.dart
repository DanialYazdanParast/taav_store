import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/product_discount_ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/bottom_sheet.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/seller/products/widgets/seller_filter_view.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'delete_product_dialog.dart';
import '../../../shared/widgets/animated_app_bar.dart';
import 'seller_product_card.dart';
import 'seller_revenue_section.dart';
import '../../../shared/widgets/header_sheet.dart';
import 'seller_stats_row.dart';

class SellerMobileLayout extends GetView<SellerProductsController> {
  const SellerMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;
    final screenWidth = Get.width;
    final screenHeight = Get.height;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: Stack(
        children: [
          _buildTopBackground(
            theme,
            primaryColor,
            screenHeight,
            screenWidth,
            isRtl,
          ),

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
      height: 550,
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
                AnimatedAppBar<SellerProductsController>(
                  screenWidth: Get.width,
                  isRtl: true,
                  isSearching: controller.isSearching,
                  searchController: controller.searchController,
                  searchFocusNode: controller.searchFocusNode,
                  title: TKeys.sellerPanel.tr,
                  onFilterTap: () {
                    // Initialize temp filters
                    controller.initTempFilters();

                    // Show filter bottom sheet
                    BottomSheetWidget(
                      isScrollControlled: true,
                    ).show(const SellerFilterView());
                  },
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
      child: Obx(
        () => DraggableScrollableSheet(
          key: ValueKey(controller.isSearching.value),
          initialChildSize: 0.55,
          minChildSize: 0.55,
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
                  const HeaderSheet(),
                  Obx(() {
                    if (controller.productsState.value ==
                        CurrentState.loading) {
                      return Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.p16,
                          ),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return SellerProductCardShimmer();
                          },
                        ),
                      );
                    }
                    if (controller.productsState.value == CurrentState.error) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: ErrorView(
                          onRetry: () => controller.fetchProducts(),
                        ),
                      );
                    }

                    if (controller.filteredProducts.isEmpty) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),

                        child: EmptyWidget(),
                      );
                    }
                    return Expanded(
                      child: RefreshIndicator(
                        onRefresh: () => controller.fetchProducts(),
                        child: ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.p16,
                          ),
                          itemCount: controller.filteredProducts.length,
                          itemBuilder: (context, index) {
                            final product = controller.filteredProducts[index];
                            return SellerProductCard(
                              productName: product.title,
                              originalPrice: product.price.toString(),
                              discountedPrice: product.discountPrice.toString(),
                              discountPercent: product.discountPercentString,
                              quantity: product.quantity,
                              imagePath: product.image,
                              onEdit: () {
                                Get.toNamed(
                                  AppRoutes.sellerEditProduct,
                                  arguments: product.id,
                                );
                              },
                              onDelete: () {
                                DeleteProductDialog.show(
                                  productName: product.title,
                                  onConfirm: () {
                                    controller.deleteProduct(product.id);
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
