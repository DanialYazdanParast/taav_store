import 'package:example/src/commons/extensions/ext.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/buyer_products_controller.dart';

class FilterColors extends StatelessWidget {
  final BuyerProductsController controller;

  const FilterColors(this.controller, {super.key});

  static const double size = 45;

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final text = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          TKeys.colors.tr,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                controller.availableColors.map((color) {
                  final isSelected = controller.tempColorHexes.contains(
                    color.hex,
                  );

                  return GestureDetector(
                    onTap: () => controller.toggleTempColor(color.hex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: color.hex.toColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? colors.primary : colors.outline,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child:
                          isSelected
                              ? Icon(
                                Icons.check,
                                color: _contrast(
                                  color.hex.toColor,
                                ),
                              )
                              : null,
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Color _contrast(Color c) {
    return c.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
