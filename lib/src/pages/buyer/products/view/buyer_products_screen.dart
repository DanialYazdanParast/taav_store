import 'package:taav_store/src/infrastructure/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import '../widgets/buyer_desktop_layout.dart';
import '../widgets/buyer_mobile_layout.dart';

class BuyerProductsScreen extends StatelessWidget {
  const BuyerProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: BuyerMobileLayout(),
      desktop: BuyerDesktopLayout(),
    );
  }
}
