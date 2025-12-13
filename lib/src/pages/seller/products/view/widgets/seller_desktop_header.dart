import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/dialog_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/text/app_search_field.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/pages/seller/main/controllers/main_seller_controller.dart';
import 'package:taav_store/src/pages/seller/products/controllers/seller_products_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/pages/shared/widgets/icon_button_widget.dart';

import 'seller_filter_view.dart';

class SellerDesktopHeader extends GetView<SellerProductsController> {
  const SellerDesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.colorScheme.primary;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p20),
      decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
      child: Row(
        children: [
          _buildSearchField(),
          AppSize.p20.width,
          _buildFilterButton(theme),
          AppSize.p24.width,
          _buildDivider(theme),
          AppSize.p24.width,
          _buildNotificationIcon(theme),
          AppSize.p16.width,
          _buildProfileAvatar(primaryColor),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Expanded(
      child: AppSearchField(
        hintText: LocaleKeys.searchHint.tr,
        controller: controller.searchController,
        borderRadius: AppSize.r12,
      ),
    );
  }

  Widget _buildFilterButton(ThemeData theme) {
    return SizedBox(
      height: 46,
      width: 46,
      child: IconButtonWidget(
        icon: Icons.filter_list_rounded,

        onTap: () {
          controller.initTempFilters();
          DialogWidget().show(const SellerFilterView());
        },
        color: theme.iconTheme.color,
        bgColor: theme.scaffoldBackgroundColor,
        hasBorder: true,
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Container(height: 30, width: 1, color: theme.dividerColor);
  }

  Widget _buildNotificationIcon(ThemeData theme) {
    return Icon(
      Icons.notifications_none_rounded,
      size: 28,
      color: theme.iconTheme.color?.withValues(alpha: 0.7),
    );
  }

  Widget _buildProfileAvatar(Color primaryColor) {
    return InkWell(
      onTap: () {
        final mainSellerController = Get.find<MainSellerController>();
        mainSellerController.changeTab(2);
      },
      child: CircleAvatar(
        radius: AppSize.p20,
        backgroundColor: primaryColor.withValues(alpha: 0.2),
        child: Icon(Icons.person, color: primaryColor),
      ),
    );
  }
}
