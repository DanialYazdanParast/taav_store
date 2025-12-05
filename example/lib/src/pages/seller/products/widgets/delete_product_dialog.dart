import 'package:example/src/commons/widgets/button/button_widget.dart';
import 'package:example/src/commons/widgets/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeleteProductDialog {
  static Future<void> show({
    required String productName,
    required VoidCallback onConfirm,
  }) async {
    final dialog = DialogWidget(maxWidth: 500);

    await dialog.show(

      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "حذف محصول",
            textAlign: TextAlign.center,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "آیا مطمئن هستید که می‌خواهید محصول\n\"$productName\" را حذف کنید؟",
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child:
                ButtonWidget(
                  "لغو",
                      () => Get.back(),
                  textColor: Get.theme.colorScheme.onSurface,
                ).outline(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                ButtonWidget(
                  "حذف",
                  onConfirm,
                  bgColor: Colors.red,
                  textColor: Colors.white,
                ).material(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}