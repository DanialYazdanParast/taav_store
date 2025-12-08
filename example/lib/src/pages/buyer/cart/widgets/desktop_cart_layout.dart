import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
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
      appBar: AppBar(title: const Text("سبد خرید")),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(child: Text("سبد خرید خالی است"));
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
            "خلاصه سفارش",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          _buildSummaryRow(
            "قیمت کالاها (${controller.totalCount.toString().toLocalizedDigit})",
            controller.totalOriginalPrice.toLocalizedPrice,
          ),
          if (controller.hasDiscount)
            _buildSummaryRow(
              "سود شما از خرید",
              controller.totalProfit.toLocalizedPrice,
              isDiscount: true,
            ),
          const Divider(height: 32),

          _buildSummaryRow(
            "جمع سبد خرید",
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
              "تایید و پرداخت",
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
            "$value تومان",
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