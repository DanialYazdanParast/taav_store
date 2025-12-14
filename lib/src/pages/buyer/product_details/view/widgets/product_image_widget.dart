import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/widgets/network_image.dart';

import '../../controllers/buyer_product_details_controller.dart';

class ProductImageWidget extends GetView<BuyerProductDetailsController> {
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const ProductImageWidget({
    super.key,
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final double radiusValue = borderRadius?.topLeft.x ?? 0.0;

    return SizedBox(
      height: height,
      width: width,
      child: Obx(() {
        final isLoading = controller.productState.value != CurrentState.success;
        final product = controller.product.value;

        if (isLoading || product == null) {
          return ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: Container(
              color: Colors.grey.withValues(alpha: 0.1),
            ),
          );
        }

        return TaavNetworkImage(
          product.image,
          height: height,
          width: width,
          borderRadius: radiusValue,
          fit: BoxFit.cover,
        );
      }),
    );
  }
}