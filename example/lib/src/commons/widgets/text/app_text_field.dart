import 'package:example/src/commons/widgets/text/app_input_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:example/src/commons/constants/app_size.dart';
import 'package:example/src/commons/extensions/space_extension.dart';

class AppTextField extends StatefulWidget {
  final String? labelText;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autoValidateMode;
  final VoidCallback? onEditingComplete;
  final VoidCallback? onTap;
  final FormFieldSetter<String>? onSaved;

  final bool isEnabled;
  final bool isReadOnly;
  final bool isObscureText;
  final bool isAutoFocus;

  final int? maxLength;
  final int? minLines;
  final int? maxLines;

  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  final TextAlign textAlign;
  final TextDirection? textDirection;

  final String? helperText;
  final String? hintText;

  // Prefix & Suffix
  final String? prefixText;
  final Widget? prefixWidget;
  final String? suffixText;
  final Widget? suffixIcon;
  final Widget? suffixWidget;
  final BoxConstraints? suffixIconConstraints;

  final Color? bgColor;
  final double? width;
  final double? height;

  final bool isShowCheckmark;
  final EdgeInsets? contentPadding;
  final bool isFaConvert; // تبدیل اعداد فارسی به انگلیسی
  final bool isPersianOnly; // فقط حروف فارسی
  final bool hideErrorText;
  final bool enableScrollPadding;

  const AppTextField({
    super.key,
    this.controller,
    this.labelText,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.autoValidateMode,
    this.onTap,
    this.onSaved,
    this.onEditingComplete,
    this.isEnabled = true,
    this.isObscureText = false,
    this.isReadOnly = false,
    this.isAutoFocus = false,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 1,
    this.textInputAction,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.helperText,
    this.hintText,
    this.prefixText,
    this.prefixWidget,
    this.suffixText,
    this.suffixIcon,
    this.suffixWidget,
    this.suffixIconConstraints,
    this.bgColor,
    this.width,
    this.height,
    this.isShowCheckmark = false,
    this.contentPadding,
    this.isFaConvert = true,
    this.isPersianOnly = false,
    this.hideErrorText = false,
    this.enableScrollPadding = false,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // برای نمایش تیک سبز ولیدیشن
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier(false);
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextFormField(
        // --- Core Properties ---
        controller: widget.controller,
        initialValue: widget.initialValue,
        enabled: widget.isEnabled,
        readOnly: widget.isReadOnly,
        obscureText: widget.isObscureText,
        autofocus: widget.isAutoFocus,
        focusNode: _focusNode,

        // --- Actions ---
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        onEditingComplete: widget.onEditingComplete,
        onSaved: widget.onSaved,
        onTap: widget.onTap,
        onTapOutside: (event) {
          // بستن کیبورد وقتی بیرون کلیک شد
          FocusScope.of(context).unfocus();
        },

        // --- Styling ---
        style: AppInputStyles.textStyle,
        textAlign: widget.textAlign,
        textDirection: widget.textDirection,
        cursorColor: Get.theme.colorScheme.primary,

        // --- Validation ---
        autovalidateMode: widget.autoValidateMode,
        validator: (value) {
          final result = widget.validator?.call(value);
          // آپدیت وضعیت برای نمایش تیک سبز
          if (mounted) {
            _isValidNotifier.value =
                result == null && (value?.isNotEmpty ?? false);
          }
          return result;
        },

        // --- Input Configuration ---
        maxLength: widget.maxLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines == 0 ? null : widget.maxLines,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,

        // --- Formatters ---
        inputFormatters: [
          // تبدیل اعداد فارسی به انگلیسی
          // if (widget.isFaConvert) FaToEnFormatter(),

          // محدودیت تایپ فارسی
          /*
          if (widget.isPersianOnly)
            PersianInputFormatter(
              onInvalidCharacter: () {
                ToastUtil.show(
                  'لطفاً زبان کیبورد را فارسی کنید',
                  type: ToastType.warning,
                );
              },
            ),
           */

          // فقط عدد
          if (widget.keyboardType == TextInputType.number)
            FilteringTextInputFormatter.digitsOnly,

          ...?widget.inputFormatters,
        ],

        scrollPadding:
            widget.enableScrollPadding
                ? EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 100,
                )
                : const EdgeInsets.all(20.0),

        // --- Decoration ---
        decoration: InputDecoration(
          // Text & Labels
          labelText: widget.labelText,
          labelStyle: AppInputStyles.labelStyle,
          hintText: widget.hintText,
          hintStyle: AppInputStyles.hintStyle,
          helperText: widget.helperText,
          helperStyle: AppInputStyles.helperStyle,
          counterText: '', // مخفی کردن کانتر پیش‌فرض
          // Colors & Fill
          filled: widget.bgColor != null,
          fillColor: widget.bgColor,

          // Borders (از کلاس AppInputStyles)
          border: AppInputStyles.normalBorder,
          enabledBorder: AppInputStyles.normalBorder,
          focusedBorder: AppInputStyles.focusedBorder,
          errorBorder: AppInputStyles.errorBorder,
          focusedErrorBorder: AppInputStyles.focusedErrorBorder,
          disabledBorder: AppInputStyles.disabledBorder,

          // Error Text Visibility
          errorStyle:
              widget.hideErrorText
                  ? const TextStyle(height: 0, fontSize: 0) // مخفی کردن کامل
                  : AppInputStyles.errorStyle,

          contentPadding:
              widget.contentPadding ??
              EdgeInsets.symmetric(
                horizontal: AppSize.p16,
                vertical: AppSize.p10,
              ),

          // --- Prefix ---
          prefixText: widget.prefixText,
          prefixStyle: AppInputStyles.prefixStyle,
          prefixIcon: _buildPrefix(),

          // --- Suffix ---
          suffixText: widget.suffixText,
          suffixStyle: AppInputStyles.prefixStyle, // استفاده از همان استایل
          suffixIconConstraints: widget.suffixIconConstraints,
          suffixIcon: widget.suffixIcon,
          suffix: widget.suffixWidget,
        ),
      ),
    );
  }

  /// ساخت ویجت Prefix شامل کاستوم ویجت و تیک سبز ولیدیشن
  Widget? _buildPrefix() {
    // اگر نه ویجت داریم نه تیک سبز می‌خواهیم، نال برگردان
    if (widget.prefixWidget == null && !widget.isShowCheckmark) return null;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.p8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // فاصله کوچک
          AppSize.p4.width,

          // ویجت کاستوم کاربر
          if (widget.prefixWidget != null) widget.prefixWidget!,

          // تیک سبز (فقط اگر ولیدیشن پاس شده باشد)
          if (widget.isShowCheckmark)
            ValueListenableBuilder<bool>(
              valueListenable: _isValidNotifier,
              builder: (context, isValid, child) {
                if (!isValid) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(
                    right: AppSize.p8,
                  ), // فاصله با آیکون قبلی
                  child: const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.green,
                    size: 20,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
