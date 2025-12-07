import 'package:example/src/commons/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';

import '../widgets/seller_desktop_layout.dart';
import '../widgets/seller_mobile_layout.dart';

class SellerProductsScreen extends StatelessWidget {
  const SellerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: SellerMobileLayout(),
      desktop: SellerDesktopLayout(),
    );
  }
}
