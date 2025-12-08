import 'package:flutter/material.dart';

class ColorModel {
  final String id;
  final String name;
  final String hex;

  ColorModel({required this.id, required this.name, required this.hex});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      hex: json['hex'] ?? '#000000',
    );
  }
}
