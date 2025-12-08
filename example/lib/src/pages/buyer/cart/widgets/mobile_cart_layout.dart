import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/widgets/custom_app_bar.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import '../widgets/cart_item_widget.dart';

class MobileCartLayout extends GetView<CartController> {
  const MobileCartLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: TKeys.orderHistory.tr, showBackButton: false),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return _buildEmptyState(theme);
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => AppDivider.horizontal(space: 30),
                itemBuilder: (context, index) {
                  return CartItemWidget(item: controller.cartItems[index]);
                },
              ),
            ),
            _buildBottomBar(theme),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.disabledColor,
          ),
          const SizedBox(height: 16),
          Text(TKeys.cartEmpty.tr, style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () => controller.checkout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    TKeys.submitOrder.tr,
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildPriceInfo(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInfo(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (controller.hasDiscount)
          Text(
            "${TKeys.yourProfit.tr}: ${controller.totalProfit.toLocalizedPrice}",
            style: TextStyle(
              color: theme.colorScheme.error,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              controller.totalPayablePrice.toLocalizedPrice,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 4),
            Text(
              TKeys.toman.tr,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}