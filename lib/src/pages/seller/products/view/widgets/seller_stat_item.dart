import 'package:taav_store/src/infrastructure/constants/app_size.dart';
import 'package:taav_store/src/infrastructure/enums/enums.dart';
import 'package:taav_store/src/infrastructure/extensions/ext.dart';
import 'package:taav_store/src/infrastructure/extensions/space_extension.dart';
import 'package:taav_store/src/infrastructure/widgets/app_shimmer.dart';
import 'package:flutter/material.dart';

class SellerStatItem extends StatelessWidget {
  final String value;
  final String label;
  final String? unit;
  final IconData icon;
  final Color textColor;
  final Color subColor;
  final CurrentState state;
  final double? valueSize;
  final double? iconSize;

  const SellerStatItem({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.textColor,
    required this.subColor,
    this.unit,
    this.state = CurrentState.idle,
    this.valueSize,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: subColor, size: iconSize ?? 28),
        AppSize.p10.height,

        state == CurrentState.loading || state == CurrentState.error
            ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: AppShimmer.rect(
                width: 50,
                height: valueSize ?? AppSize.f24,
                borderRadius: 6,
              ),
            )
            : FittedBox(
              fit: BoxFit.scaleDown,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: value.toLocalizedPrice,
                        style: TextStyle(
                          color: textColor,
                          fontSize: valueSize ?? AppSize.f24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      if (unit != null) ...[
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: unit,
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                            fontSize: (valueSize ?? AppSize.f24) * 0.55,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

        AppSize.p5.height,

        Text(
          label,
          style: TextStyle(
            color: subColor,
            fontSize: AppSize.f13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
