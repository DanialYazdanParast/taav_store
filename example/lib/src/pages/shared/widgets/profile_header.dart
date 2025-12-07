import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:example/src/infoStructure/languages/translation_keys.dart';
import 'package:example/src/pages/shared/widgets/ui_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileHeader extends StatelessWidget {
  final RxString username;
  final RxString userType;
  final double height;

  const ProfileHeader({
    super.key,
    required this.username,
    required this.userType,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.primary.withOpacity(0.05),
            theme.cardColor,
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          const BackgroundParticle(top: 80, right: 110, color: Colors.orange, size: 8),
          const BackgroundParticle(top: 100, left: 100, color: Colors.blue, size: 10),
          const BackgroundParticle(top: 140, right: 110, color: Colors.pinkAccent, size: 6),
          const BackgroundParticle(top: 70, left: 120, color: Colors.teal, size: 8),
          const BackgroundParticle(top: 150, left: 120, color: Colors.amber, size: 7),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAvatar(),
              AppSize.p16.height,
              _buildUsername(theme),
              AppSize.p8.height,
              _buildUserType(theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[50],
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: const Icon(Icons.person, size: 60, color: Colors.blue),
    );
  }

  Widget _buildUsername(ThemeData theme) {
    return Obx(() => Text(
      username.value.isNotEmpty ? username.value : TKeys.guestUser.tr,
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: theme.textTheme.titleLarge?.color,
      ),
    ));
  }

  Widget _buildUserType(ThemeData theme) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p12, vertical: AppSize.p4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        userType.value.tr,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}