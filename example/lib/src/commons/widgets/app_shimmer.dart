import 'package:flutter/material.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color? baseColor;
  final Color? highlightColor;

  const AppShimmer({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
    this.baseColor,
    this.highlightColor,
  });

  /// Factory method for rectangular skeletons (Best Practice for DX)
  static Widget rect({
    double? width,
    double? height,
    double borderRadius = 8,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return AppShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black, // The color creates the mask shape
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  /// Factory method for circular skeletons
  static Widget circle({
    required double size,
    Color? baseColor,
    Color? highlightColor,
  }) {
    return AppShimmer(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    // Using a simple linear tween for sliding effect
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Senior approach: Rely on Context/Theme, not external packages like GetX
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Define default colors based on active theme standard
    final base =
        widget.baseColor ??
        (isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0));

    final highlight =
        widget.highlightColor ??
        (isDark ? const Color(0xFF616161) : const Color(0xFFF5F5F5));

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [base, highlight, base],
              stops: const [
                0.1,
                0.3,
                0.5,
              ], // Tighter stops for better shimmer effect
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Using Transform is more efficient than calculating pixels manually in build
class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform(this.slidePercent);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
