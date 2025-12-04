import 'package:example/src/commons/constants/app_size.dart';
import 'package:flutter/material.dart';

class SellerIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final Color? bgColor;
  final bool hasBorder;
  final double? size;

  const SellerIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color,
    this.bgColor,
    this.hasBorder = false,
    this.size,
  });

  @override
  State<SellerIconButton> createState() => _SellerIconButtonState();
}

class _SellerIconButtonState extends State<SellerIconButton> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHover = true),
      onExit: (_) => setState(() => isHover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(AppSize.r10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppSize.p8),
          decoration: BoxDecoration(
            color: widget.bgColor ??
                (isHover
                    ? Colors.white.withOpacity(0.25)
                    : Colors.white.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(AppSize.r10),
            border: widget.hasBorder
                ? Border.all(color: theme.dividerColor)
                : null,
          ),
          child: Icon(
            widget.icon,
            size: widget.size ?? 22,
            color: widget.color ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
