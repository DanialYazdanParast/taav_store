import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/network_image.dart';
import 'package:taav_store/src/infrastructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/seller_sales_stat_model.dart';

class SalesStatCardWidget extends StatelessWidget {
  final SellerSalesStatModel stat;
  final bool isTopSeller;
  final int rank;
  final bool isDesktop;

  const SalesStatCardWidget({
    super.key,
    required this.stat,
    required this.isTopSeller,
    required this.rank,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final borderColor =
        isTopSeller
            ? theme.colorScheme.primary
            : theme.colorScheme.outlineVariant.withValues(alpha: 0.5);
    final double borderWidth = isTopSeller ? (isDesktop ? 3.0 : 2.0) : 1.0;
    final shadowColor =
        isTopSeller
            ? theme.colorScheme.primary.withValues(alpha: 0.3)
            : Colors.black.withValues(alpha: 0.05);

    final double imageSize = isDesktop ? 90 : 70;
    final double horizontalSpacing = isDesktop ? 24 : 16;
    final double cardPadding = isDesktop ? 20 : 12;
    final double titleFontSize = isDesktop ? 18 : 14;
    final double priceFontSize = isDesktop ? 16 : 14;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: isTopSeller ? 15 : 5,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              TaavNetworkImage(
                stat.image,
                width: imageSize,
                height: imageSize,
                borderRadius: 12,
                fit: BoxFit.cover,
              ),
              SizedBox(width: horizontalSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      stat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: titleFontSize,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _StatInfoChip(
                          label: TKeys.soldCount.tr,
                          value:
                              "${stat.totalQuantitySold.toString().toLocalizedDigit} ${TKeys.countUnit.tr}",
                          theme: theme,
                          isDesktop: isDesktop,
                        ),

                        AppSize.p8.height,

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "${stat.totalRevenue.toLocalizedPrice} ${TKeys.currency.tr}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: priceFontSize,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        if (isTopSeller)
          Positioned(
            top: 0,
            left: isRtl ? cardPadding : null,
            right: isRtl ? null : cardPadding,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(AppSize.r10),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: AppSize.f16,
                    color: Colors.black87,
                  ),
                  4.width,
                  Text(
                    TKeys.bestSeller.tr,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),

        if (!isTopSeller)
          Positioned(
            top: 12,
            left: isRtl ? cardPadding : null,
            right: isRtl ? null : cardPadding,
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                rank.toString().toLocalizedDigit,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _StatInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool isDesktop;

  const _StatInfoChip({
    required this.label,
    required this.value,
    required this.theme,
    this.isDesktop = false,
  });

  @override
  Widget build(BuildContext context) {
    final double labelFontSize = isDesktop ? 12 : 11;
    final double valueFontSize = isDesktop ? 14 : 12;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                fontSize: labelFontSize,
              ),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: valueFontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
