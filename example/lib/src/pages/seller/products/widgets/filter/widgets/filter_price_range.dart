import 'package:example/src/commons/utils/formatters/number_formatter.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerFilterPriceRange extends StatelessWidget {
  final SellerProductsController controller;

  const SellerFilterPriceRange(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final text = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TKeys.priceRange.tr,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final min = controller.minPriceLimit.value;
          final max =
              controller.maxPriceLimit.value <= min
                  ? min + 1000
                  : controller.maxPriceLimit.value;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(
                    colors,
                    text,
                    FormatUtil.currency(controller.tempPriceRange.value.start),
                  ),
                  _label(
                    colors,
                    text,
                    FormatUtil.currency(controller.tempPriceRange.value.end),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: colors.primary,
                  inactiveTrackColor: colors.surfaceContainerHighest,
                  thumbColor: colors.primary,
                ),
                child: RangeSlider(
                  values: controller.tempPriceRange.value,
                  min: min,
                  max: max,
                  onChanged: controller.updateTempPriceRange,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _label(ColorScheme colors, TextTheme text, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        "$value ${TKeys.currency.tr}",
        style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}
