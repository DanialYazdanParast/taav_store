import 'package:example/src/commons/utils/toast_util.dart';

import 'package:example/src/commons/widgets/bottom_sheet.dart';
import 'package:example/src/commons/widgets/dialog_widget.dart';

import 'package:example/src/commons/widgets/text/app_search_field.dart';
import 'package:example/src/commons/widgets/text/app_text_field.dart';
import 'package:example/src/pages/seller/account/widgets/seller_ui_components.dart';

import 'package:example/src/pages/shared/controllers/mixin_dialog_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/pages/shared/widgets/seller_icon_button.dart';

class SellerAddAndEditDialogs {
  SellerAddAndEditDialogs._();

  static void _show(Widget content, {bool isScrollControlled = false}) {
    if (Responsive.isMobile) {
      BottomSheetWidget(isScrollControlled: isScrollControlled).show(
        Padding(
          padding: const EdgeInsets.only(
            left: AppSize.p16,
            right: AppSize.p16,
            bottom: AppSize.p16,
          ),
          child: content,
        ),
      );
    } else {
      DialogWidget(maxWidth: 750).show(content);
    }
  }

  static void showTags(MixinDialogController controller) {
    controller.tagSearchController.clear();
    controller.tagQuery.value = '';
    controller.filteredTags.clear();

    _show(
      Padding(
        padding: EdgeInsets.only(
          bottom:
              Responsive.isMobile
                  ? MediaQuery.of(Get.context!).viewInsets.bottom
                  : 0,
        ),
        child: SizedBox(
          height: Get.height * 0.45,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PopupTitleWidget("مدیریت تگ‌ها"),
                  SellerIconButton(
                    icon: Icons.close,
                    onTap: () => Get.back(),
                    bgColor: Colors.grey.withOpacity(0.1),
                    color: Get.theme.colorScheme.onSurface,
                    size: 20,
                  ),
                ],
              ),
              AppSize.p12.height,

              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: AppSearchField(
                        controller: controller.tagSearchController,
                        hintText: "جستجوی تگ...",
                        onChanged: controller.onTagSearchChanged,
                        prefixWidget: const Icon(Icons.search),
                      ),
                    ),
                    if (controller.showAddButton) ...[
                      AppSize.p8.width,
                      InkWell(
                        onTap:
                            controller.isAddingTag.value
                                ? null
                                : controller.addNewTag,
                        borderRadius: BorderRadius.circular(AppSize.r12),
                        child: Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: Get.theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(AppSize.r12),
                          ),
                          child:
                              controller.isAddingTag.value
                                  ? const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  )
                                  : const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              AppSize.p12.height,

              // Tags List
              Expanded(
                child: Obx(() {
                  if (controller.tagQuery.value.isNotEmpty) {
                    if (controller.filteredTags.isEmpty) {
                      return Center(
                        child: Text(
                          "تگی یافت نشد",
                          style: TextStyle(color: Get.theme.disabledColor),
                        ),
                      );
                    }
                    return _buildTagsList(controller, controller.filteredTags);
                  }

                  if (controller.selectedTagNames.isNotEmpty) {
                    final selectedTags =
                        controller.availableTags
                            .where(
                              (tag) => controller.selectedTagNames.contains(
                                tag.name,
                              ),
                            )
                            .toList();
                    return _buildTagsList(controller, selectedTags);
                  }

                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_rounded,
                          size: 48,
                          color: Get.theme.disabledColor.withOpacity(0.5),
                        ),
                        AppSize.p8.height,
                        Text(
                          "نام تگ را جستجو کنید",
                          style: TextStyle(color: Get.theme.disabledColor),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              AppSize.p12.height,

              ButtonWidget("تایید و بستن", () => Get.back()).material(),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Widget _buildTagsList(
    MixinDialogController controller,
    List<dynamic> tags,
  ) {
    return ListView.separated(
      itemCount: tags.length,
      separatorBuilder: (_, __) => AppSize.p8.height,
      itemBuilder: (context, index) {
        final tag = tags[index];
        return Obx(() {
          final isSelected = controller.selectedTagNames.contains(tag.name);
          return SelectableOptionWidget(
            title: tag.name,
            isSelected: isSelected,
            icon: Icons.label_outline_rounded,
            onTap: () {
              if (isSelected) {
                controller.removeTag(tag.name);
              } else {
                controller.selectTag(tag.name);
              }
            },
          );
        });
      },
    );
  }

  static void showAddColor(MixinDialogController controller) {
    final nameCtrl = TextEditingController();
    final FocusNode nameFocus = FocusNode();
    final Rx<Color> pickerColor = Get.theme.colorScheme.primary.obs;

    _show(
      Padding(
        padding: EdgeInsets.only(
          bottom:
              Responsive.isMobile
                  ? MediaQuery.of(Get.context!).viewInsets.bottom
                  : 0,
        ),
        child: SizedBox(
          height: Get.height * 0.45,
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const PopupTitleWidget("افزودن رنگ جدید"),
                  SellerIconButton(
                    icon: Icons.close,
                    onTap: () => Get.back(),
                    bgColor: Colors.grey.withOpacity(0.1),
                    color: Get.theme.colorScheme.onSurface,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: nameCtrl,
                        focusNode: nameFocus,
                        hintText: "نام رنگ (مثلاً: قرمز یاقوتی)",
                        prefixWidget: const Icon(Icons.format_color_text),
                      ),
                      const SizedBox(height: 16),
                      ColorPicker(
                        pickerColor: pickerColor.value,
                        onColorChanged:
                            (Color color) => pickerColor.value = color,
                        pickerAreaHeightPercent: 0.4,
                        enableAlpha: false,
                        displayThumbColor: true,
                        paletteType: PaletteType.hsvWithHue,
                        labelTypes: const [],
                        pickerAreaBorderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                ),
              ),

              // Add Button
              Obx(
                () =>
                    ButtonWidget(
                      "تایید و افزودن",
                      () {
                        nameFocus.unfocus();
                        if (nameCtrl.text.isNotEmpty) {
                          String hexCode =
                              '#${pickerColor.value.value.toRadixString(16).substring(2).toUpperCase()}';
                          controller.addNewColor(nameCtrl.text, hexCode);
                        } else {
                          ToastUtil.show(
                            "لطفاً نام رنگ را وارد کنید",
                            type: ToastType.warning,
                          );
                        }
                      },
                      isLoading: controller.isAddingColor.value,
                      bgColor: pickerColor.value,
                      textColor:
                          pickerColor.value.computeLuminance() > 0.5
                              ? Colors.black
                              : Colors.white,
                    ).material(),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }


  static void showImageSource(MixinDialogController controller) {
    _show(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const PopupTitleWidget("انتخاب تصویر محصول"),
              SellerIconButton(
                icon: Icons.close,
                onTap: () => Get.back(),
                bgColor: Colors.grey.withOpacity(0.1),
                color: Get.theme.colorScheme.onSurface,
                size: 20,
              ),
            ],
          ),
          AppSize.p32.height,

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildSourceOption(
                  icon: Icons.camera_alt_rounded,
                  label: "دوربین",
                  color: Colors.blueAccent,
                  onTap: () {
                    Get.back();
                    controller.pickImageFromCamera();
                  },
                ),
              ),
              AppSize.p32.width,
              Expanded(
                child: _buildSourceOption(
                  icon: Icons.photo_library_rounded,
                  label: "گالری تصاویر",
                  color: Colors.purpleAccent,
                  onTap: () {
                    Get.back();
                    controller.pickImageFromGallery();
                  },
                ),
              ),
            ],
          ),
          AppSize.p16.height,
        ],
      ),
    );
  }

  static Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.r20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSize.r20),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            AppSize.p16.height,
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withOpacity(0.8),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
