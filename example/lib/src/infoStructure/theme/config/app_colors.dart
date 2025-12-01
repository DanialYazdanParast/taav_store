import 'package:flutter/material.dart';

class LightThemeColors {
  // 🌟 رنگ‌های اصلی
  static const primaryColor = Color.fromARGB(255, 128, 141, 125);
  static const onprimaryColor = Color(0xD6F8F8F8);
  static const secondaryColor = Color(0xFFf8f8f8);
  static const onsecondaryColor = Color(0xFFEEEEEE);

  // 📝 رنگ‌های متن
  static const textPrimary = Color(0xff212121);
  static const textSecondary = Color(0xff6e6e6e);

  // 🔳 رنگ‌های خطوط و جداکننده‌ها
  static const Color borderColor = Color(0x1A000000);
  static const Color gray300 = Color(
    0xB3E0E0E0,
  ); // رنگ خاکستری (استفاده شده برای جداکننده‌ها)
  static const Color dividerColor = Color(0xB3E0E0E0); // رنگ خط جداکننده
}

class DarkThemeColors {
  // 🌟 رنگ‌های اصلی
  static const primaryColor = Color.fromARGB(
    255,
    14,
    49,
    154,
  ); // رنگ اصلی پس‌زمینه
  static const onprimaryColor = Color(0xd6212121); // رنگ روی پس‌زمینه اصلی
  static const secondaryColor = Color(0xFF181818); // رنگ پس‌زمینه ثانویه
  static const onsecondaryColor = Color(0xFF262626); // رنگ روی پس‌زمینه ثانویه

  // 📝 رنگ‌های متن
  static const textPrimary = Color(0xffffffff); // رنگ متن اصلی (سفید)
  static const textSecondary = Color(
    0xffb3b3b3,
  ); // رنگ متن ثانویه (خاکستری روشن)

  // 🔳 رنگ‌های خطوط و جداکننده‌ها
  static const Color borderColor = Color(0x1affffff); // رنگ مرزها
  static const Color dividerColor = Color(0xFF323232); // رنگ خط جداکننده
}
