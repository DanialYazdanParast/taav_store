import 'package:example/src/commons/widgets/text/app_input_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSearchField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onTap;

  // Customization
  final Color? bgColor;
  final double? width;
  final bool isReadOnly;
  final bool isEnabled;
  final bool hideBorder; // برای حالت مدرن بدون کادر
  final double borderRadius; // برای گرد کردن بیشتر مخصوص سرچ
  final EdgeInsetsGeometry? contentPadding;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final bool isTapOutsideActive;

  const AppSearchField({
    super.key,
    this.controller,
    this.hintText = "جستجو...",
    this.onChanged,
    this.onFieldSubmitted,
    this.onTap,
    this.bgColor,
    this.width,
    this.isReadOnly = false,
    this.isEnabled = true,
    this.hideBorder = false,
    // پیش‌فرض را زیاد می‌گذاریم تا کپسولی شود، یا می‌توانید AppSize.brMedium بگذارید
    this.borderRadius = 36,
    this.contentPadding,
    this.prefixWidget,
    this.suffixWidget,
    this.isTapOutsideActive = true,
  });

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  // برای نمایش/مخفی کردن دکمه ضربدر
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();

    // لیسنر برای نمایش دکمه پاک کردن
    _controller.addListener(_onTextChanged);
    _showClearButton = _controller.text.isNotEmpty;
  }

  void _onTextChanged() {
    final shouldShow = _controller.text.isNotEmpty;
    if (_showClearButton != shouldShow) {
      setState(() => _showClearButton = shouldShow);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _onClearTapped() {
    _controller.clear();
    widget.onChanged?.call('');
    setState(() => _showClearButton = false);
  }

  @override
  Widget build(BuildContext context) {
    // --- ساخت استایل‌های اختصاصی با استفاده از AppInputStyles ---

    // ۱. ساخت BorderRadius
    final radius = BorderRadius.circular(widget.borderRadius);

    // ۲. اصلاح بوردرها بر اساس نیاز (مخفی کردن یا گرد کردن)
    final baseBorder =
        widget.hideBorder
            ? OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            )
            : AppInputStyles.normalBorder.copyWith(borderRadius: radius);

    final focusedBorder =
        widget.hideBorder
            ? OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            )
            : AppInputStyles.focusedBorder.copyWith(borderRadius: radius);

    final errorBorder =
        widget.hideBorder
            ? OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            )
            : AppInputStyles.errorBorder.copyWith(borderRadius: radius);

    return SizedBox(
      width: widget.width,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly,

        // تنظیمات کیبورد مخصوص جستجو
        textInputAction: TextInputAction.search,
        keyboardType: TextInputType.text,

        // استایل متن از کلاس شما
        style: AppInputStyles.textStyle,

        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        onTap: widget.onTap,

        onTapOutside: (event) {
          if (widget.isTapOutsideActive) {
            FocusScope.of(context).unfocus();
          }
        },

        decoration: InputDecoration(
          hintText: widget.hintText,
          // استایل هینت از کلاس شما
          hintStyle: AppInputStyles.hintStyle,

          filled: true,
          fillColor: widget.bgColor ?? Get.theme.colorScheme.surface,

          contentPadding:
              widget.contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          // --- Borders (اعمال شده از بالا) ---
          border: baseBorder,
          enabledBorder: baseBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          disabledBorder: AppInputStyles.disabledBorder.copyWith(
            borderRadius: radius,
          ),

          // --- Prefix (آیکون جستجو) ---
          prefixIcon:
              widget.prefixWidget ??
              Icon(Icons.search, color: Get.theme.colorScheme.onSurfaceVariant),

          // --- Suffix (دکمه پاک کردن) ---
          suffixIcon:
              widget.suffixWidget ??
              (_showClearButton && !widget.isReadOnly && widget.isEnabled
                  ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 20,
                      color: Get.theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: _onClearTapped,
                  )
                  : null),
        ),
      ),
    );
  }
}
