import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/product_discount_ext.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      body: Column(
        children: [
          SellerDesktopHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeroSection(theme),
                  AppSize.p20.height,
                  _buildProductsGrid(theme, primaryColor),
                ],
              ),
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
          margin: const EdgeInsets.only(bottom: 50),
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
        const Positioned(bottom: 0, child: SellerDesktopStatsCard()),
      ],
    );
  }

  Widget _buildProductsGrid(ThemeData theme, Color primaryColor) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.all(AppSize.p32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(theme, primaryColor),
          AppSize.p20.height,
          Obx(() {
            if (controller.productsState.value == CurrentState.loading) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 450,
                  mainAxisExtent: 140,
                  crossAxisSpacing: AppSize.p20,
                  mainAxisSpacing: AppSize.p20,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return SellerProductCardShimmer();
                },
              );
            }
            if (controller.productsState.value == CurrentState.error) {
              return ErrorView(onRetry: () => controller.fetchProducts());
            }

            if (controller.products.isEmpty) {
              return EmptyWidget();
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450,
                mainAxisExtent: 140,
                crossAxisSpacing: AppSize.p20,
                mainAxisSpacing: AppSize.p20,
              ),
              itemCount: controller.filteredProducts.length,
              itemBuilder: (context, index) {
                return SellerProductCard(
                  productName: controller.filteredProducts[index].title,
                  originalPrice:
                      controller.filteredProducts[index].price.toString(),
                  discountedPrice:
                      controller.filteredProducts[index].discountPrice
                          .toString(),
                  discountPercent:
                      controller.filteredProducts[index].discountPercentString,
                  imagePath: controller.filteredProducts[index].image,
                  quantity: controller.filteredProducts[index].quantity,
                  onEdit: () {},
                  onDelete: () {},
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, Color primaryColor) {
    return Row(
      children: [
        Icon(Icons.inventory_2_outlined, color: primaryColor, size: 28),
        AppSize.p10.width,
        Text(
          'لیست محصولات فروشگاه',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
