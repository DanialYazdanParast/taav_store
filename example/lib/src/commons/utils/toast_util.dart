import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ToastType { success, error, warning, info }

class ToastUtil {
  ToastUtil._();

  static Timer? _debounceTimer;

  static void show(
    String message, {
    ToastType type = ToastType.error,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
  }) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 250), () {
      final style = _getToastStyle(type);

      if (Get.context == null) return;

      Get.snackbar(
        '',
        '',
        titleText: const SizedBox(height: 0, width: 0),
        icon: null,
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(style.icon, color: style.iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: style.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'IranSans',
                  height: 1.2,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),

        backgroundColor: style.backgroundColor,
        snackStyle: SnackStyle.FLOATING,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        borderRadius: 12,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        snackPosition: position,
        duration: duration,
        animationDuration: const Duration(milliseconds: 500),
        isDismissible: true,
      );
    });
  }

  static _ToastStyle _getToastStyle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _ToastStyle(
          backgroundColor: const Color(0xFF4CAF50),
          icon: Icons.check_circle_outline_rounded,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
      case ToastType.error:
        return _ToastStyle(
          backgroundColor: const Color(0xFFE53935),
          icon: Icons.error_outline_rounded,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
      case ToastType.warning:
        return _ToastStyle(
          backgroundColor: const Color(0xFFFFC107),
          icon: Icons.warning_amber_rounded,
          textColor: Colors.black87,
          iconColor: Colors.black87,
        );
      case ToastType.info:
        return _ToastStyle(
          backgroundColor: const Color(0xFF2196F3),
          icon: Icons.info_outline_rounded,
          textColor: Colors.white,
          iconColor: Colors.white,
        );
    }
  }
}

class _ToastStyle {
  final Color backgroundColor;
  final IconData icon;
  final Color textColor;
  final Color iconColor;

  _ToastStyle({
    required this.backgroundColor,
    required this.icon,
    required this.textColor,
    required this.iconColor,
  });
}
