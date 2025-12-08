import 'package:example/src/commons/utils/formatters/number_formatter.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/buyer_products_controller.dart';

class FilterPriceRange extends StatelessWidget {
  final BuyerProductsController controller;

  const FilterPriceRange(this.controller, {super.key});

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

          final double safeMax = (max - min).abs() < 1000 ? min + 100000 : max;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _label(colors, text, FormatUtil.currency(min)),
                  _label(colors, text, FormatUtil.currency(safeMax)),
                ],
              ),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: colors.primary,
                  inactiveTrackColor: colors.surfaceContainerHighest,
                  thumbColor: colors.primary,
                  overlayColor: colors.primary.withValues(alpha: 0.2),
                ),
                child: RangeSlider(
                  values: controller.tempPriceRange.value,
                  min: min,
                  max: safeMax,
                  divisions: ((safeMax - min) / 10000).floor().clamp(1, 1000),
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
