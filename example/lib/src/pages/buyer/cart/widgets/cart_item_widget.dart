import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class CartItemWidget extends GetView<CartController> {
  final CartItemModel item;

  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عکس محصول
        TaavNetworkImage(
          item.productImage,
          width: 90,
          height: 90,
          borderRadius: 12,
          fit: BoxFit.cover,
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
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

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
                  const SizedBox(width: 6),
                  Text("رنگ انتخابی", style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${_formatPrice(item.totalPrice)} تومان",
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
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
    int dynamicMaxQuantity = controller.getMaxAllowedQuantity(item);

    return AdvancedCountControl(
      currentQuantity: item.quantity,
      maxQuantity: dynamicMaxQuantity,
      onIncrease: () {
        if (item.quantity < dynamicMaxQuantity) {
          controller.incrementItem(item);
        } else {
          Get.snackbar("محدودیت", "موجودی انبار تکمیل شده است", snackPosition: SnackPosition.BOTTOM);
        }
      },
      onDecrease: () => controller.decrementItem(item),
      showAddButton: false,
      height: 36,
      width: 120,
      style: CountControlStyle(
        primaryColor: theme.colorScheme.primary,
        backgroundColor: theme.scaffoldBackgroundColor,
        contentColor: theme.iconTheme.color ?? Colors.black,
        borderSide: BorderSide(color: theme.dividerColor),
        borderRadius: 8,
        textStyle: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
      numberFormatter: _toPersianNum,
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