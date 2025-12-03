import 'package:flutter/material.dart';

class NavItemModel {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSpecial;

  NavItemModel({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isSpecial = false,
  });
}