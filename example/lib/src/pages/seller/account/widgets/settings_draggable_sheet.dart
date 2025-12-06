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
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
              ],
            ),
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: AppSize.p12, bottom: AppSize.p20),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                  ),
                ),
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
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.p20),
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