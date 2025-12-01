import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';

import 'splash_content.dart';
import 'splash_version_footer.dart';

class SplashBody extends StatelessWidget {
  final double logoWidth;

  const SplashBody({super.key, required this.logoWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: SplashContent(logoWidth: logoWidth)),
        SplashVersionFooter(),
        20.height,
      ],
    );
  }
}
