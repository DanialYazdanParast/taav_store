import 'package:taav_store/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/buyer_products_controller.dart';

class FilterAvailability extends StatelessWidget {
  final BuyerProductsController controller;

  const FilterAvailability(this.controller, {super.key});

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
            LocaleKeys.onlyAvailable.tr,
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
