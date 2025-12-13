import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/main/controllers/main_buyer_controller.dart';
import 'package:example/src/pages/shared/widgets/header_sheet.dart';
import 'package:example/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:example/src/pages/shared/widgets/custom_badge.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_product_details_controller.dart';
import '../widgets/product_image_widget.dart';
import '../widgets/color_selector_widget.dart';
import '../widgets/product_action_bar_widget.dart';

class MobileProductLayout extends GetView<BuyerProductDetailsController> {
  const MobileProductLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          ProductImageWidget(height: screenHeight * 0.45, width: screenWidth),
          _buildTopBar(context, theme),
          _buildBottomSheet(theme),
          _buildBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeData theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSize.p10,
      left: AppSize.p16,
      right: AppSize.p16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButtonWidget(
            icon: Icons.arrow_back,
            onTap: () => Get.back(),
            bgColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
            color: theme.iconTheme.color,
            hasBorder: true,
            size: 20,
          ),
          Obx(() {
            final count = controller.cartController.totalCount;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButtonWidget(
                  icon: Icons.shopping_cart_outlined,
                  onTap: () {
                    final mainBuyerController = Get.find<MainBuyerController>();
                    Get.back();
                    mainBuyerController.changeTab(1);
                  },
                  bgColor: theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
                  color: theme.iconTheme.color,
                  hasBorder: true,
                  size: 20,
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: CustomBadge(badgeCount: count, fontSize: 10, paddingHorizontal: 5, paddingVertical: 2, radius: 12),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomSheet(ThemeData theme) {
    return SafeArea(
      bottom: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.65,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSize.r12)),
              boxShadow: [BoxShadow(color: theme.shadowColor.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Obx(() {
              if (controller.productState.value != CurrentState.success) {
                return const Center(child: CircularProgressIndicator());
              }
              final product = controller.product.value!;

              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(AppSize.p20, 0, AppSize.p20, 100),
                children: [
                  const SizedBox(height: AppSize.p12),
                  const Center(child: HeaderSheet()),
                  const SizedBox(height: AppSize.p16),

                  if (product.tags.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSize.p8),
                      child: Text(product.tags.join(" / "), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
                    ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSize.p24),
                    child: Text(product.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, height: 1.4)),
                  ),

                  const ColorSelectorWidget(),
                  const SizedBox(height: AppSize.p24),

                  Text(TKeys.productDescription.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSize.p8),
                  Text(product.description, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16, height: 1.6)),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.p16, vertical: AppSize.p12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [BoxShadow(color: theme.shadowColor.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, -5))],
          border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 60,
            child: const ProductActionBarWidget(isDesktop: false),
          ),
        ),
      ),
    );
  }
}