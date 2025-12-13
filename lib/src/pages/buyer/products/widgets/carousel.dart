import 'dart:async';

import 'package:taav_store/src/infrastructure/constants/app_png.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final int autoPlaySeconds;
  final double height;

  const Carousel({super.key, this.autoPlaySeconds = 5, this.height = 180});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  late PageController _controller;
  Timer? _timer;
  int _current = 0;

  final List<String> _bannerImages = [
    AppPng.baner1,
    AppPng.baner2,
    AppPng.baner3,
    AppPng.baner4,
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 1000, viewportFraction: 0.85);

    _timer = Timer.periodic(
      Duration(seconds: widget.autoPlaySeconds),
      (_) => _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged:
                (i) => setState(() => _current = i % _bannerImages.length),
            itemBuilder: (context, i) {
              final imagePath = _bannerImages[i % _bannerImages.length];

              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),

                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              );
            },
          ),

          Positioned(
            bottom: 18,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    _bannerImages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _current == i ? 18 : 7,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: _current == i ? Colors.white : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
