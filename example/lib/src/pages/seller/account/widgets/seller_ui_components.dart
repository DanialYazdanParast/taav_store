import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/commons/widgets/button/button_widget.dart';

// ویجت ذرات پس‌زمینه
class BackgroundParticle extends StatelessWidget {
  final double top;
  final double? left;
  final double? right;
  final Color color;
  final double size;

  const BackgroundParticle({
    super.key,
    required this.top,
    this.left,
    this.right,
    required this.color,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withOpacity(0.6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// آیتم‌های منوی تنظیمات
class SettingsMenuItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;
  final bool showChevron;

  const SettingsMenuItem({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.isDestructive = false,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.r16),
      hoverColor: color.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(AppSize.p12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            AppSize.p16.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: AppSize.f16,
                      color: isDestructive
                          ? Colors.red
                          : Get.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  AppSize.p4.height,
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: AppSize.f12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (showChevron)
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400], size: 28),
          ],
        ),
      ),
    );
  }
}

// گزینه قابل انتخاب (برای زبان و تم)
class SelectableOptionWidget extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData? icon;

  const SelectableOptionWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final contentColor = isSelected
        ? primaryColor
        : theme.textTheme.bodyLarge?.color ?? Colors.grey;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.r12),
      child: Container(
        padding: const EdgeInsets.all(AppSize.p16),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? primaryColor : theme.dividerColor,
          ),
          borderRadius: BorderRadius.circular(AppSize.r12),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: contentColor, size: 20),
              AppSize.p12.width,
            ],
            Text(
              title,
              style: TextStyle(
                color: contentColor,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: isSelected ? contentColor : theme.disabledColor,
            ),
          ],
        ),
      ),
    );
  }
}

// دکمه‌های تایید و انصراف
class ActionButtonsWidget extends StatelessWidget {
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color? confirmColor;

  const ActionButtonsWidget({
    super.key,
    required this.cancelText,
    required this.confirmText,
    required this.onConfirm,
    this.confirmColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ButtonWidget(
            cancelText,
            Get.back,
            textColor: Get.theme.textTheme.bodyMedium?.color,
            radius: AppSize.r12,
          ).outline(),
        ),
        AppSize.p16.width,
        Expanded(
          child: ButtonWidget(
            confirmText,
                () {
              Get.back();
              onConfirm();
            },
            bgColor: confirmColor ?? Get.theme.colorScheme.primary,
            textColor: Colors.white,
            radius: AppSize.r12,
          ).material(),
        ),
      ],
    );
  }
}

// عنوان پاپ‌آپ‌ها
class PopupTitleWidget extends StatelessWidget {
  final String text;
  const PopupTitleWidget(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppSize.f18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}