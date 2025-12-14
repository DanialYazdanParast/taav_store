import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/app_radio.dart';
import 'package:taav_store/generated/locales.g.dart';
import 'package:taav_store/src/pages/shared/widgets/auth/auth_input_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/register_controller.dart';

class UserTypeSelector extends GetView<RegisterController> {
  const UserTypeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AuthInputLabel(
          text: LocaleKeys.accountType.tr,
          icon: Icons.badge_outlined,
          style: AuthInputLabelStyle.secondary,
        ),
        12.height,
        Obx(
          () => Row(
            children: [
              RadioOption(
                title: LocaleKeys.buyer.tr,
                isSelected: controller.userType.value == UserType.buyer,
                onTap: () => controller.userType.value = UserType.buyer,
              ),
              24.width,
              RadioOption(
                title: LocaleKeys.seller.tr,
                isSelected: controller.userType.value == UserType.seller,
                onTap: () => controller.userType.value = UserType.seller,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RadioOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const RadioOption({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppRadio(isSelected: isSelected, onTap: onTap),
          8.width,
          Text(
            title,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color:
                  isSelected
                      ? colorScheme.secondary
                      : colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
