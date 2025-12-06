import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormatUtil {
  static final RegExp thousands = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');

  static String currency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(thousands, (m) => '${m[1]},');
  }


}

TextStyle getPriceTextStyle(String priceText) {
  // حذف کاما و فاصله برای شمارش کاراکتر
  final cleanPrice = priceText.replaceAll(RegExp(r'[,\s]'), '');
  final length = cleanPrice.length;

  if (length <= 5) {
    // مثلاً 99999 یا کمتر → بزرگ
    return TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 18);
  } else if (length == 6) {
    // 100000 تا 999999
    return const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16);
  } else if (length == 7) {
    // 1000000 تا 9999999
    return const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15);
  } else {
    // 8 رقم یا بیشتر (مثلاً 10000000+)
    return const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14);
  }
}


class PriceUtils {
  static String calculateDiscountPercent({
    required String originalPrice,
    required String discountedPrice,
  }) {
    try {
      final original = double.parse(originalPrice.replaceAll(RegExp(r'[,\s]'), ''));
      final discounted = double.parse(discountedPrice.replaceAll(RegExp(r'[,\s]'), ''));

      if (original <= discounted || original <= 0) return '0';

      final percent = ((original - discounted) / original) * 100;

      return percent.floor().toString();
    } catch (e) {
      return '0';
    }
  }
}


class ThousandsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    String formatted = digits.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
