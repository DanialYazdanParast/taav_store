import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/widgets/app_loading.dart';
import 'package:taav_store/src/infrastructure/widgets/error_view.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/shared/widgets/seller_add_and_edit_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/button/button_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:taav_store/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_decorative_circle.dart';

import '../controllers/seller_add_controller.dart';
import 'widgets/product_attributes_section.dart';
import 'widgets/product_info_section.dart';
import 'widgets/product_image_section.dart';
import 'widgets/product_pricing_section.dart';

class SellerAddScreen extends GetView<SellerAddProductController> {
  const SellerAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _SellerAddMobileLayout(controller: controller),
      desktop: _SellerAddDesktopLayout(controller: controller),
    );
  }
}

class _SellerAddMobileLayout extends StatelessWidget {
  final SellerAddProductController controller;

  _SellerAddMobileLayout({required this.controller});

  void _handleImagePick(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (kIsWeb) {
      controller.pickImageFromGallery();
    } else {
      SellerAddAndEditDialogs.showImageSource(controller);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: Stack(
          children: [
            _TopBackground(color: primaryColor),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _CustomAppBar(isDesktop: false),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(AppSize.r12),
                        ),
                      ),

                      child: Obx(() {
                        switch (controller.pageState.value) {
                          case CurrentState.loading:
                            return Center(child: AppLoading.circular(size: 50));
                          case CurrentState.error:
                            return ErrorView();
                          case CurrentState.success:
                            return _buildFormContent(
                              context,
                              theme,
                              controller,
                            );
                          default:
                            return const SizedBox();
                        }
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(
    BuildContext context,
    ThemeData theme,
    SellerAddProductController controller,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSize.p20,
        AppSize.p24,
        AppSize.p20,
        AppSize.p32,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Obx(
              () => ProductImageSection(
                selectedImage: controller.selectedImage.value,
                existingImageUrl: null,
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
              autoValidateMode: controller.avmAdd.value,
            ),

            AppSize.p24.height,

            ProductPricingSection(
              priceController: controller.priceController,
              countController: controller.countController,
              discountController: controller.discountPriceController,
              priceFocus: controller.priceFocus,
              countFocus: controller.countFocus,
              discountFocus: controller.discountFocus,
              autoValidateMode: controller.avmAdd.value,
            ),

            AppSize.p24.height,

            ProductAttributesSection(
              availableColors: controller.availableColors,
              selectedColorNames: controller.selectedColor,
              selectedTagNames: controller.selectedTagNames,
              onToggleColor: controller.toggleColor,
              onRemoveTag: controller.removeTag,
              onAddColorTap:
                  () => SellerAddAndEditDialogs.showAddColor(controller),
              onAddTagTap: () => SellerAddAndEditDialogs.showTags(controller),
            ),

            AppSize.p32.height,

            _SubmitButton(controller: controller, formKey: _formKey),

            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }
}

class _SellerAddDesktopLayout extends StatelessWidget {
  final SellerAddProductController controller;

  _SellerAddDesktopLayout({required this.controller});

  void _handleImagePick(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    if (kIsWeb) {
      controller.pickImageFromGallery();
    } else {
      SellerAddAndEditDialogs.showImageSource(controller);
    }
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                //  _CustomAppBar(isDesktop: true, theme: theme),
                AppSize.p20.height,
                Expanded(
                  child: Card(
                    color: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.0),

                      side: BorderSide(
                        width: 1.0,
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),

                    child: Obx(() {
                      switch (controller.pageState.value) {
                        case CurrentState.loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case CurrentState.error:
                          return Center(child: ErrorView());
                        case CurrentState.success:
                          return _buildDesktopContent(context, theme);
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
                        existingImageUrl: null,
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
                      onAddColorTap:
                          () =>
                              SellerAddAndEditDialogs.showAddColor(controller),
                      onAddTagTap:
                          () => SellerAddAndEditDialogs.showTags(controller),
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
                      theme.colorScheme.outlineVariant.withValues(alpha: 0),
                      theme.colorScheme.outlineVariant,
                      theme.colorScheme.outlineVariant.withValues(alpha: 0),
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
                key: _formKey,
                child: Column(
                  children: [
                    ProductInfoSection(
                      titleController: controller.titleController,
                      descController: controller.descController,
                      titleFocus: controller.titleFocus,
                      descFocus: controller.descFocus,
                      autoValidateMode: controller.avmAdd.value,
                    ),
                    AppSize.p24.height,
                    ProductPricingSection(
                      priceController: controller.priceController,
                      countController: controller.countController,
                      discountController: controller.discountPriceController,
                      priceFocus: controller.priceFocus,
                      countFocus: controller.countFocus,
                      discountFocus: controller.discountFocus,
                      autoValidateMode: controller.avmAdd.value,
                    ),
                    48.height,
                    _SubmitButton(controller: controller, formKey: _formKey),
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

  const _CustomAppBar({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: IconButtonWidget(
            icon: Icons.arrow_back,
            onTap: () => Get.back(),
            bgColor:
                isDesktop
                    ? Colors.grey.withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.2),
            color: isDesktop ? Colors.black : Colors.white,
          ),
        ),
        if (isDesktop) AppSize.p16.width,
        Expanded(
          child: Text(
            TKeys.addNewProduct.tr,
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: Get.theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
          ),
        ),
        if (!isDesktop) const SizedBox(width: 40),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final SellerAddProductController controller;
  final GlobalKey<FormState> formKey;

  const _SubmitButton({required this.controller, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          ButtonWidget(
            TKeys.finalSubmitProduct.tr,
            () => controller.submitProduct(formKey),
            isLoading: controller.submitState.value == CurrentState.loading,
            icon: Icons.check_circle_outline_rounded,
          ).material(),
    );
  }
}

class _TopBackground extends StatelessWidget {
  final Color color;

  const _TopBackground({required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 300,
      child: Stack(
        children: [
          Container(color: color),
          DecorativeCircle(
            top: -60,
            right: -100,
            size: 250,
            color: Colors.white.withValues(alpha: 0.08),
          ),
          DecorativeCircle(
            top: 50,
            left: -80,
            size: 180,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ],
      ),
    );
  }
}
