import 'package:taav_store/src/commons/extensions/ext.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/pages/shared/models/color_model.dart';

class ProductAttributesSection extends StatelessWidget {
  final List<ColorModel> availableColors;
  final List<String> selectedColorNames;
  final List<String> selectedTagNames;

  final Function(String) onToggleColor;
  final Function(String) onRemoveTag;
  final VoidCallback onAddColorTap;
  final VoidCallback onAddTagTap;

  const ProductAttributesSection({
    super.key,
    required this.availableColors,
    required this.selectedColorNames,
    required this.selectedTagNames,
    required this.onToggleColor,
    required this.onRemoveTag,
    required this.onAddColorTap,
    required this.onAddTagTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 30,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppSize.r12),
              ),
            ),
            8.width,
            Text(
              TKeys.attributes.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSize.f16,
                color: Get.theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        AppSize.p16.height,
        Text(
          TKeys.colors.tr,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        AppSize.p8.height,

        Obx(
          () => Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...availableColors.map((color) {
                final isSelected = selectedColorNames.contains(color.hex);
                return GestureDetector(
                  onTap: () => onToggleColor(color.hex),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.hex.toColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSelected
                                ? theme.colorScheme.primary
                                : theme.dividerColor,
                        width: isSelected ? 3 : 1.5,
                      ),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : null,
                    ),
                    child:
                        isSelected
                            ? Icon(
                              Icons.check,
                              size: 20,
                              color:
                                  color.hex.toColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                            )
                            : null,
                  ),
                );
              }),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onAddColorTap();
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: theme.colorScheme.primary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
        ),

        AppSize.p20.height,
        Text(
          TKeys.tags.tr,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
        AppSize.p8.height,

        Obx(
          () => Wrap(
            spacing: AppSize.p8,
            runSpacing: AppSize.p8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...selectedTagNames.map(
                (tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(AppSize.r20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      InkWell(
                        onTap: () => onRemoveTag(tag),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  FocusScope.of(context).unfocus();
                  onAddTagTap();
                },
                borderRadius: BorderRadius.circular(AppSize.r20),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.primary),
                    borderRadius: BorderRadius.circular(AppSize.r20),
                    color: theme.colorScheme.primary.withValues(alpha: 0.05),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        TKeys.add.tr,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
