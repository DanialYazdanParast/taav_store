import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/buyer_products_controller.dart';

class FilterTags extends StatelessWidget {
  final BuyerProductsController controller;

  const FilterTags(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final text = context.theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(width: double.infinity),
        Text(
          TKeys.tags.tr,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                controller.availableTags.map((tag) {
                  final selected = controller.tempTagNames.contains(tag.name);

                  return GestureDetector(
                    onTap: () => controller.toggleTempTag(tag.name),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected
                                ? colors.primary
                                : colors.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tag.name,
                        style: text.bodyMedium?.copyWith(
                          color:
                              selected
                                  ? colors.onPrimary
                                  : colors.onSurfaceVariant,
                          fontWeight:
                              selected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
