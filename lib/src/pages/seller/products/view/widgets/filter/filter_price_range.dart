import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/utils/formatters/number_formatter.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';
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
          LocaleKeys.priceRange.tr,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final double min = controller.minPriceLimit.value;
          final double max = controller.maxPriceLimit.value;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(
                    colors,
                    text,
                    controller.tempPriceRange.value.start.toLocalizedPrice,
                  ),
                  _label(
                    colors,
                    text,
                    controller.tempPriceRange.value.end.toLocalizedPrice,
                  ),
                ],
              ),
              RangeSlider(
                values: controller.tempPriceRange.value,
                min: min,
                max: max,
                onChanged: (values) {
                  final newStart = values.start.clamp(min, max);
                  final newEnd = values.end.clamp(min, max);
                  controller.updateTempPriceRange(
                    RangeValues(newStart, newEnd),
                  );
                },
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
        "$value ${LocaleKeys.currency.tr}",
        style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}
