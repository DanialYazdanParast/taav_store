import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerFilterColors extends StatelessWidget {
  final SellerProductsController controller;

  const SellerFilterColors(this.controller, {super.key});

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
                  final isSelected = controller.tempColorNames.contains(
                    color.name,
                  );

                  return GestureDetector(
                    onTap: () => controller.toggleTempColor(color.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: color.colorObj,
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
                                color: _contrast(color.colorObj),
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
