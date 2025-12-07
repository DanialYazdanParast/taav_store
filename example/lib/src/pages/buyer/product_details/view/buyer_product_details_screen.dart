import 'package:advanced_count_control/advanced_count_control.dart';
import 'package:example/src/pages/shared/widgets/custom_badge.dart';
import 'package:example/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/pages/shared/widgets/header_sheet.dart';
import '../controllers/buyer_product_details_controller.dart';


class BuyerProductDetailsScreen extends GetView<BuyerProductDetailsController> {
  const BuyerProductDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = Get.height;
    final screenWidth = Get.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildProductImage(screenHeight, screenWidth, theme),

          _buildTopBar(context, theme),

          _buildBottomSheet(theme),

          _buildBottomBar(theme),
        ],
      ),
    );
  }

  Widget _buildProductImage(double height, double width, ThemeData theme) {
    return SizedBox(
      height: height * 0.45,
      width: width,
      child: Obx(() {
        final isLoading = controller.productState.value != CurrentState.success;
        final product = controller.product.value;

        if (isLoading || product == null) {
          return Container(color: theme.disabledColor.withOpacity(0.1));
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => Icon(
                  Icons.image_not_supported,
                  color: theme.disabledColor,
                  size: 50,
                ),
          ),
        );
      }),
    );
  }

  Widget _buildTopBar(BuildContext context, ThemeData theme) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSize.p10,
      left: AppSize.p16,
      right: AppSize.p16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: Icons.arrow_back,
            onTap: () => Get.back(),
            theme: theme,
          ),
          _buildCartIcon(theme),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return IconButtonWidget(
      icon: icon,
      onTap: onTap,
      bgColor: theme.scaffoldBackgroundColor.withOpacity(0.9),
      color: theme.iconTheme.color,
      hasBorder: true,
      size: 20,
    );
  }

  Widget _buildCartIcon(ThemeData theme) {
    return Obx(() {
      final count = controller.cartController.totalCount;

      return Stack(
        clipBehavior: Clip.none,
        children: [
          _buildIconButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {
              // Get.toNamed('/cart');
            },
            theme: theme,
          ),

          Positioned(
            top: -5,
            right: -5,
            child: CustomBadge(
              badgeCount: count,
              fontSize: 10,
              paddingHorizontal: 5,
              paddingVertical: 2,
              radius: 12,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildBottomSheet(ThemeData theme) {
    return SafeArea(
      bottom: false,
      child: DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.65,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSize.r12),
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Obx(() {
              if (controller.productState.value != CurrentState.success) {
                return const Center(child: CircularProgressIndicator());
              }

              final product = controller.product.value!;

              return ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSize.p20,
                  0,
                  AppSize.p20,
                  100,
                ),
                children: [
                  const SizedBox(height: AppSize.p12),
                  const Center(child: HeaderSheet()),
                  const SizedBox(height: AppSize.p16),

                  _buildTags(product.tags, theme),
                  _buildTitle(product.title, theme),

                  // انتخاب رنگ
                  if (product.colors.isNotEmpty) ...[
                    _buildColorSelection(product.colors, theme),
                    const SizedBox(height: AppSize.p24),
                  ],

                  _buildDescription(product.description, theme),
                ],
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildTags(List<String> tags, ThemeData theme) {
    if (tags.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.p8),
      child: Text(
        tags.join(" / "),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.p24),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildDescription(String description, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "توضیحات محصول",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSize.p8),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildColorSelection(List<String> colors, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "انتخاب رنگ",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSize.p12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              colors.map((colorHex) {
                return Obx(() {
                  final isSelected = controller.selectedColor.value == colorHex;
                  final Color colorObj = _parseColor(colorHex);
                  return GestureDetector(
                    onTap: () => controller.selectColor(colorHex),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: colorObj,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected
                                  ? theme.colorScheme.primary
                                  : (colorObj.value == 0xFFFFFFFF ||
                                      colorObj == Colors.white)
                                  ? Colors.grey.shade300
                                  : Colors.transparent,
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: colorObj.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                                : null,
                      ),
                      child:
                          isSelected
                              ? Icon(
                                Icons.check,
                                size: 18,
                                color:
                                    ThemeData.estimateBrightnessForColor(
                                              colorObj,
                                            ) ==
                                            Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                              )
                              : null,
                    ),
                  );
                });
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildBottomBar(ThemeData theme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p12,
        ),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(color: theme.dividerColor, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Obx(() {
            if (controller.product.value == null)
              return const SizedBox.shrink();

            return SizedBox(
              height: 60,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 2, child: _buildAddToCartButton(theme)),
                  const SizedBox(width: AppSize.p20),
                  _buildPriceSection(theme),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildAddToCartButton(ThemeData theme) {
    return Obx(() {
      final product = controller.product.value!;
      int currentQtyForColor = controller.quantityInCartForSelectedColor;
      int dynamicMaxQuantity = currentQtyForColor + controller.remainingStock;

      String buttonLabel = "افزودن به سبد خرید";
      bool isDisabled = false;

      if (product.quantity == 0) {
        buttonLabel = "ناموجود";
        isDisabled = true;
      } else if (controller.remainingStock <= 0 && currentQtyForColor == 0) {
        buttonLabel = "تمام شد";
        isDisabled = true;
      }

      return AdvancedCountControl(
        currentQuantity: currentQtyForColor,
        maxQuantity: dynamicMaxQuantity,

        onIncrease: controller.onAddOrIncrease,
        onAddTap: controller.onAddOrIncrease,
        onDecrease: controller.onDecrease,

        showAddButton: product.quantity == 0 || currentQtyForColor == 0,

        addButtonLabel: buttonLabel,
        isDisabled: isDisabled,

        style: CountControlStyle(
          primaryColor: theme.colorScheme.primary,
          backgroundColor: theme.scaffoldBackgroundColor,
          contentColor: theme.colorScheme.primary,
          borderSide: BorderSide(color: theme.dividerColor),
          borderRadius: AppSize.r10,
          textStyle: theme.textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
          btnTextStyle: theme.textTheme.labelLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        numberFormatter: _toPersianNum,
      );
    });
  }

  Widget _buildPriceSection(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (controller.hasDiscount) _buildDiscountRow(theme),

        _buildFinalPrice(theme),
      ],
    );
  }

  Widget _buildDiscountRow(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4), // کمی فاصله با قیمت اصلی
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${_toPersianNum(controller.discountPercentage.toString())}٪",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onError,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              _formatPrice(controller.product.value!.price),
              style: theme.textTheme.bodySmall?.copyWith(
                decoration: TextDecoration.lineThrough,
                color: theme.disabledColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalPrice(ThemeData theme) {
    return FittedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatPrice(controller.effectivePrice.toInt()),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            "تومان",
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // توابع کمکی
  // ═══════════════════════════════════════════════════════════════
  Color _parseColor(String hex) {
    try {
      String hexString = hex.replaceAll('#', '');
      if (hexString.length == 6) hexString = 'FF$hexString';
      return Color(int.parse('0x$hexString'));
    } catch (e) {
      return Colors.transparent;
    }
  }

  String _formatPrice(num price) {
    final formatter = NumberFormat("#,###");
    return _toPersianNum(formatter.format(price));
  }

  String _toPersianNum(String input) {
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < english.length; i++) {
      input = input.replaceAll(english[i], persian[i]);
    }
    return input;
  }
}
