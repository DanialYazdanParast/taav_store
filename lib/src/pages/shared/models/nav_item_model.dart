
import 'package:flutter/material.dart';

class NavItemModel {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSpecial;
  final int? badgeCount;
  final bool showBadge;

  const NavItemModel({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isSpecial = false,
    this.badgeCount,
    this.showBadge = false,
  });

  NavItemModel copyWith({
    IconData? icon,
    IconData? activeIcon,
    String? label,
    bool? isSpecial,
    int? badgeCount,
    bool? showBadge,
  }) {
    return NavItemModel(
      icon: icon ?? this.icon,
      activeIcon: activeIcon ?? this.activeIcon,
      label: label ?? this.label,
      isSpecial: isSpecial ?? this.isSpecial,
      badgeCount: badgeCount ?? this.badgeCount,
      showBadge: showBadge ?? this.showBadge,
    );
  }

  bool get hasBadge => showBadge || (badgeCount != null && badgeCount! > 0);
}