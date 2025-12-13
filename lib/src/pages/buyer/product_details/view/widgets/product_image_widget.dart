import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return SizedBox(
      height: height,
      width: width,
      child: Obx(() {
        final isLoading = controller.productState.value != CurrentState.success;
        final product = controller.product.value;

        if (isLoading || product == null) {
          return Container(color: Colors.grey.withValues(alpha: 0.1));
        }

        return ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Image.network(
            product.image,
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Icon(
                  Icons.image_not_supported,
                  color: Colors.grey,
                  size: 50,
                ),
          ),
        );
      }),
    );
  }
}
