import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/product_discount_ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/empty_widget.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/main/controllers/main_buyer_controller.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_products_controller.dart';
import 'buyer_desktop_header.dart';
import 'buyer_product_card.dart';
import 'carousel.dart';

class BuyerDesktopLayout extends GetView<BuyerProductsController> {
  const BuyerDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;
    final mainController = Get.find<MainBuyerController>();
    return Scaffold(
      body: Column(
        children: [
          const BuyerDesktopHeader(),

          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [_buildHeroSection(theme), AppSize.p20.height],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.p32,
                    ),
                    child: _buildSectionTitle(theme, primaryColor),
                  ),
                ),

                Obx(() {
                  if (controller.productsState.value == CurrentState.loading) {
                    return _buildLoadingGrid();
                  }

                  if (controller.productsState.value == CurrentState.error) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ErrorView(
                          onRetry: () => controller.fetchProducts(),
                        ),
                      ),
                    );
                  }

                  if (controller.filteredProducts.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: EmptyWidget(),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.p32,
                      vertical: AppSize.p20,
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 400,
                            mainAxisExtent: 400,
                            crossAxisSpacing: AppSize.p20,
                            mainAxisSpacing: AppSize.p20,
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = controller.filteredProducts[index];
                        return BuyerProductCard(
                          productName: product.title,
                          originalPrice: product.price.toString(),
                          discountedPrice: product.discountPrice.toString(),
                          discountPercent: product.discountPercentString,
                          imagePath: product.image,
                          quantity: product.quantity,
                          size: 250,
                          onTap:
                              () =>
                                  mainController.goToProductDetails(product.id),
                        );
                      }, childCount: controller.filteredProducts.length),
                    ),
                  );
                }),

                SliverPadding(padding: EdgeInsets.only(bottom: AppSize.p32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 180,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 60),
          decoration: BoxDecoration(color: theme.colorScheme.primary),
        ),

        DecorativeCircle(
          top: -150,
          right: -200,
          size: 300,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
        ),
        DecorativeCircle(
          top: -350,
          size: 400,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
        ),
        DecorativeCircle(
          top: -130,
          left: -100,
          size: 300,
          color: theme.colorScheme.onPrimary.withValues(alpha: 0.05),
        ),

        const Positioned(bottom: 0, left: 0, right: 0, child: Carousel()),
      ],
    );
  }

  Widget _buildLoadingGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.p32,
        vertical: AppSize.p20,
      ),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 450,
          mainAxisExtent: 250,
          crossAxisSpacing: AppSize.p20,
          mainAxisSpacing: AppSize.p20,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const BuyerProductCardShimmer(),
          childCount: 6,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, Color primaryColor) {
    return Row(
      children: [
        Icon(Icons.inventory_2_outlined, color: primaryColor, size: 28),
        AppSize.p10.width,
        Text(
          TKeys.shopProductList.tr,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
