import 'package:taav_store/src/commons/constants/app_size.dart';
import 'package:taav_store/src/commons/extensions/space_extension.dart';
import 'package:taav_store/src/commons/widgets/button/button_widget.dart';
import 'package:taav_store/src/infoStructure/languages/translation_keys.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:taav_store/src/pages/shared/widgets/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerFilterHeader extends StatelessWidget {
  final SellerProductsController controller;

  const SellerFilterHeader(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final text = context.theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButtonWidget(
                icon: Icons.filter_list,
                onTap: () {},
                color: context.theme.iconTheme.color,
                bgColor: Colors.transparent,
                hasBorder: true,
              ),
              10.width,
              Text(
                TKeys.filters.tr,
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          ButtonWidget(
            TKeys.removeAll.tr,
            controller.clearTempFilters,
            icon: Icons.delete_outline_rounded,
            textColor: colors.error,
            iconColor: colors.error,
          ).textIcon(),
        ],
      ),
    );
  }
}
