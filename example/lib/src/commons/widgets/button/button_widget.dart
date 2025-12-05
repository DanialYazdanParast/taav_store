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

  bool get _shouldDisable => !isEnabled || isLoading || state == CurrentState.loading;
  bool get _showLoader => isLoading || state == CurrentState.loading;

  Widget _buildContent({
    required Color color,
    bool isMaterial = false,
    bool isLoadingWhite = false,
  }) {
    if (_showLoader) {
      return AppLoading.circular(
        size: 20,
        color: isMaterial || isLoadingWhite
            ? Get.theme.scaffoldBackgroundColor
            : color,
      );
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
          Icon(icon, color: iconColor ?? color),
          const SizedBox(width: 8),
        ],
        if (title != null && title!.isNotEmpty)
          Text(
            title!,
            style: TextStyle(
              color: color,
              fontSize: fontSize ?? AppSize.f14,
              fontWeight: fontWeight ?? FontWeight.w600,
            ),
          ),
      ],
    );
  }

  // ─────────────── Material Button ───────────────
  Widget material({
    final double minWidth = double.infinity,
    final double? height,
    final Color? textColor,
    final Color? disabledColor,
  }) {
    final effectiveTextColor =
        textColor ?? this.textColor ?? Get.theme.scaffoldBackgroundColor;

    return SizedBox(
      width: minWidth,
      height: height ?? AppSize.buttonHeight,
      child: TextButton(
        onPressed: _shouldDisable ? null : action,
        style: TextButton.styleFrom(
          backgroundColor: bgColor ?? Get.theme.colorScheme.primary,
          foregroundColor: effectiveTextColor,
          padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.p16),
          shape: RoundedRectangleBorder(
            borderRadius:
            radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
          ),
        ),
        child: _buildContent(
          color: effectiveTextColor,
          isMaterial: true,
        ),
      ),
    );
  }

  // ─────────────── Elevated Button ───────────────
  Widget elevated({
    final double minWidth = double.infinity,
    final double? height,
  }) {
    return ElevatedButton(
      onPressed: _shouldDisable ? null : action,
      style: ElevatedButton.styleFrom(
        alignment: Alignment.center,
        padding: padding ?? EdgeInsets.symmetric(horizontal: AppSize.p16),
        backgroundColor: bgColor ?? Get.theme.primaryColor,
        minimumSize: Size(minWidth, height ?? AppSize.buttonHeight),
      ),
      child: _buildContent(
        color: textColor ?? Colors.white,
        isLoadingWhite: true,
      ),
    );
  }

  // ─────────────── Border Button ───────────────
  Widget border({
    final double minWidth = double.infinity,
    final double? height,
  }) {
    return SizedBox(
      width: minWidth,
      height: height ?? AppSize.buttonHeight,
      child: TextButton(
        onPressed: _shouldDisable ? null : action,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16), // فقط افقی
          shape: RoundedRectangleBorder(
            borderRadius: radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
          ),
        ),
        child: _buildContent(color: textColor ?? Get.theme.colorScheme.onSurface),
      ),
    );
  }

  // ─────────────── Outline Button ───────────────
  Widget outline({
    final double minWidth = double.infinity,
    final double? height,
    final Color? outlineColor,
  }) {
    final effectiveColor = outlineColor ?? Get.theme.dividerColor;

    return SizedBox(
      width: minWidth,
      height: height ?? AppSize.buttonHeight,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16), // فقط افقی
          side: BorderSide(width: 1, color: effectiveColor),
          shape: RoundedRectangleBorder(
            borderRadius: radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
          ),
        ),
        onPressed: _shouldDisable ? null : action,
        child: _buildContent(color: textColor ?? effectiveColor),
      ),
    );
  }

  // ─────────────── Text Only Button ───────────────
  Widget textOnly({
    final double minWidth = double.infinity,
    final double? height,
  }) {
    return SizedBox(
      width: minWidth,
      height: height ?? AppSize.buttonHeight,
      child: TextButton(
        onPressed: _shouldDisable ? null : action,
        child: _buildContent(color: textColor ?? Get.theme.colorScheme.primary),
      ),
    );
  }

  // ─────────────── Text + Icon Button ───────────────
  Widget textIcon({

    final double? height,
    final double? iconSize,
    final double iconSpacing = 4.0,
  }) {
    return SizedBox(

      height: height ?? AppSize.buttonHeight,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: AppSize.p16), // فقط افقی
          backgroundColor: bgColor ?? Colors.transparent,
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
            if (icon != null) Icon(icon, size: iconSize, color: textColor),
            if (iconWidget != null) iconWidget!,
          ],
        ),
      ),
    );
  }

  // ─────────────── Icon Only Button ───────────────
  Widget iconOnly({
    final double? btnSize,
    final double? iconSize,
  }) {
    final double effectiveSize = btnSize ?? AppSize.buttonHeight;
    return Container(
      constraints: BoxConstraints(
        maxHeight: effectiveSize,
        maxWidth: effectiveSize,
      ),
      decoration: BoxDecoration(
        borderRadius: radius == null ? AppSize.brMedium : AppSize.brCircular(radius!),
        color: bgColor,
      ),
      alignment: Alignment.center,
      child: IconButton(
        splashRadius: 20,
        iconSize: iconSize,
        padding: EdgeInsets.zero,
        color: iconColor,
        onPressed: _shouldDisable ? null : action,
        icon: iconWidget ?? (icon != null ? Icon(icon) : const SizedBox.shrink()),
      ),
    );
  }
}
