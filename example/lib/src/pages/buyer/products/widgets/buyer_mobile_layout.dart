import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/product_discount_ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/empty_widget.dart';
import 'package:example/src/commons/widgets/bottom_sheet.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/pages/buyer/main/controllers/main_buyer_controller.dart';
import 'package:example/src/pages/shared/widgets/animated_app_bar.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import 'package:example/src/pages/shared/widgets/header_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_products_controller.dart';
import 'buyer_filter_view.dart';
import 'buyer_product_card.dart';
import 'carousel.dart';

class BuyerMobileLayout extends GetView<BuyerProductsController> {
  const BuyerMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;
    final screenHeight = Get.height;
    final screenWidth = Get.width;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          controller.closeSearch();
        },

        behavior: HitTestBehavior.translucent,
        child: Stack(
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
      height: 450,
      color: primaryColor,
      child: Stack(
        children: [
          DecorativeCircle(
            top: -80,
            right: -150,
            size: 300,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
          ),
          DecorativeCircle(
            bottom: -10,
            left: -100,
            size: 300,
            color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
          ),
          SafeArea(
            child: Column(
              children: [
                AnimatedAppBar<BuyerProductsController>(
                  screenWidth: Get.width,
                  isSearching: controller.isSearching,
                  searchController: controller.searchController,
                  searchFocusNode: controller.searchFocusNode,
                  title: 'پنل خریدار ',
                  onFilterTap: () {
                    controller.initTempFilters();

                    BottomSheetWidget(
                      isScrollControlled: true,
                    ).show(const BuyerFilterView());
                  },
                ),

                Carousel(),
                AppSize.p20.height,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(ThemeData theme) {
    final mainController = Get.find<MainBuyerController>();
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.60,
        minChildSize: 0.60,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSize.r12),
              ),
            ),
            child: Column(
              children: [
                const HeaderSheet(),

                Obx(() {
                  if (controller.productsState.value == CurrentState.loading) {
                    return Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.60,
                            ),
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.p16,
                          vertical: 8,
                        ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return BuyerProductCardShimmer();
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
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.65,
                            ),
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.p16,
                          vertical: 8,
                        ),
                        itemCount: controller.filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = controller.filteredProducts[index];
                          return BuyerProductCard(
                            productName: product.title,
                            originalPrice: product.price.toString(),
                            discountedPrice: product.discountPrice.toString(),
                            discountPercent: product.discountPercentString,
                            quantity: product.quantity,
                            imagePath: product.image,
                            size: Get.height * 0.15,
                            onTap:
                                () => mainController.goToProductDetails(
                                  product.id,
                                ),
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
    );
  }
}
