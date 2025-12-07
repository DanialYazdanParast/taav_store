import 'package:flutter/material.dart';

/// کلاس تنظیمات استایل برای شخصی‌سازی کامل
class CountControlStyle {
  final Color primaryColor;       // رنگ اصلی (مثلاً قرمز دیجی‌کالا)
  final Color backgroundColor;    // رنگ پس‌زمینه کانتر (سفید)
  final Color contentColor;       // رنگ آیکون‌ها و متون در حالت کانتر
  final Color disabledColor;      // رنگ دکمه غیرفعال
  final TextStyle textStyle;      // استایل عدد وسط
  final TextStyle btnTextStyle;   // استایل متن دکمه "افزودن"
  final double borderRadius;      // گردی گوشه‌ها
  final BorderSide? borderSide;   // تنظیمات بوردر (رنگ و ضخامت)
  final List<BoxShadow>? shadows; // سایه

  const CountControlStyle({
    this.primaryColor = const Color(0xFFEF394E),
    this.backgroundColor = Colors.white,
    this.contentColor = const Color(0xFFEF394E),
    this.disabledColor = const Color(0xFFE0E0E0), // رنگ طوسی برای حالت غیرفعال
    this.textStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    this.btnTextStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
    this.borderRadius = 8.0,
    this.borderSide = const BorderSide(color: Color(0xFFE0E0E0)),
    this.shadows,
  });
}

class AdvancedCountControl extends StatelessWidget {
  // ─── Data ───
  final int currentQuantity;
  final int maxQuantity;
  final bool isLoading;

  // ✅ اضافه شد: وضعیت غیرفعال بودن
  final bool isDisabled;

  // ─── Configuration ───
  final bool showAddButton;
  final String addButtonLabel;
  final String maxReachedLabel;
  final double height;
  final double? width;

  // ─── Actions ───
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback? onAddTap;

  // ─── Styling ───
  final CountControlStyle style;
  final String Function(String)? numberFormatter;

  const AdvancedCountControl({
    super.key,
    required this.currentQuantity,
    required this.onIncrease,
    required this.onDecrease,
    this.maxQuantity = 999,
    this.isLoading = false,
    this.isDisabled = false, // ✅ مقدار پیش‌فرض
    this.showAddButton = true,
    this.addButtonLabel = "افزودن به سبد خرید",
    this.maxReachedLabel = "حداکثر",
    this.height = 48,
    this.width,
    this.onAddTap,
    this.style = const CountControlStyle(),
    this.numberFormatter,
  });

  @override
  Widget build(BuildContext context) {
    // اگر تعداد ۰ بود و دکمه افزودن فعال بود -> حالت دکمه
    final bool isAddMode = showAddButton && currentQuantity == 0;

    return SizedBox(
      height: height,
      width: width,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: isAddMode ? _buildAddButton() : _buildCounter(),
      ),
    );
  }

  /// حالت ۱: دکمه افزودن به سبد خرید (تک دکمه)
  Widget _buildAddButton() {
    return SizedBox(
      key: const ValueKey('addButton'),
      width: double.infinity,
      height: double.infinity,
      child: ElevatedButton(
        // ✅ اگر isDisabled یا isLoading باشد، دکمه غیرفعال می‌شود (null)
        onPressed: (isDisabled || isLoading) ? null : (onAddTap ?? onIncrease),
        style: ElevatedButton.styleFrom(
          // ✅ تغییر رنگ بر اساس وضعیت غیرفعال
          backgroundColor: isDisabled ? style.disabledColor : style.primaryColor,
          // اگر غیرفعال باشد رنگ متن تغییر می‌کند (معمولا خود فلاتر هندل می‌کند اما اینجا دستی هم ست می‌کنیم)
          foregroundColor: Colors.white,
          disabledBackgroundColor: style.disabledColor,
          disabledForegroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(style.borderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
        )
            : Text(addButtonLabel, style: style.btnTextStyle),
      ),
    );
  }

  /// حالت ۲: شمارنده (منفی - عدد - مثبت)
  /// حالت ۲: شمارنده (منفی - عدد - مثبت)
  Widget _buildCounter() {
    final bool isMaxReached = currentQuantity >= maxQuantity;
    final bool isTrashMode = currentQuantity == 1;

    return Container(
      key: const ValueKey('counterControl'),
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(style.borderRadius),
        border: style.borderSide != null ? Border.fromBorderSide(style.borderSide!) : null,
        boxShadow: style.shadows,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ─── دکمه افزایش (+) ───
          _CounterIconButton(
            icon: Icons.add,
            onTap: (isMaxReached || isDisabled) ? null : onIncrease,
            color: (isMaxReached || isDisabled) ? style.disabledColor : style.primaryColor,
          ),

          // ─── نمایش عدد و وضعیت (اصلاح شده برای جلوگیری از Overflow) ───
          // ✅ 1. استفاده از Expanded برای گرفتن فضای میانی
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ✅ 2. استفاده از FittedBox برای کوچک کردن سایز متن در صورت بزرگ بودن عدد
                FittedBox(
                  fit: BoxFit.scaleDown, // فقط کوچک شود، بزرگ نشود
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0), // فاصله ایمنی
                    child: Text(
                      _formatNumber(currentQuantity),
                      style: style.textStyle.copyWith(
                        color: isDisabled ? style.disabledColor : style.contentColor,
                        // ارتفاع خط را فیکس میکنیم تا پرش نداشته باشد
                        height: 1.0,
                      ),
                      maxLines: 1, // حتما تک خط باشد
                    ),
                  ),
                ),

                if (isMaxReached && !isDisabled)
                // برای متن "حداکثر" هم همین کار را میکنیم که اگر طولانی بود جا شود
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      maxReachedLabel,
                      style: style.textStyle.copyWith(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                    ),
                  ),
              ],
            ),
          ),

          // ─── دکمه کاهش (-) یا سطل زباله ───
          _CounterIconButton(
            icon: isTrashMode ? Icons.delete_outline_rounded : Icons.remove,
            onTap: isDisabled ? null : onDecrease,
            color: isDisabled ? style.disabledColor : style.contentColor,
            iconSize: isTrashMode ? 20 : 24,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    String str = number.toString();
    if (numberFormatter != null) {
      return numberFormatter!(str);
    }
    return str;
  }
}

/// ویجت داخلی برای دکمه‌های آیکون دار (+ و -)
class _CounterIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color color;
  final double iconSize;

  const _CounterIconButton({
    required this.icon,
    required this.color,
    this.onTap,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 48,
          height: double.infinity,
          child: Icon(icon, color: color, size: iconSize),
        ),
      ),
    );
  }
}