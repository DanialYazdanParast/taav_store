import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/seller_products_controller.dart';
import 'widgets/filter_availability.dart';
import 'widgets/filter_colors.dart';
import 'widgets/filter_footer.dart';
import 'widgets/filter_header.dart';
import 'widgets/filter_price_range.dart';
import 'widgets/filter_tags.dart';

class SellerFilterView extends GetView<SellerProductsController> {
  const SellerFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SellerFilterHeader(controller),
          AppDivider.horizontal(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  SellerFilterPriceRange(controller),
                  20.height,
                  SellerFilterColors(controller),
                  20.height,
                  SellerFilterTags(controller),
                  20.height,
                  SellerFilterAvailability(controller),
                ],
              ),
            ),
          ),
          SellerFilterFooter(controller),
        ],
      ),
    );
  }
}
