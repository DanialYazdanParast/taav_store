import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';
import 'package:flutter/material.dart';

class SellerRevenueSection extends StatelessWidget {
  const SellerRevenueSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildAmountRow(),
        AppSize.p6.height,
        _buildLabelRow(),
      ],
    );
  }

  Widget _buildAmountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          '۴۵,۸۵۰,۰۰۰',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSize.f36,
            fontWeight: FontWeight.w900,
          ),
        ),
        AppSize.p8.width,
        Text(
          'تومان',
          style: TextStyle(
            color: Colors.white70,
            fontSize: AppSize.f14,
          ),
        ),
      ],
    );
  }

  Widget _buildLabelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      textDirection: TextDirection.rtl,
      children: [
        Text(
          ' درآمد کل',
          style: TextStyle(
            color: Colors.white70,
            fontSize: AppSize.f14,
          ),
        ),
        AppSize.p8.width,
        const Icon(
          Icons.remove_red_eye_sharp,
          size: 18,
          color: Colors.white70,
        ),
      ],
    );
  }
}