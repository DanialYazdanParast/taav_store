import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerFilterAvailability extends StatelessWidget {
  final SellerProductsController controller;

  const SellerFilterAvailability(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final text = context.theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Obx(
        () => SwitchListTile(
          title: Text(
            TKeys.onlyAvailable.tr,
            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          value: controller.tempOnlyAvailable.value,
          onChanged: (v) => controller.tempOnlyAvailable.value = v,
          activeColor: colors.primary,
          inactiveThumbColor: colors.onSurface,
        ),
      ),
    );
  }
}
