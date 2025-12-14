
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
