import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ButtonWidget {
  final String? title;
  final VoidCallback? action;
  final bool isLoading;
  final bool isEnabled;
  final CurrentState? state;
  final bool opensPage;
  final double? width;
  final double? radius;
  final IconData? icon;
  final Widget? iconWidget;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? bgColor;
  final Color? textColor;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;

  ButtonWidget(
    this.title,
    this.action, {
    this.isLoading = false,
    this.isEnabled = true,
    this.state = CurrentState.idle,
    this.opensPage = false,
    this.width,
    this.radius,
    this.icon,
    this.iconWidget,
    this.fontSize,
    this.fontWeight,
    this.bgColor,
    this.textColor,
    this.iconColor,
    this.iconSize,
    this.padding,
  });

  // ---------------------------------------------------------------------------
  // 1. Material Button (Original Logic Updated)
  // ---------------------------------------------------------------------------
  Widget material({
    final double minWidth = double.infinity,
    final Color? textColor,
    final Color? disabledColor,
  }) {
    return MaterialButton(
      height: AppSize.buttonHeight,
      elevation: 1,
      disabledElevation: 0,
      onPressed: _shouldDisable ? null : action,
      disabledColor: disabledColor ?? Get.theme.colorScheme.outlineVariant,
      color: bgColor ?? Get.theme.colorScheme.primary,
      padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.p16),
      textColor: textColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius:
            radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
      ),
      minWidth: minWidth,
      child: _buildContent(
        color: textColor ?? Get.theme.scaffoldBackgroundColor,
        isMaterial: true,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Border Button (Original Logic Updated)
  // ---------------------------------------------------------------------------
  Widget border() {
    return TextButton(
      onPressed: _shouldDisable ? null : action,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Get.theme.dividerColor),
          borderRadius:
              radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p8,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColor),
              SizedBox(width: AppSize.p16),
            ],
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: fontSize ?? AppSize.f14,
                  fontWeight: fontWeight ?? FontWeight.w500,
                  color: textColor ?? Get.theme.colorScheme.onSurface,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Text Only Button (Includes opensPage logic)
  // ---------------------------------------------------------------------------
  Widget textOnly() {
    return TextButton(
      onPressed: _shouldDisable ? null : action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (state == CurrentState.loading)
            AppLoading.circular(size: 20 ,color:Get.theme.scaffoldBackgroundColor )
          else ...[
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  color: textColor ?? Get.theme.colorScheme.primary,
                  fontSize: fontSize ?? AppSize.f12, // Small
                  fontWeight: fontWeight ?? FontWeight.bold,
                ),
              ),
            if (opensPage)
              Padding(
                padding: const EdgeInsets.only(
                  left: 2,
                ), // LTR/RTL handled by logic
                child: Icon(
                  Icons.chevron_left_outlined, // RTL support
                  size: 16,
                  color: textColor ?? Get.theme.colorScheme.primary,
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Text Icon Old (Using TextButton.icon)
  // ---------------------------------------------------------------------------
  Widget textIconOld({
    final double? iconSize,
    final IconAlignment? iconAlignment,
  }) {
    return TextButton.icon(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        backgroundColor: bgColor ?? Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
        ),
      ),
      iconAlignment: iconAlignment ?? IconAlignment.end,
      onPressed: _shouldDisable ? null : action,
      icon: Icon(icon, size: iconSize, color: textColor),
      label: Text(
        title ?? '',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Text Icon (Using Row)
  // ---------------------------------------------------------------------------
  Widget textIcon({final double? iconSize, final double iconSpacing = 4.0}) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: bgColor ?? Colors.transparent,
        elevation: 0,
      ),
      onPressed: _shouldDisable ? null : action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          SizedBox(width: iconSpacing),
          Icon(icon, size: iconSize, color: textColor),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Outline (New Style)
  // ---------------------------------------------------------------------------
  Widget outline({final Color? outlineColor}) {
    final effectiveColor = outlineColor ?? Get.theme.colorScheme.primary;
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        fixedSize: const Size.fromHeight(40),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        side: BorderSide(width: 1, color: effectiveColor),
        shape: RoundedRectangleBorder(borderRadius: AppSize.brMedium),
      ),
      onPressed: _shouldDisable ? null : action,
      child: _buildContent(color: textColor ?? effectiveColor),
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Outline Old
  // ---------------------------------------------------------------------------
  Widget outlineOld() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(width: 1, style: BorderStyle.solid),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p8,
        ),
      ),
      onPressed: _shouldDisable ? null : action,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: AppSize.f14),
            ),
          if (iconWidget != null) ...[
            const SizedBox(width: 8),
            iconWidget!,
          ] else if (icon != null) ...[
            const SizedBox(width: 8),
            Icon(icon),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 8. Elevated Button
  // ---------------------------------------------------------------------------
  Widget elevated() {
    return ElevatedButton(
      onPressed: _shouldDisable ? null : action,
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.p16,
          vertical: AppSize.p8,
        ),
        backgroundColor: bgColor ?? Get.theme.primaryColor,
      ),
      child: _buildContent(
        color: textColor ?? Colors.white,
        isLoadingWhite: true, // Specific check from original code
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 9. Icon Only
  // ---------------------------------------------------------------------------
  Widget iconOnly({final double? btnSize, final double? iconSize}) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: btnSize ?? 64,
        maxWidth: btnSize ?? 64,
      ),
      decoration: BoxDecoration(
        borderRadius:
            radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
        color: bgColor,
      ),
      alignment: Alignment.center,
      child: IconButton(
        splashRadius: 20, // Adjusted logic
        iconSize: iconSize,
        padding: EdgeInsets.zero,
        color: iconColor,
        onPressed: _shouldDisable ? null : action,
        icon:
            iconWidget ?? (icon != null ? Icon(icon) : const SizedBox.shrink()),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 10. Square Button
  // ---------------------------------------------------------------------------
  Widget square() {
    return InkWell(
      onTap: action,
      borderRadius: AppSize.brLarge,
      child: Container(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: Get.theme.cardColor, // Replaced bgMain2 with cardColor
          borderRadius: AppSize.brLarge,
        ),
        child: Text(title ?? '', textAlign: TextAlign.center),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 11. AppBar Action
  // ---------------------------------------------------------------------------
  Widget appbarAction() {
    return InkWell(
      onTap: action,
      borderRadius: AppSize.brMedium,
      child: Container(
        width: 36,
        height: 36,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: iconColor ?? Get.theme.iconTheme.color!.withOpacity(0.5),
            ),
            borderRadius: AppSize.brMedium,
          ),
        ),
        child: iconWidget,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper Methods (To clean up duplicates)
  // ---------------------------------------------------------------------------

  bool get _shouldDisable =>
      !isEnabled || isLoading || state == CurrentState.loading;

  bool get _showLoader => isLoading || state == CurrentState.loading;

  Widget _buildContent({
    required Color color,
    bool isMaterial = false,
    bool isLoadingWhite = false,
  }) {
    if (_showLoader) {
      if (isMaterial || isLoadingWhite) {
        return ConstrainedBox(
          constraints: const BoxConstraints(),
          child: AppLoading.circular(size: 20 ,color: Get.theme.scaffoldBackgroundColor),
        );
      }
      return AppLoading.circular(size: 20 ,color: Get.theme.scaffoldBackgroundColor);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconWidget != null) ...[
          iconWidget!,
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, color: iconColor ?? color), // Color handled
          const SizedBox(width: 8),
        ],
        if (title != null && title!.isNotEmpty)
          Text(
            title!,
            style: TextStyle(
              color: color,
              fontSize: fontSize ?? AppSize.f16, // Large
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}
