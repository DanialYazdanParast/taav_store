import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/bottom_sheet.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/seller/main/controllers/main_seller_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/seller_products_controller.dart';
import 'filter/seller_filter_view.dart';
import '../../../shared/widgets/icon_button_widget.dart';


class SellerAnimatedAppBar extends GetView<SellerProductsController> {
  final double screenWidth;
  final bool isRtl;

  const SellerAnimatedAppBar({
    super.key,
    required this.screenWidth,
    required this.isRtl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [_buildTitleRow(), _buildAnimatedSearchBar()],
      ),
    );
  }

  Widget _buildTitleRow() {
    return Obx(
          () => AnimatedOpacity(
        opacity: controller.isSearching.value ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.p16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButtonWidget(
                icon: Icons.filter_list,
                onTap: () {
                  Get.find<MainSellerController>().incrementBadge();
                }
                //   controller.initTempFilters();
                //   BottomSheetWidget(
                //     isScrollControlled: true,
                //   ).show(const SellerFilterView());
                // },
              ),
              Text(
                TKeys.sellerPanel.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppSize.f18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              48.width,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSearchBar() {
    return Positioned(
      left: isRtl ? AppSize.p16 : null,
      right: isRtl ? null : AppSize.p16,
      child: Obx(
            () => AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutQuart,
          width: controller.isSearching.value ? screenWidth - 32 : 45,
          height: 45,
          decoration: BoxDecoration(
            color:
            controller.isSearching.value
                ? Colors.white
                : Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(
              controller.isSearching.value ? AppSize.r12 : AppSize.r10,
            ),
            boxShadow:
            controller.isSearching.value
                ? [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: AppSize.p10,
                offset: const Offset(0, 4),
              ),
            ]
                : [],
          ),
          child: Stack(
            alignment: isRtl ? Alignment.centerLeft : Alignment.centerRight,
            children: [
              if (controller.isSearching.value) _buildSearchTextField(),
              _buildSearchIconButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: isRtl ? 40 : AppSize.p10,
        right: isRtl ? AppSize.p10 : 40,
      ),
      child: TextField(
        controller: controller.searchController,
        focusNode: controller.searchFocusNode,
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          hintText: TKeys.searchHint.tr,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: AppSize.f13),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildSearchIconButton() {
    return Positioned(
      left: isRtl ? 0 : null,
      right: isRtl ? null : 0,
      child: Obx(
            () => GestureDetector(
          onTap: controller.toggleSearch,
          child: Container(
            width: 45,
            height: 45,
            color: Colors.transparent,
            child: Icon(
              controller.isSearching.value ? Icons.close : Icons.search,
              color: controller.isSearching.value ? Colors.grey : Colors.white,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}