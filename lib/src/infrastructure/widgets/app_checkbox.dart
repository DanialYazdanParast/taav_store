import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppCheckbox extends StatelessWidget {
  final bool value;
  final VoidCallback onChanged;

  const AppCheckbox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: value ? context.theme.colorScheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color:
              value
                  ? context.theme.colorScheme.primary
                  : context.theme.colorScheme.outline,
          width: 2,
        ),
      ),
      child:
          value
              ? Icon(
                Icons.check_rounded,
                size: 16,
                color: context.theme.scaffoldBackgroundColor,
              )
              : null,
    );
  }
}
