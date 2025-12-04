
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


  Color get colorObj {
    String hexString = hex.replaceAll('#', '');
    if (hexString.length == 6) hexString = 'FF$hexString';
    try {
      return Color(int.parse('0x$hexString'));
    } catch (e) {
      return Colors.black;
    }
  }
}
