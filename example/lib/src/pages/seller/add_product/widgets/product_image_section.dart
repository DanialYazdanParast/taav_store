import 'dart:io';
import 'package:example/src/pages/shared/widgets/ui_components.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/pages/shared/widgets/icon_button_widget.dart';

class ProductImageSection extends StatelessWidget {
  final XFile? selectedImage;
  final String? existingImageUrl;
  final VoidCallback onTapPick;
  final VoidCallback onTapRemove;

  const ProductImageSection({
    super.key,
    this.selectedImage,
    this.existingImageUrl,
    required this.onTapPick,
    required this.onTapRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final hasImage =
        selectedImage != null ||
        (existingImageUrl != null && existingImageUrl!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 30,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha:  0.5),
                borderRadius: BorderRadius.circular(AppSize.r12),
              ),
            ),
            8.width,
            Text(
              TKeys.productImage.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: AppSize.f16,
                color: Get.theme.textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),

        AppSize.p12.height,

        hasImage
            ? _buildSelectedImage(theme)
            : _buildPlaceholder(theme, context),
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme, BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        onTapPick();
      },
      borderRadius: BorderRadius.circular(AppSize.r16),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.3,
          ),
          borderRadius: BorderRadius.circular(AppSize.r16),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSize.p16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add_photo_alternate_rounded,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
            AppSize.p12.height,
            Text(
              TKeys.uploadImage.tr,
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImage(ThemeData theme) {
    ImageProvider imageProvider;

    if (selectedImage != null) {
      if (kIsWeb) {
        imageProvider = NetworkImage(selectedImage!.path);
      } else {
        imageProvider = FileImage(File(selectedImage!.path));
      }
    } else {
      imageProvider = NetworkImage(existingImageUrl!);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSize.r16),
      child: Stack(
        children: [
          Image(
            image: imageProvider,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          Positioned(
            top: 10,
            right: 10,
            child: IconButtonWidget(
              icon: Icons.delete_outline_rounded,
              onTap: onTapRemove,
              bgColor: Colors.red.withValues(alpha: 0.9),
              color: Colors.white,
              size: 20,
            ),
          ),

          Positioned(
            top: 10,
            left: 10,
            child: IconButtonWidget(
              icon: Icons.edit_rounded,
              onTap: onTapPick,
              bgColor: Colors.black.withValues(alpha: 0.6),
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
