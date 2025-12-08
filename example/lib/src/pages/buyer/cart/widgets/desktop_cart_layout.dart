import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../widgets/cart_item_widget.dart';

class DesktopCartLayout extends GetView<CartController> {
  const DesktopCartLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(TKeys.cartTitle.tr)),
      body: Obx(() {
        if (controller.cartState.value == CurrentState.loading) {
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: 3,
            separatorBuilder: (_, __) => AppDivider.horizontal(space: 40),
            itemBuilder: (context, index) {
              return CartItemShimmer();
            },
          );
        } else if (controller.cartState.value == CurrentState.error) {
          return ErrorView();
        } else if (controller.cartItems.isEmpty) {
          return EmptyWidget(title: TKeys.cartEmpty.tr,);
        }
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(24),
                        itemCount: controller.cartItems.length,
                        separatorBuilder:
                            (_, __) => AppDivider.horizontal(space: 40),
                        itemBuilder: (context, index) {
                          return CartItemWidget(
                            item: controller.cartItems[index],
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 32),

                  Expanded(flex: 3, child: _buildOrderSummary(theme)),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOrderSummary(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            TKeys.orderSummary.tr,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildSummaryRow(
            "${TKeys.itemsPrice.tr} (${controller.totalCount.toString().toLocalizedDigit} ${controller.totalCount > 1 ? TKeys.items.tr : TKeys.item.tr})",
            controller.totalOriginalPrice.toLocalizedPrice,
          ),
          if (controller.hasDiscount)
            _buildSummaryRow(
              TKeys.yourSavings.tr,
              controller.totalProfit.toLocalizedPrice,
              isDiscount: true,
            ),
          const Divider(height: 32),

          _buildSummaryRow(
            TKeys.cartTotal.tr,
            controller.totalPayablePrice.toLocalizedPrice,
            isTotal: true,
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: () => controller.checkout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              TKeys.confirmAndPay.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
      String title,
      String value, {
        bool isDiscount = false,
        bool isTotal = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: isDiscount ? Colors.red : null,
              fontWeight: isTotal ? FontWeight.bold : null,
            ),
          ),
          Text(
            "$value ${TKeys.toman.tr}",
            style: TextStyle(
              color: isDiscount ? Colors.red : null,
              fontWeight: isTotal ? FontWeight.bold : null,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}