import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        textDirection: TextDirection.rtl,
        children: [
          SizedBox(
            height: 60, // ارتفاع ثابت متناسب با Text
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      FadeTransition(opacity: animation, child: child),
              child: Text(
                controller.isHidden.value ? '••••••' : '0',
                key: ValueKey(controller.isHidden.value),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSize.f36,
                  fontWeight: FontWeight.w900,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          AppSize.p8.width,
          Text(
            'تومان',
            style: TextStyle(color: Colors.white70, fontSize: AppSize.f14),
          ),
        ],
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
          ' درآمد کل',
          style: TextStyle(color: Colors.white70, fontSize: AppSize.f14),
        ),
      ],
    );
  }
}
