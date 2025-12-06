import 'package:example/src/pages/seller/account/widgets/seller_ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/pages/shared/models/color_model.dart';

class ProductAttributesSection extends StatelessWidget {
  // لیست‌ها (RxList برای اینکه Obx کار کند)
  final List<ColorModel> availableColors;
  final List<String> selectedColorNames;
  final List<String> selectedTagNames;

  // توابع (Callbacks)
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
        SettingsMenuItem(
          onTap: () {},
          title: "ویژگی‌ها",
          color: theme.colorScheme.primary,
          icon: Icons.tune_rounded,
          padding: EdgeInsets.zero,
          iconSize: 20,
          iconContainerSize: 40,
          showChevron: false,
        ),
        AppSize.p16.height,
        Text(
          "رنگ‌ها",
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
                final isSelected = selectedColorNames.contains(color.name);
                return GestureDetector(
                  onTap: () => onToggleColor(color.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color.colorObj,
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
                                  color: theme.colorScheme.primary.withOpacity(
                                    0.3,
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
                                  color.colorObj.computeLuminance() > 0.5
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
                    color: theme.colorScheme.primary.withOpacity(0.05),
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
          "تگ‌ها",
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
                        color: theme.colorScheme.primary.withOpacity(0.2),
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
                    color: theme.colorScheme.primary.withOpacity(0.05),
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
                        "افزودن",
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
