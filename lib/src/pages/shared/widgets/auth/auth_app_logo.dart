import 'package:taav_store/src/commons/constants/app_png.dart';
import 'package:taav_store/src/infoStructure/languages/localization_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthAppLogo extends StatefulWidget {
  final double size;
  final double padding;
  final Color color;
  final Color backgroundColor;
  final bool showGlow;
  final Color? glowColor;
  final bool animated;

  const AuthAppLogo({
    super.key,
    required this.size,
    required this.padding,
    required this.color,
    required this.backgroundColor,
    this.showGlow = false,
    this.glowColor,
    this.animated = false,
  });

  @override
  State<AuthAppLogo> createState() => _AuthAppLogoState();
}

class _AuthAppLogoState extends State<AuthAppLogo>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        duration: const Duration(seconds: 2),
        vsync: this,
      )..repeat(reverse: true);

      _animation = Tween<double>(
        begin: 1.0,
        end: 1.05,
      ).animate(CurvedAnimation(parent: _controller!, curve: Curves.easeInOut));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget logo = Container(
      padding: EdgeInsets.all(widget.padding),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.backgroundColor,
        boxShadow:
            widget.showGlow
                ? [
                  BoxShadow(
                    color:
                        widget.glowColor ?? widget.color.withValues(alpha: 0.2),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ]
                : null,
      ),
      child: GestureDetector(
        onTap: () => Get.find<LocalizationController>().toggleLocale(),
        child: Image.asset(
          AppPng.logo,
          width: widget.size,
          color: widget.color,
        ),
      ),
    );

    if (widget.animated && _animation != null) {
      return AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          return Transform.scale(scale: _animation!.value, child: logo);
        },
      );
    }

    return logo;
  }
}
