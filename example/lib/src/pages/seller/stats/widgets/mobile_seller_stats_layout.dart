import 'package:example/src/commons/enums/enums.dart';
import 'package:example/src/commons/widgets/Empty_widget.dart';
import 'package:example/src/commons/widgets/app_loading.dart';
import 'package:example/src/commons/widgets/custom_app_bar.dart';
import 'package:example/src/commons/widgets/error_view.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_stats_controller.dart';
import '../widgets/sales_stat_card_widget.dart';

class MobileSellerStatsLayout extends GetView<SellerStatsController> {
  const MobileSellerStatsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TKeys.salesStatistics.tr),
      body: Obx(() {
        if (controller.pageState.value == CurrentState.loading) {
          return Center(child: AppLoading.circular(size: 50));
        }
        if (controller.pageState.value == CurrentState.error) {
          return ErrorView();
        }
        if (controller.salesStats.isEmpty) {
          return EmptyWidget(title: TKeys.noSalesYet.tr);
        }

        return RefreshIndicator(
          onRefresh: () => controller.loadStats(),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.salesStats.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return SalesStatCardWidget(
                stat: controller.salesStats[index],
                isTopSeller: index == 0,
                rank: index + 1,
                isDesktop: false,
              );
            },
          ),
        );
      }),
    );
  }
}
