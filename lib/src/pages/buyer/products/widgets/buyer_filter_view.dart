import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/divider_widget.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/buyer_products_controller.dart';
import 'filter/filter_availability.dart';
import 'filter/filter_colors.dart';
import 'filter/filter_footer.dart';
import 'filter/filter_header.dart';
import 'filter/filter_price_range.dart';
import 'filter/filter_tags.dart';

class BuyerFilterView extends GetView<BuyerProductsController> {
  const BuyerFilterView({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.8,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilterHeader(controller),
          AppDivider.horizontal(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  FilterPriceRange(controller),
                  20.height,
                  FilterColors(controller),
                  20.height,
                  FilterTags(controller),
                  20.height,
                  FilterAvailability(controller),
                ],
              ),
            ),
          ),
          FilterFooter(controller),
        ],
      ),
    );
  }
}
