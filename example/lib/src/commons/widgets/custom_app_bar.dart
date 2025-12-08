import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackTap,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return AppBar(
      title: Text(
        title,
        style: theme.textTheme.bodyLarge
      ),
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: theme.appBarTheme.backgroundColor,
      actions: actions,


      automaticallyImplyLeading: false,
      leading: showBackButton
          ? IconButton(
        icon: Icon( Icons.arrow_back, color: theme.iconTheme.color),
        onPressed: onBackTap ?? () => Get.back(),
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}