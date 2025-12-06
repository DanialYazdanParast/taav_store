
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/nav_item_model.dart';
import 'custom_badge.dart';


class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<NavItemModel> items;
  final Function(int) onTap;

  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double iconSize;
  final double specialIconSize;
  final bool showLabels;
  final bool showSelectedLabel;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.badgeColor,
    this.badgeTextColor,
    this.iconSize = 26,
    this.specialIconSize = 26,
    this.showLabels = false,
    this.showSelectedLabel = true,
    this.padding,
    this.borderRadius,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final colorScheme = context.theme.colorScheme;

    return Container(
      padding: padding ?? EdgeInsets.only(top: 12, bottom: bottomPadding + 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.theme.scaffoldBackgroundColor,
        borderRadius: borderRadius,
        boxShadow: boxShadow ?? [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          items.length,
              (index) => _NavItem(
            item: items[index],
            isSelected: currentIndex == index,
            onTap: () => onTap(index),
            activeColor: activeColor ?? colorScheme.primary,
            inactiveColor: inactiveColor ?? Colors.grey,
            badgeColor: badgeColor ?? Colors.red,
            badgeTextColor: badgeTextColor ?? Colors.white,
            iconSize: iconSize,
            specialIconSize: specialIconSize,
            showLabel: showLabels || (showSelectedLabel && currentIndex == index),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final NavItemModel item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color badgeColor;
  final Color badgeTextColor;
  final double iconSize;
  final double specialIconSize;
  final bool showLabel;

  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
    required this.inactiveColor,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.iconSize,
    required this.specialIconSize,
    required this.showLabel,
  });

  @override
  Widget build(BuildContext context) {

    if (item.isSpecial) {
      return _buildSpecialItem();
    }

    return _buildNormalItem();
  }

  Widget _buildSpecialItem() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              activeColor,
              activeColor.withAlpha(200),
              activeColor.withAlpha(150),
              activeColor.withAlpha(100),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: activeColor.withAlpha(102),
              blurRadius: 12,
            ),
          ],
        ),
        child: _buildIconWithBadge(
          icon: item.icon,
          color: Colors.white,
          size: specialIconSize,
        ),
      ),
    );
  }

  Widget _buildNormalItem() {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withAlpha(26) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _buildIconWithBadge(
                icon: isSelected ? item.activeIcon : item.icon,
                color: isSelected ? activeColor : inactiveColor,
                size: iconSize,
                key: ValueKey(isSelected),
              ),
            ),
            if (showLabel && isSelected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                  color: activeColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required Color color,
    required double size,
    Key? key,
  }) {
    final iconWidget = Icon(icon, color: color, size: size, key: key);

    if (!item.hasBadge) {
      return iconWidget;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        iconWidget,
        Positioned(
          right: -20,
          top: -5,
          child: CustomBadge(badgeCount: item.badgeCount,),
        ),
      ],
    );
  }

}