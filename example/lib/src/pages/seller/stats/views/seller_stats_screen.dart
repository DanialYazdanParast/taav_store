import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/seller_stats_controller.dart';
import '../models/seller_sales_stat_model.dart';

class SellerStatsScreen extends GetView<SellerStatsController> {
  const SellerStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "آمار فروش محصولات",
          style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.pageState.value == CurrentState.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.salesStats.isEmpty) {
          return const Center(child: Text("هنوز فروشی ثبت نشده است"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.salesStats.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final stat = controller.salesStats[index];
            final isTopSeller = index == 0;

            return _SalesStatCard(
              stat: stat,
              isTopSeller: isTopSeller,
              rank: index + 1,
            );
          },
        );
      }),
    );
  }
}

class _SalesStatCard extends StatelessWidget {
  final SellerSalesStatModel stat;
  final bool isTopSeller;
  final int rank;

  const _SalesStatCard({
    required this.stat,
    required this.isTopSeller,
    required this.rank,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = NumberFormat("#,###");


    final borderColor =
        isTopSeller
            ? const Color(0xFFFFD700)
            : theme.dividerColor;
    final borderWidth = isTopSeller ? 2.0 : 1.0;
    final shadowColor =
        isTopSeller
            ? const Color(0xFFFFD700).withOpacity(0.3)
            : Colors.black.withOpacity(0.05);

    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
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
              // عکس محصول
              TaavNetworkImage(
                stat.image,
                width: 70,
                height: 70,
                borderRadius: 12,
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoChip(
                          label: "تعداد فروش:",
                          value: "${stat.totalQuantitySold} عدد",
                          theme: theme,
                          isHighlight: true,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: FittedBox(
                            child: Text(
                              "${formatter.format(stat.totalRevenue)} تومان",
                              textAlign: TextAlign.end,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
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
                color: Color(0xFFFFD700), // طلایی
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.emoji_events_rounded,
                    size: 16,
                    color: Colors.black87,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "پرفروش‌ترین",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
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
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Text(
                "$rank",
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

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool isHighlight;

  const _InfoChip({
    required this.label,
    required this.value,
    required this.theme,
    this.isHighlight = false,
  });

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
            color: isHighlight ? theme.colorScheme.onSurface : null,
          ),
        ),
      ],
    );
  }
}
