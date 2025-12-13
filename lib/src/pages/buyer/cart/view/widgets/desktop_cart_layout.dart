import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/Empty_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/button/button_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/divider_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/error_view.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/cart_controller.dart';
import 'cart_item_widget.dart';

class DesktopCartLayout extends GetView<CartController> {
  const DesktopCartLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Obx(() {
        if (controller.cartState.value == CurrentState.loading) {
          return _buildLoadingState();
        } else if (controller.cartState.value == CurrentState.error) {
          return const Center(child: ErrorView());
        } else if (controller.cartItems.isEmpty) {
          return Center(child: EmptyWidget(title: TKeys.cartEmpty.tr));
        }
        return _buildCartContent(theme);
      }),
    );
  }

  Widget _buildLoadingState() {
    return ListView.separated(
      padding: EdgeInsets.all(AppSize.p24),
      itemCount: 3,
      separatorBuilder: (_, __) => AppSize.p16.height,
      itemBuilder: (_, __) => const CartItemShimmer(),
    );
  }

  Widget _buildCartContent(ThemeData theme) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: EdgeInsets.all(AppSize.p16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildCartItemsSection(theme)),
                AppSize.p32.width,
                Expanded(flex: 1, child: _buildOrderSummarySection(theme)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItemsSection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSize.p24),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSize.r16),
                topRight: Radius.circular(AppSize.r16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
                AppSize.p12.width,
                Flexible(
                  child: Text(
                    TKeys.cartTitle.tr,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AppSize.p8.width,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.p12,
                    vertical: AppSize.p4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppSize.brCircular(20),
                  ),
                  child: Text(
                    controller.totalCount.toString().toLocalizedDigit,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          AppDivider.horizontal(
            space: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSize.p24),
            itemCount: controller.cartItems.length,
            separatorBuilder:
                (_, __) => AppDivider.horizontal(space: AppSize.p24),
            itemBuilder: (context, index) {
              return CartItemWidget(item: controller.cartItems[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummarySection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppSize.brCircular(AppSize.r16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildOrderSummaryHeader(theme),
          Padding(
            padding: EdgeInsets.all(AppSize.p24),
            child: Column(
              children: [
                _buildSummaryRow(
                  theme,
                  icon: Icons.inventory_2_outlined,
                  title: TKeys.itemsPrice.tr,
                  subtitle:
                      "(${controller.totalCount.toString().toLocalizedDigit} ${controller.totalCount > 1 ? TKeys.items.tr : TKeys.item.tr})",
                  value: controller.totalOriginalPrice.toLocalizedPrice,
                ),
                if (controller.hasDiscount) ...[
                  AppSize.p16.height,
                  _buildDiscountRow(
                    theme,
                    title: TKeys.yourSavings.tr,
                    value: controller.totalProfit.toLocalizedPrice,
                  ),
                ],

                AppSize.p24.height,
                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.outlineVariant.withValues(alpha: 0),
                        theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                        theme.colorScheme.outlineVariant.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
                AppSize.p24.height,

                _buildTotalRow(
                  theme,
                  title: TKeys.cartTotal.tr,
                  value: controller.totalPayablePrice.toLocalizedPrice,
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSize.p24,
              0,
              AppSize.p24,
              AppSize.p24,
            ),
            child: Obx(
              () =>
                  ButtonWidget(
                    TKeys.confirmAndPay.tr,
                    () => controller.checkout(),

                    isLoading:
                        controller.cartCheckout.value == CurrentState.loading,
                  ).material(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderSummaryHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(AppSize.p24),
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.r16),
          topRight: Radius.circular(AppSize.r16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Icon(
            Icons.receipt_long_outlined,
            color: theme.colorScheme.primary,
            size: AppSize.f24,
          ),
          AppSize.p12.width,
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                TKeys.orderSummary.tr,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    ThemeData theme, {
    required IconData icon,
    required String title,
    String? subtitle,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(AppSize.p8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppSize.brCircular(AppSize.r8),
                  ),
                  child: Icon(icon, size: 18, color: theme.colorScheme.primary),
                ),
                AppSize.p12.width,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        AppSize.p8.width,
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "$value ${TKeys.toman.tr}",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountRow(
    ThemeData theme, {
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: AppSize.brCircular(AppSize.r12),
        border: Border.all(
          color: Colors.green.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(AppSize.p6),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: AppSize.brCircular(AppSize.r6),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                  AppSize.p12.width,
                  Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  AppSize.p8.width,
                  Text(
                    "$value ${TKeys.toman.tr}",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(
    ThemeData theme, {
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: AppSize.brCircular(AppSize.r12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          AppSize.p8.width,
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "$value ${TKeys.toman.tr}",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
