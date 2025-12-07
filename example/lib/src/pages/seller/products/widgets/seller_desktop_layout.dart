import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/product_discount_ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'delete_product_dialog.dart';
import 'seller_desktop_header.dart';
import 'seller_desktop_stats_card.dart';
import 'seller_product_card.dart';

class SellerDesktopLayout extends GetView<SellerProductsController> {
  const SellerDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      body: Padding(
        padding: EdgeInsetsDirectional.only(end: AppSize.p16),
        child: Column(
          children: [
            const SellerDesktopHeader(),

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
                    if (controller.productsState.value ==
                        CurrentState.loading) {
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
                              maxCrossAxisExtent: 450,
                              mainAxisExtent: 140, // ارتفاع ثابت کارت‌ها
                              crossAxisSpacing: AppSize.p20,
                              mainAxisSpacing: AppSize.p20,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final product = controller.filteredProducts[index];
                          return SellerProductCard(
                            productName: product.title,
                            originalPrice: product.price.toString(),
                            discountedPrice: product.discountPrice.toString(),
                            discountPercent: product.discountPercentString,
                            imagePath: product.image,
                            quantity: product.quantity,
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
          color: theme.colorScheme.onPrimary.withOpacity(0.05),
        ),
        DecorativeCircle(
          top: -350,
          size: 400,
          color: theme.colorScheme.onPrimary.withOpacity(0.05),
        ),
        DecorativeCircle(
          top: -130,
          left: -100,
          size: 300,
          color: theme.colorScheme.onPrimary.withOpacity(0.05),
        ),

        const Positioned(
          bottom: 0,
          left: 32,
          right: 32,
          child: SellerDesktopStatsCard(),
        ),
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
          mainAxisExtent: 140,
          crossAxisSpacing: AppSize.p20,
          mainAxisSpacing: AppSize.p20,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => const SellerProductCardShimmer(),
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
