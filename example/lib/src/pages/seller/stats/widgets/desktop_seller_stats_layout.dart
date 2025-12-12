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

class DesktopSellerStatsLayout extends GetView<SellerStatsController> {
  const DesktopSellerStatsLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: TKeys.salesStatistics.tr,showBackButton: false,),
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

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = constraints.maxWidth > 1100 ? 3 : 2;

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                    ),
                    itemCount: controller.salesStats.length,
                    itemBuilder: (context, index) {
                      return SalesStatCardWidget(
                        stat: controller.salesStats[index],
                        isTopSeller: index == 0,
                        rank: index + 1,
                        isDesktop: true,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}
