import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:flutter/material.dart';

class HeaderSheet extends StatelessWidget {
  const HeaderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSize.p16),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(AppSize.r2),
            ),
          ),
        ],
      ),
    );
  }
}
