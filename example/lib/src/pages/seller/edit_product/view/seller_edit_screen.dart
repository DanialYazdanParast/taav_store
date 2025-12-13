import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/pages/shared/widgets/seller_add_and_edit_dialogs.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/pages/shared/widgets/icon_button_widget.dart';

import '../controllers/seller_edit_controller.dart';
import '../widgets/product_attributes_section.dart';
import '../widgets/product_image_section.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_pricing_section.dart';

class SellerEditScreen extends GetView<SellerEditController> {
  const SellerEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _SellerEditMobileLayout(controller: controller),
      desktop: _SellerEditDesktopLayout(controller: controller),
    );
  }
}

class _SellerEditMobileLayout extends StatelessWidget {
  final SellerEditController controller;

  const _SellerEditMobileLayout({required this.controller});

  void _handleImagePick(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (kIsWeb) {
      controller.pickImageFromGallery();
    } else {
      SellerAddAndEditDialogs.showImageSource(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: primaryColor,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _CustomAppBar(isDesktop: false),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppSize.r12)),
                  ),
                  child: Obx(() {
                    switch (controller.pageState.value) {
                      case CurrentState.loading:
                        return const Center(child: CircularProgressIndicator());
                      case CurrentState.error:
                        return ErrorView(onRetry: () => controller.fetchInitialData());
                      case CurrentState.success:
                        return _buildFormContent(context, theme);
                      default:
                        return const SizedBox();
                    }
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(AppSize.p20, AppSize.p24, AppSize.p20, AppSize.p32),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            Obx(
                  () => ProductImageSection(
                selectedImage: controller.selectedImage.value,
                existingImageUrl: controller.isImageDeleted.value
                    ? null
                    : controller.product?.image,
                onTapPick: () => _handleImagePick(context),
                onTapRemove: controller.removeImage,
              ),
            ),
            AppSize.p24.height,
            ProductInfoSection(
              titleController: controller.titleController,
              descController: controller.descController,
              titleFocus: controller.titleFocus,
              descFocus: controller.descFocus,
              autoValidateMode: controller.avmEdit.value,
            ),
            AppSize.p24.height,
            ProductPricingSection(
              priceController: controller.priceController,
              countController: controller.countController,
              discountController: controller.discountPriceController,
              priceFocus: controller.priceFocus,
              countFocus: controller.countFocus,
              discountFocus: controller.discountFocus,
              autoValidateMode: controller.avmEdit.value,
            ),
            AppSize.p24.height,
            ProductAttributesSection(
              availableColors: controller.availableColors,
              selectedColorNames: controller.selectedColor,
              selectedTagNames: controller.selectedTagNames,
              onToggleColor: controller.toggleColor,
              onRemoveTag: controller.removeTag,
              onAddColorTap: () => SellerAddAndEditDialogs.showAddColor(controller),
              onAddTagTap: () => SellerAddAndEditDialogs.showTags(controller),
            ),
            AppSize.p32.height,
            _SubmitButton(controller: controller),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }
}

class _SellerEditDesktopLayout extends StatelessWidget {
  final SellerEditController controller;

  const _SellerEditDesktopLayout({required this.controller});

  void _handleImagePick(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (kIsWeb) {
      controller.pickImageFromGallery();
    } else {
      SellerAddAndEditDialogs.showImageSource(controller);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            padding: const EdgeInsets.only(bottom: AppSize.p16),
            child: Column(
              children: [
                _CustomAppBar(isDesktop: true, theme: theme),
                AppSize.p20.height,
                Expanded(
                  child: Card(
                    color: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      side: BorderSide(
                        width: 1.0,
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Obx(() {
                      if (controller.pageState.value == CurrentState.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.pageState.value == CurrentState.error) {
                        return Center(child: ErrorView(onRetry: () => controller.fetchInitialData()));
                      }
                      return _buildDesktopContent(context, theme);
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopContent(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.p32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Scrollbar(
              controller: controller.leftScrollController,
              child: SingleChildScrollView(
              controller: controller.leftScrollController,
                padding: const EdgeInsetsDirectional.only(end: AppSize.p32),
                child: Column(
                  children: [
                    Obx(
                          () => ProductImageSection(
                            selectedImage: controller.selectedImage.value,
                            existingImageUrl: controller.isImageDeleted.value
                                ? null
                                : controller.product?.image,
                        onTapPick: () => _handleImagePick(context),
                        onTapRemove: controller.removeImage,
                      ),
                    ),
                    AppSize.p24.height,
                    ProductAttributesSection(
                      availableColors: controller.availableColors,
                      selectedColorNames: controller.selectedColor,
                      selectedTagNames: controller.selectedTagNames,
                      onToggleColor: controller.toggleColor,
                      onRemoveTag: controller.removeTag,
                      onAddColorTap: () => SellerAddAndEditDialogs.showAddColor(controller),
                      onAddTagTap: () => SellerAddAndEditDialogs.showTags(controller),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 50,
            child: Center(
              child: Container(
                height: 700,
                width: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.outlineVariant.withOpacity(0),
                      theme.colorScheme.outlineVariant,
                      theme.colorScheme.outlineVariant.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    ProductInfoSection(
                      titleController: controller.titleController,
                      descController: controller.descController,
                      titleFocus: controller.titleFocus,
                      descFocus: controller.descFocus,
                      autoValidateMode: controller.avmEdit.value,
                    ),
                    AppSize.p24.height,
                    ProductPricingSection(
                      priceController: controller.priceController,
                      countController: controller.countController,
                      discountController: controller.discountPriceController,
                      priceFocus: controller.priceFocus,
                      countFocus: controller.countFocus,
                      discountFocus: controller.discountFocus,
                      autoValidateMode: controller.avmEdit.value,
                    ),
                    48.height,
                    _SubmitButton(controller: controller),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final bool isDesktop;
  final ThemeData? theme;

  const _CustomAppBar({required this.isDesktop, this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IconButtonWidget(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              Get.offAllNamed(AppRoutes.sellerProducts);
            },
            bgColor: isDesktop ? Colors.grey.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.2),
            color: isDesktop ? Colors.black : Colors.white,
          ),
        ),
        if (isDesktop) AppSize.p16.width,
        Expanded(
          child: Text(
            TKeys.editProduct.tr,
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              color: isDesktop ? theme?.textTheme.bodyLarge?.color : Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (!isDesktop) const SizedBox(width: 40),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final SellerEditController controller;

  const _SubmitButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => ButtonWidget(
        TKeys.updateProduct.tr,
        controller.updateProduct,
        isLoading: controller.submitState.value == CurrentState.loading,
        icon: Icons.edit_note_rounded,
      ).material(),
    );
  }
}
