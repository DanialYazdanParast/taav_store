import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/enums/enums.dart';
import 'package:taav_store/src/commons/extensions/ext.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/Empty_widget.dart';
import 'package:taav_store/src/commons/widgets/button/button_widget.dart';
import 'package:taav_store/src/commons/widgets/custom_app_bar.dart';
import 'package:taav_store/src/commons/widgets/divider_widget.dart';
import 'package:taav_store/src/commons/widgets/error_view.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';
import 'cart_item_widget.dart';

class MobileCartLayout extends GetView<CartController> {
  const MobileCartLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(title: TKeys.orderHistory.tr, showBackButton: false),
      body: Obx(() {
        if (controller.cartState.value == CurrentState.loading) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppSize.p16),
            itemCount: 3,
            separatorBuilder: (_, __) => AppDivider.horizontal(space: 30),
            itemBuilder: (context, index) {
              return CartItemShimmer();
            },
          );
        } else if (controller.cartState.value == CurrentState.error) {
          return ErrorView();
        } else if (controller.cartItems.isEmpty) {
          return _buildEmptyState(theme);
        }
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => controller.loadCart(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cartItems.length,
                  separatorBuilder: (_, __) => AppDivider.horizontal(space: 30),
                  itemBuilder: (context, index) {
                    return CartItemWidget(item: controller.cartItems[index]);
                  },
                ),
              ),
            ),
            _buildBottomBar(theme),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Column(children: [EmptyWidget(title: TKeys.cartEmpty.tr), 2.height]);
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
                child: Obx(
                  () =>
                      ButtonWidget(
                        TKeys.confirmAndPay.tr,
                        () => controller.checkout(),

                        isLoading:
                            controller.cartCheckout.value ==
                            CurrentState.loading,
                      ).material(),
                ),
              ),
              const SizedBox(width: 16),
              Flexible(child: _buildPriceInfo(theme)),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "${TKeys.yourProfit.tr}: ${controller.totalProfit.toLocalizedPrice}",
              style: TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.totalPayablePrice.toLocalizedPrice,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                TKeys.toman.tr,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
