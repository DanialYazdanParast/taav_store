import 'package:flutter/material.dart';
import 'package:get/get.dart';

// -----------------------------------------------------------------------------
// اکستنشن‌های مربوط به String
// -----------------------------------------------------------------------------
extension StringExtensions on String {

  /// تبدیل کد Hex به ویجت Color
  /// این همان کدی است که قبلاً اسمش colorObj بود
  Color get toColor {
    try {
      // در اینجا this همان رشته هگز (hex) است
      String hexString = replaceAll('#', '');

      if (hexString.length == 6) {
        hexString = 'FF$hexString'; // افزودن Alpha اگر نباشد
      }

      return Color(int.parse('0x$hexString'));
    } catch (e) {
      // در صورت خطا رنگ مشکی برمی‌گرداند (طبق منطق خودت)
      return Colors.black;
    }
  }

  /// تبدیل هوشمند اعداد متن به فارسی یا انگلیسی بر اساس زبان GetX
  String get toLocalizedDigit {
    bool isFarsi = Get.locale?.languageCode == 'fa';
    if (isFarsi) {
      return _toPersianDigit(this);
    } else {
      return _toEnglishDigit(this);
    }
  }
}

// -----------------------------------------------------------------------------
// اکستنشن‌های مربوط به Color
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// اکستنشن‌های مربوط به اعداد (int, double, num)
// -----------------------------------------------------------------------------
extension PriceExtensions on num {

  /// فرمت قیمت (سه رقم سه رقم) + تبدیل هوشمند به زبان برنامه
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

// -----------------------------------------------------------------------------
// توابع کمکی (Private)
// -----------------------------------------------------------------------------
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