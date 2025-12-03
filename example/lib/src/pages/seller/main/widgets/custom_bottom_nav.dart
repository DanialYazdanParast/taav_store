
import 'package:example/src/pages/shared/models/nav_item_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<NavItemModel> items;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(top: 12, bottom: bottomPadding + 12),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        boxShadow: [
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
              (index) => _buildNavItem(context, index),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index) {
    final colorScheme = context.theme.colorScheme;

    final item = items[index];
    final isSelected = currentIndex == index;

    if (item.isSpecial) {
      return GestureDetector(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colorScheme.primary,
                colorScheme.primary.withAlpha(200),
                colorScheme.primary.withAlpha(150),
                colorScheme.primary.withAlpha(100),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withAlpha(102),
                blurRadius: 12,
              ),
            ],
          ),
          child: Icon(item.icon, color: Colors.white, size: 26),
        ),
      );
    }
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
          isSelected
              ? colorScheme.primary.withAlpha(26)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                key: ValueKey(isSelected),
                color: isSelected ? colorScheme.primary : Colors.grey,
                size: 26,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                item.label,
                style: TextStyle(
                  color: colorScheme.primary,
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
}
