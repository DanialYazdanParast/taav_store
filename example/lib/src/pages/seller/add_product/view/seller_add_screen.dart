import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/pages/seller/add_product/widgets/product_info_section.dart';
import 'package:example/src/pages/shared/widgets/seller_add_and_edit_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:example/src/pages/shared/widgets/seller_icon_button.dart';
import 'package:example/src/pages/shared/widgets/auth/auth_decorative_circle.dart';
import '../controllers/seller_add_controller.dart';
import '../widgets/product_attributes_section.dart';
import '../widgets/product_image_section.dart';
import '../widgets/product_pricing_section.dart';

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

  const _SellerAddMobileLayout({required this.controller});

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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          case CurrentState.error:
                            return ErrorView(
                              onRetry:
                                  () =>
                                      controller
                                          .fetchInitialData(), // Retry loading data
                            );
                          case CurrentState.idle: // Fallthrough
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
        key: controller.formKey,
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
              selectedColorNames: controller.selectedColorNames,
              selectedTagNames: controller.selectedTagNames,
              onToggleColor: controller.toggleColor,
              onRemoveTag: controller.removeTag,
              onAddColorTap:
                  () => SellerAddAndEditDialogs.showAddColor(controller),
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

class _SellerAddDesktopLayout extends StatelessWidget {
  final SellerAddProductController controller;

  const _SellerAddDesktopLayout({required this.controller});

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
            padding: const EdgeInsets.only(bottom:  AppSize.p24),
            child: Column(
              children: [
                _CustomAppBar(isDesktop: true, theme: theme),
                AppSize.p20.height,
                Expanded(
                  child: Card(
                    color:  theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(

                      borderRadius: BorderRadius.circular(24.0),


                      side: BorderSide(
                        width: 2.0,
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      ),
                    ),

                    child: Obx(() {
                      switch (controller.pageState.value) {
                        case CurrentState.loading:
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        case CurrentState.error:
                          return Center(
                            child: ErrorView(
                              onRetry: () => controller.fetchInitialData(),
                            ),
                          );
                        case CurrentState.idle:
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
              child: SingleChildScrollView(
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
                      selectedColorNames: controller.selectedColorNames,
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
          const VerticalDivider(width: 48),
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
          child: SellerIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Get.back(),
            bgColor:
                isDesktop
                    ? Colors.grey.withOpacity(0.1)
                    : Colors.white.withOpacity(0.2),
            color: isDesktop ? Colors.black : Colors.white,
          ),
        ),
        if (isDesktop) AppSize.p16.width,
        Expanded(
          child: Text(
            "افزودن محصول جدید",
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              color:
                  isDesktop ? theme?.textTheme.bodyLarge?.color : Colors.white,
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
  final SellerAddProductController controller;

  const _SubmitButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          ButtonWidget(
            "ثبت نهایی محصول",
            controller.submitProduct,
            // Check submit state for loading indicator
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
            color: Colors.white.withOpacity(0.08),
          ),
          DecorativeCircle(
            top: 50,
            left: -80,
            size: 180,
            color: Colors.white.withOpacity(0.08),
          ),
        ],
      ),
    );
  }
}
