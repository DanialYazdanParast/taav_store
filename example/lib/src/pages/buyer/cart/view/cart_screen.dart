import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:example/src/pages/buyer/product_details/widgets/advanced_count_control.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:example/src/commons/constants/app_size.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class CartScreen extends GetView<CartController> {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "سبد خرید",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: Obx(() {

        if (controller.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: AppSize.f72 + 8,
                  color: theme.disabledColor,
                ),
                const SizedBox(height: AppSize.p16),
                Text(
                  "سبد خرید شما خالی است",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: AppSize.f16,
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.p16,
                  AppSize.p16,
                  AppSize.p16,
                  AppSize.p20,
                ),
                itemCount: controller.cartItems.length,
                separatorBuilder: (_, __) => AppDivider.horizontal(space: 30),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return _buildCartItemRow(item, theme);
                },
              ),
            ),

            _buildFixedBottomBar(theme),
          ],
        );
      }),
    );
  }

  Widget _buildCartItemRow(CartItemModel item, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            borderRadius: AppSize.brCircular(AppSize.r12),
            color: Colors.grey.shade100,
            image: DecorationImage(
              image: NetworkImage(item.productImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: AppSize.p12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.productTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.f14,
                ),
              ),
              const SizedBox(height: AppSize.p6),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: _parseColor(item.colorHex),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                  const SizedBox(width: AppSize.p6),
                  Text(
                    "رنگ انتخابی",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                      fontSize: AppSize.f12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.p12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_formatPrice(item.totalPrice)} تومان",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.f14,
                    ),
                  ),

                  _buildQuantityControl(item, theme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityControl(CartItemModel item, ThemeData theme) {
    return Obx(() {
      int dynamicMaxQuantity = controller.getMaxAllowedQuantity(item);

      return AdvancedCountControl(
        currentQuantity: item.quantity,
        maxQuantity: dynamicMaxQuantity,
        onIncrease: () {
          if (item.quantity < dynamicMaxQuantity) {
            controller.incrementItem(item);
          } else {
            Get.snackbar(
              "محدودیت",
              "موجودی انبار تکمیل شده است",
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.all(AppSize.p16),
              duration: const Duration(seconds: 2),
            );
          }
        },
        onDecrease: () => controller.decrementItem(item),
        showAddButton: false,
        height: 40,
        width: 130,
        style: CountControlStyle(
          primaryColor: theme.colorScheme.primary,
          backgroundColor: theme.scaffoldBackgroundColor,
          contentColor: theme.iconTheme.color ?? Colors.black,
          borderSide: BorderSide(color: theme.dividerColor),
          borderRadius: AppSize.r8,
          textStyle: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: AppSize.f14,
          ),
        ),
        numberFormatter: _toPersianNum,
      );
    });
  }

  Widget _buildFixedBottomBar(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p16, vertical: AppSize.p12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,

        border: Border(top: BorderSide(color: theme.dividerColor, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => controller.checkout(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSize.r10)),
                      elevation: 0,
                    ),
                    child: Text(
                      "ثبت سفارش",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: AppSize.p16),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (controller.hasDiscount)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "سود شما: ",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.f12,
                              ),
                            ),
                            Text(
                              _formatPrice(controller.totalProfit),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.bold,
                                fontSize: AppSize.f12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatPrice(controller.totalOriginalPrice),
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: theme.disabledColor,
                                fontSize: AppSize.f12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        Text(
                          _formatPrice(controller.totalPayablePrice),
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSize.f18,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "تومان",
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: AppSize.f10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      String hexString = hex.replaceAll('#', '');
      if (hexString.length == 6) hexString = 'FF$hexString';
      return Color(int.parse('0x$hexString'));
    } catch (e) {
      return Colors.transparent;
    }
  }

  String _formatPrice(num price) {
    final formatter = NumberFormat("#,###");
    return _toPersianNum(formatter.format(price));
  }

  String _toPersianNum(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], persian[i]);
    }
    return input;
  }
}
