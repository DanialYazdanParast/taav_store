import 'package:flutter/material.dart';

extension SpaceExtension on num {
  /// Usage: 10.height
  SizedBox get height => SizedBox(height: toDouble());

  /// Usage: 20.width
  SizedBox get width => SizedBox(width: toDouble());
}
