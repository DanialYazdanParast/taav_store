import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/infoStructure/routes/app_pages.dart';
import 'package:example/src/pages/shared/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/widgets/responsive/responsive.dart';

import '../controllers/seller_account_controller.dart';
import '../widgets/settings_draggable_sheet.dart';
import '../../../shared/widgets/profile_header.dart';
import '../widgets/icon_list.dart';

class SellerAccountScreen extends GetView<SellerAccountController> {
  const SellerAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Responsive(
        mobile: SellerMobileLayout(controller: controller),
        desktop: SellerDesktopLayout(controller: controller),
      ),
    );
  }
}

class SellerMobileLayout extends StatelessWidget {
  final SellerAccountController controller;

  const SellerMobileLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ProfileHeader(
          username: controller.authService.username,
          userType: controller.authService.userType,
          height: 300,
        ),
        SettingsDraggableSheet(onLogout: controller.authService.logout),
      ],
    );
  }
}

class SellerDesktopLayout extends StatelessWidget {
  final SellerAccountController controller;

  const SellerDesktopLayout({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSize.p24),
        child: Container(
          width: 500,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppSize.r16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              ProfileHeader(
                username: controller.authService.username,
                userType: controller.authService.userType,
                height: 300,
              ),


              Padding(
                padding: const EdgeInsets.fromLTRB(AppSize.p32,AppSize.p32,AppSize.p32,8),
                child: MenuItem(
                  icon: Icons.bar_chart_rounded,
                  color: theme.colorScheme.primary,
                  title: 'آمار فروش محصولات',
                  subtitle: 'مشاهده کالاهای پرفروش',
                  showChevron: true,
                  onTap: () => Get.toNamed(AppRoutes.sellerStats),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(AppSize.p32,0,AppSize.p32,AppSize.p32),
                child: IconList(
                  onLogout: controller.authService.logout,
                  showChevron: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
