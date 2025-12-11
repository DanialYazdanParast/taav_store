import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/commons/widgets/dialog_widget.dart';
import 'package:example/src/commons/widgets/text/app_search_field.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/buyer/main/controllers/main_buyer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/icon_button_widget.dart';
import '../controllers/buyer_products_controller.dart';
import 'buyer_filter_view.dart';

class BuyerDesktopHeader extends GetView<BuyerProductsController> {
  const BuyerDesktopHeader({super.key});

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
          AppSize.p16.width,
          _buildAddButton(),
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
        hintText: TKeys.searchHint.tr,
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
          DialogWidget().show(const BuyerFilterView());
        },
        color: theme.iconTheme.color,
        bgColor: theme.cardColor,
        hasBorder: true,
      ),
    );
  }

  Widget _buildAddButton() {
    return SizedBox(
      height: 48,
      child: ButtonWidget(
        TKeys.addProduct.tr,
        () {},
        icon: Icons.add_rounded,
        radius: AppSize.r12,
        textColor: Colors.white,
        fontWeight: FontWeight.bold,
      ).material(minWidth: 0),
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
        final mainBuyerController = Get.find<MainBuyerController>();
        mainBuyerController.changeTab(2);
      },
      child: CircleAvatar(
        radius: AppSize.p20,
        backgroundColor: primaryColor.withValues(alpha: 0.2),
        child: Icon(Icons.person, color: primaryColor),
      ),
    );
  }
}
