import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';

class BottomSheetWidget {
  final bool isScrollControlled;
  final bool isDismissible;
  final bool showDragHandle;
  final Color? backgroundColor;
  final bool? ignoreSafeArea;

  BottomSheetWidget({
    this.isScrollControlled = false,
    this.isDismissible = true,
    this.showDragHandle = true,
    this.backgroundColor,
    this.ignoreSafeArea,
  });

  Future<void> show(final Widget content) async {
    await Get.bottomSheet(
      ignoreSafeArea: ignoreSafeArea ?? false,
      PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) async {},
        child: _buildStructure(content: SafeArea(child: content)),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: true,
      enterBottomSheetDuration: const Duration(milliseconds: 300),
    );
  }

  Widget _buildStructure({required Widget content}) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: backgroundColor ?? Get.theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.r16),
            topRight: Radius.circular(AppSize.r16),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 32,
            offset: const Offset(0, -8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (showDragHandle) ...[
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(AppSize.r2),
                    ),
                  ),
                ],
              ),
            ),
          ],
          content,


        ],
      ),
    );
  }
}
