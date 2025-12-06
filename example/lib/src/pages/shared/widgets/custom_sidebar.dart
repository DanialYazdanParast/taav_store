import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/nav_item_model.dart';
import 'custom_badge.dart';




class CustomSidebar extends StatelessWidget {
  final int currentIndex;
  final List<NavItemModel> items;
  final Function(int) onTap;

  const CustomSidebar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      margin: const EdgeInsets.all(AppSize.p16),
      decoration: BoxDecoration(
        color: Colors.black12,

        borderRadius: BorderRadius.circular(AppSize.r16),
      ),

      child: Column(
        children: [
          _buildHeader(context),

          const SizedBox(height: 24),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: items.length,
              itemBuilder:
                  (context, index) =>
                  _buildNavItem(context, index, items[index]),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primary.withAlpha(180),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.store_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  TKeys.sellerPanel.tr,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  TKeys.productManagement.tr,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(150),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, NavItemModel item) {
    final colorScheme = context.theme.colorScheme;
    final isSelected = currentIndex == index;

    if (item.isSpecial) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onTap(index),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary,
                    colorScheme.primary.withAlpha(200),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha(80),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    // برای استفاده از فضای موجود
                    child: Text(
                      item.label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),

                  CustomBadge(badgeCount: item.badgeCount, radius: 6),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          borderRadius: BorderRadius.circular(12),
          hoverColor: colorScheme.primary.withAlpha(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color:
              isSelected
                  ? colorScheme.primary.withAlpha(30)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border:
              isSelected
                  ? Border.all(color: colorScheme.primary.withAlpha(50))
                  : null,
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 4,
                  height: isSelected ? 24 : 0,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    key: ValueKey(isSelected),
                    color:
                    isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface.withAlpha(150),
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color:
                      isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(180),
                      fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),

                if (isSelected)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}