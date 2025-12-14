import 'dart:convert';
import 'dart:typed_data';
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

    final bgColor = backgroundColor ??
        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3);

    if (imageUrl.isEmpty) {
      return _buildPlaceholder(theme, bgColor);
    }

    Widget imageWidget;


    if (imageUrl.startsWith('http')) {
      imageWidget = Image.network(
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
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(theme, bgColor),
      );
    }
    else {
      try {

        String cleanBase64 = imageUrl;
        if (cleanBase64.contains(',')) {
          cleanBase64 = cleanBase64.split(',').last;
        }

        Uint8List bytes = base64Decode(cleanBase64);
        imageWidget = Image.memory(
          bytes,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(theme, bgColor),
        );
      } catch (e) {
        imageWidget = _buildErrorWidget(theme, bgColor);
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: bgColor,
        child: imageWidget,
      ),
    );
  }

  Widget _buildErrorWidget(ThemeData theme, Color bgColor) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      color: bgColor,
      child: Icon(
        Icons.broken_image_outlined,
        color: theme.colorScheme.error,
        size: (width != null && width! < 50) ? 20 : 30,
      ),
    );
  }

  Widget _buildPlaceholder(ThemeData theme, Color bgColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Container(
        width: width,
        height: height,
        color: bgColor,
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