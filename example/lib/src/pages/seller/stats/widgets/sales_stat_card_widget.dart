import 'package:example/src/commons/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final formatter = NumberFormat("#,###");

    final borderColor = isTopSeller ? const Color(0xFFFFD700) : theme.dividerColor;
    final double borderWidth = isTopSeller ? (isDesktop ? 3.0 : 2.0) : 1.0;
    final shadowColor = isTopSeller ? const Color(0xFFFFD700).withOpacity(0.3) : Colors.black.withOpacity(0.05);

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(isDesktop ? 20 : 12),
          decoration: BoxDecoration(
            color: theme.cardColor,
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
                width: isDesktop ? 90 : 70,
                height: isDesktop ? 90 : 70,
                borderRadius: 12,
                fit: BoxFit.cover,
              ),
              SizedBox(width: isDesktop ? 24 : 16),

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
                        fontSize: isDesktop ? 18 : 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _StatInfoChip(
                          label: "تعداد فروش:",
                          value: "${stat.totalQuantitySold} عدد",
                          theme: theme,
                        ),

                        Flexible(
                          child: Text(
                            "${formatter.format(stat.totalRevenue)} تومان",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w900,
                              fontSize: isDesktop ? 16 : 14,
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
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events_rounded, size: 16, color: Colors.black87),
                  const SizedBox(width: 4),
                  Text(
                    "پرفروش‌ترین",
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
            left: 12,
            child: Container(
              width: 28,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$rank",
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
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

  const _StatInfoChip({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}