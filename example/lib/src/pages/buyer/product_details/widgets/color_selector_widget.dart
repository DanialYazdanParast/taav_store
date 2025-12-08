import 'package:example/src/commons/constants/app_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_product_details_controller.dart';

class ColorSelectorWidget extends GetView<BuyerProductDetailsController> {
  const ColorSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final product = controller.product.value;
      if (product == null || product.colors.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "انتخاب رنگ",
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSize.p12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: product.colors.map((colorHex) => _buildColorItem(colorHex, theme)).toList(),
          ),
        ],
      );
    });
  }

  Widget _buildColorItem(String colorHex, ThemeData theme) {
    return Obx(() {
      final isSelected = controller.selectedColor.value == colorHex;
      final Color colorObj = _parseColor(colorHex);

      return GestureDetector(
        onTap: () => controller.selectColor(colorHex),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorObj,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : Colors.grey.shade300,
              width: isSelected ? 2.5 : 1,
            ),
            boxShadow: isSelected
                ? [BoxShadow(color: colorObj.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 4))]
                : null,
          ),
          child: isSelected
              ? Icon(
            Icons.check,
            size: 18,
            color: ThemeData.estimateBrightnessForColor(colorObj) == Brightness.light
                ? Colors.black
                : Colors.white,
          )
              : null,
        ),
      );
    });
  }

  Color _parseColor(String hex) {
    try {
      String hexString = hex.replaceAll('#', '');
      if (hexString.length == 6) hexString = 'FF$hexString';
      return Color(int.parse('0x$hexString'));
    } catch (e) {
      return Colors.transparent;
    }
  }
}