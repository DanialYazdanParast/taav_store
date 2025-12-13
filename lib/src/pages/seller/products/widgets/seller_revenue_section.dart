import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/seller_products_controller.dart';

class SellerRevenueSection extends GetView<SellerProductsController> {
  const SellerRevenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildAmountRow(), AppSize.p6.height, _buildLabelRow()],
    );
  }

  Widget _buildAmountRow() {
    return Obx(() {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: TextDirection.rtl,
          children: [
            SizedBox(
              height: 60,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder:
                    (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
                child: FittedBox(
                  child: Text(
                    controller.isHidden.value
                        ? '••••••'
                        : controller.totalRevenueAmount.value.toLocalizedPrice,
                    key: ValueKey(controller.isHidden.value),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.f26,
                      fontWeight: FontWeight.w900,
                      overflow: TextOverflow.clip,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            AppSize.p8.width,
            Text(
              TKeys.currency.tr,
              style: TextStyle(color: Colors.white70, fontSize: AppSize.f12),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildLabelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        GestureDetector(
          onTap: controller.toggleVisibility,
          child: Obx(
            () => Icon(
              controller.isHidden.value
                  ? Icons.visibility_off
                  : Icons.remove_red_eye_sharp,
              size: 18,
              color: Colors.white70,
            ),
          ),
        ),
        AppSize.p4.width,
        Text(
          TKeys.totalRevenue.tr,
          style: TextStyle(color: Colors.white70, fontSize: AppSize.f14),
        ),
      ],
    );
  }
}
