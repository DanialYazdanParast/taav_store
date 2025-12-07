import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_loading.dart';

class TaavNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final Color? backgroundColor;

  const TaavNetworkImage(
    this.imageUrl, {
    super.key,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    if (imageUrl.isEmpty) {
      return _buildPlaceholder(theme);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color:
            backgroundColor ??
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        child: Image.network(
          imageUrl,
          width: width,
          height: height,
          fit: fit,

          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Center(
              child: AppLoading.circular(
                size: (width != null && width! < 40) ? 15 : 24,
                color: theme.primaryColor,
              ),
            );
          },

          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget(theme);
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme) {
    return Container(
      alignment: Alignment.center,
      color: theme.colorScheme.errorContainer.withOpacity(0.3),
      child: Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.error,
        size: (width != null && width! < 50) ? 20 : 30,
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
        alignment: Alignment.center,
        child: Icon(
          Icons.image_outlined,
          color: theme.hintColor,
          size: (width != null && width! < 50) ? 20 : 30,
        ),
      ),
    );
  }
}
