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
          final double min = controller.minPriceLimit.value;
          final double max = controller.maxPriceLimit.value;

          // فقط اگر min و max خیلی نزدیک بودن، یه مقدار منطقی اضافه کن
          final double displayMax = max <= min ? min + 100000 : max;

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
              RangeSlider(
                values: controller.tempPriceRange.value,
                min: min,
                max: max, // همیشه max واقعی رو بده
                onChanged: (values) {
                  // اینجا یه محدودیت هوشمند اعمال کن
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
        "$value ${TKeys.currency.tr}",
        style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant),
      ),
    );
  }
}
