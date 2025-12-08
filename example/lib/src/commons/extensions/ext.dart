import 'package:flutter/material.dart';
import 'package:get/get.dart';


extension StringExtensions on String {


  Color get toColor {
    try {
      String hexString = replaceAll('#', '');

      if (hexString.length == 6) {
        hexString = 'FF$hexString';
      }

      return Color(int.parse('0x$hexString'));
    } catch (e) {

      return Colors.black;
    }
  }

  String get toLocalizedDigit {
    bool isFarsi = Get.locale?.languageCode == 'fa';
    if (isFarsi) {
      return _toPersianDigit(this);
    } else {
      return _toEnglishDigit(this);
    }
  }
}


extension PriceExtensions on num {

  String get toLocalizedPrice {
    String result = toString();
    if (result.contains('.')) {
      result = result.split('.')[0];
    }
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    String formatted = result.replaceAllMapped(reg, (Match match) => '${match[1]},');
    return formatted.toLocalizedDigit;
  }
}


String _toPersianDigit(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], persian[i]);
  }
  return input;
}

String _toEnglishDigit(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const persian = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < persian.length; i++) {
    input = input.replaceAll(persian[i], english[i]);
  }
  return input;
}