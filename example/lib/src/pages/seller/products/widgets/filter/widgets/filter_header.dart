import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/seller/products/controllers/seller_products_controller.dart';
import 'package:example/src/pages/seller/products/widgets/seller_icon_button.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SellerIconButton(
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
