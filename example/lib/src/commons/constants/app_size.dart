import 'package:flutter/material.dart';

class AppSize {
  AppSize._();

  static const double buttonHeight = 56.0;

  // Padding & Margins (Sorted Small to Large)
  static const double p2 = 2.0;
  static const double p4 = 4.0;
  static const double p5 = 5.0;
  static const double p6 = 6.0;
  static const double p8 = 8.0;
  static const double p10 = 10.0;
  static const double p12 = 12.0;
  static const double p16 = 16.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p32 = 32.0;

  // Border Radius (Sorted Small to Large)
  static const double r2 = 2.0;
  static const double r4 = 4.0;
  static const double r5 = 5.0;
  static const double r6 = 6.0;
  static const double r8 = 8.0;
  static const double r12 = 12.0;
  static const double r15 = 15.0;
  static const double r16 = 16.0;
  static const double r36 = 36.0;

  // Semantic Radius Names (Optional aliases)
  static const double rSmall = r4;
  static const double rMedium = r8;
  static const double rLarge = r16;

  // BorderRadius Objects (Pre-defined)
  static final BorderRadius brSmall = BorderRadius.circular(rSmall);
  static final BorderRadius brMedium = BorderRadius.circular(rMedium);
  static final BorderRadius brLarge = BorderRadius.circular(rLarge);

  // Custom Helper
  static BorderRadius brCircular(double size) => BorderRadius.circular(size);

  // Font Sizes (Sorted Small to Large)
  static const double f8 = 8.0;
  static const double f10 = 10.0;
  static const double f11 = 11.0;
  static const double f12 = 12.0;
  static const double f13 = 13.0;
  static const double f14 = 14.0;
  static const double f15 = 15.0;
  static const double f16 = 16.0;
  static const double f17 = 17.0;
  static const double f18 = 18.0;
  static const double f20 = 20.0;
  static const double f24 = 24.0;
  static const double f26 = 26.0;
  static const double f32 = 32.0;
  static const double f36 = 36.0;
  static const double f72 = 72.0;
}
