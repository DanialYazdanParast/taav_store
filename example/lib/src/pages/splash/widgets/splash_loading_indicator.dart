import 'package:example/src/commons/widgets/app_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashLoadingIndicator extends StatelessWidget {
  const SplashLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLoading.circular(
      size: 25,
      strokeWidth: 2.5,
      color: context.theme.colorScheme.secondary,
    );
  }
}
