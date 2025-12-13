import 'package:taav_store/src/infrastructure/widgets/button/button_widget.dart';
import 'package:taav_store/src/infrastructure/widgets/dialog_widget.dart';
import 'package:taav_store/generated/locales.g.dart';
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
            LocaleKeys.deleteProductTitle.tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            LocaleKeys.confirmDeleteProductMsg.tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child:
                    ButtonWidget(
                      LocaleKeys.cancel.tr,
                      () => Get.back(),
                      textColor: Get.theme.colorScheme.onSurface,
                    ).outline(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child:
                    ButtonWidget(
                      LocaleKeys.deleteAction.tr,
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
