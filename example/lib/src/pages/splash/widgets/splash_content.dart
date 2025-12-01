import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';

import 'animated_logo.dart';
import 'splash_loading_indicator.dart';

class SplashContent extends StatelessWidget {
  final double logoWidth;

  const SplashContent({super.key, required this.logoWidth});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedLogo(width: logoWidth),
          20.height,
          SplashLoadingIndicator(),
        ],
      ),
    );
  }
}
