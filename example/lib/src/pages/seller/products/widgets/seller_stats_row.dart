import 'package:example/src/commons/constants/app_size.dart';
import 'package:flutter/material.dart';

import 'seller_stat_item.dart';

class SellerStatsRowMobile extends StatelessWidget {
  const SellerStatsRowMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.p24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SellerStatItem(
            value: '۲۴',
            label: 'محصولات',
            icon: Icons.inventory_2_outlined,
            textColor: Colors.white,
            subColor: Colors.white70,
          ),
          _buildDivider(),
          const SellerStatItem(
            value: '۱۵۶',
            label: 'فروش',
            icon: Icons.shopping_cart_outlined,
            textColor: Colors.white,
            subColor: Colors.white70,
          ),
          _buildDivider(),
          const SellerStatItem(
            value: '۸',
            label: 'سفارش جدید',
            icon: Icons.local_shipping_outlined,
            textColor: Colors.white,
            subColor: Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white24,
    );
  }
}