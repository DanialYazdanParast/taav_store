import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/pages/shared/widgets/header_sheet.dart';
import 'package:example/src/pages/shared/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';

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
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: Column(
              children: [
                HeaderSheet(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.p24),
                  child: Row(children: [
                    // تیتر بخش
                    Text(
                        'گزارش‌های فروش',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
                    )
                  ]),
                ),
                AppSize.p16.height,
                MenuItem(
                  icon: Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary,
                  title: 'آمار فروش محصولات',
                  subtitle: 'مشاهده کالاهای پرفروش',
                  showChevron: true,
                  onTap: () => Get.toNamed(AppRoutes.sellerStats),
                ),
                AppSize.p24.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.p24),
                  child: Row(children: [
                    Text(TKeys.settings.tr, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))
                  ]),
                ),
                AppSize.p16.height,
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
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