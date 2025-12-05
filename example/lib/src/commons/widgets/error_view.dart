
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_png.dart';
import 'button/button_widget.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback? onRetry;

  const ErrorView({super.key, this.onRetry});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          GestureDetector(
            onTap: onRetry,
              child: Image.asset(AppPng.error, width: 250, height: 250)),
       //  200.height,
         // 16.height,
         //  Text(
         //    'دسترسی به اینترنت را بررسی و دوباره تلاش نمایید.',
         //    textAlign: TextAlign.center,
         //  //  style: AppTextStyle.headlineSmall,
         //  ),
         //  16.height,
         //  ButtonWidget('تلاش مجدد', onRetry).textOnly(),
        ],
      ),
    );
  }
}
