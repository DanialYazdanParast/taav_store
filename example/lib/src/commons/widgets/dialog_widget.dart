import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';

class DialogWidget {
  final bool isDismissible;
  final Color? backgroundColor;
  final Color? barrierColor;
  final bool canPop;
  final double maxWidth;

  DialogWidget({
    this.isDismissible = true,
    this.canPop = true,
    this.backgroundColor,
    this.barrierColor,
    this.maxWidth = 800,
  });

  Future<void> show(final Widget content) async {
    await Get.dialog(
      PopScope(
        canPop: canPop,
        onPopInvokedWithResult: (didPop, result) async {},
        child: _buildStructure(content: content),
      ),
      barrierDismissible: isDismissible,
      barrierColor: barrierColor ?? Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      transitionCurve: Curves.easeOutBack,
    );
  }

  Widget _buildStructure({required Widget content}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: AppSize.p24),
            padding: const EdgeInsets.all(AppSize.p24),
            decoration: ShapeDecoration(
              color: backgroundColor ?? Get.theme.scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.r16),
              ),
              shadows: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [content],
            ),
          ),
        ),
      ),
    );
  }
}
