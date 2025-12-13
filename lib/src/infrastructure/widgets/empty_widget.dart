import 'package:taav_store/src/infrastructure/constants/app_png.dart';
import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final VoidCallback? onRetry;
  final String? title;

  const EmptyWidget({super.key, this.onRetry, this.title});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SizedBox(width: double.infinity),
          Image.asset(AppPng.empty, width: 250, height: 250),
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            //  style: AppTextStyle.headlineSmall,
          ),
        ],
      ),
    );
  }
}
