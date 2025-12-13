import 'package:taav_store/src/infrastructure/routes/app_pages.dart';
import 'package:taav_store/src/pages/shared/widgets/header_sheet.dart';
import 'package:taav_store/src/pages/shared/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';

import 'icon_list.dart';

class SettingsDraggableSheet extends StatelessWidget {
  final VoidCallback onLogout;

  const SettingsDraggableSheet({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: DraggableScrollableSheet(
        initialChildSize: 0.63,
        minChildSize: 0.63,
        maxChildSize: 1.0,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                const HeaderSheet(),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.p24,
                        ),
                        child: Row(
                          children: [
                            Text(
                              TKeys.myOrders.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      MenuItem(
                        icon: Icons.history_rounded,
                        color: theme.colorScheme.primary,
                        title: TKeys.purchaseHistory.tr,
                        subtitle: TKeys.orderHistoryDesc.tr,
                        showChevron: true,
                        onTap: () => Get.toNamed(AppRoutes.buyerOrders),
                      ),

                      AppSize.p24.height,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSize.p24,
                        ),
                        child: Row(
                          children: [
                            Text(
                              TKeys.settings.tr,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AppSize.p16.height,

                      IconList(onLogout: onLogout),

                      50.height,
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
