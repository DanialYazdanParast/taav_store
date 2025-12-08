import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/buyer_products_controller.dart';

class FilterFooter extends StatelessWidget {
  final BuyerProductsController controller;

  const FilterFooter(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.theme.colorScheme;
    final text = context.theme.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppSize.p16,
        horizontal: AppSize.p16,
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSize.buttonHeight,
          child: Row(
            children: [
              _badge(colors, text),
              Expanded(
                child:
                    ButtonWidget(
                      TKeys.viewResults.tr,
                      controller.applyFilters,
                      radius: 16,
                    ).material(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _badge(ColorScheme colors, TextTheme text) {
    return Obx(() {
      final count = controller.totalTempFilters;
      final show = count > 0;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: show ? AppSize.buttonHeight : 0,
        margin: EdgeInsetsDirectional.only(end: show ? AppSize.p16 : 0),
        padding: const EdgeInsets.symmetric(vertical: 0),
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(AppSize.p16),
          border: show ? Border.all(color: colors.primary) : null,
        ),
        child:
            show
                ? Center(
                  child: Text(
                    "$count",
                    style: text.titleMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                : null,
      );
    });
  }
}
